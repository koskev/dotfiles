_: {
  flake.modules.nixos.kokev =
    {
      config,
      pkgs-stable,
      ...
    }:
    let
      ports = import ./_ports.nix { };
    in
    {
      sops = {
        secrets =
          let
            vaultwarden = ../../../secrets/${config.hostSettings.hostName}/vaultwarden.yaml;
            etebase = ../../../secrets/${config.hostSettings.hostName}/etebase.yaml;
          in
          {
            "vaultwarden.env" = {
              sopsFile = vaultwarden;
            };
            "etebase.secret" = {
              sopsFile = etebase;
              owner = "etebase-server";
            };
          };
      };
      services = {
        nullmailer = {
          enable = true;
          config = {
            remotes = "127.0.0.1 smtp";
            defaultdomain = "de";
          };
        };
        etebase-server = {
          enable = true;
          # Unstable is currently broken
          package = pkgs-stable.etebase-server;
          #port = ports.etebase;
          unixSocket = "/var/lib/etebase-server/etebase-server.sock";
          settings = {
            allowed_hosts.allowed_host1 = "etesync.kokev.de";
            global.secret_file = config.sops.secrets."etebase.secret".path;
            global.debug = false;
          };
        };
        ntfy-sh = {
          enable = true;
          settings = {
            listen-http = ":${toString ports.ntfy}";
            base-url = "https://ntfy.kokev.de";
          };
        };
        vaultwarden = {
          enable = true;
          environmentFile = config.sops.secrets."vaultwarden.env".path;
          config = {
            DOMAIN = "https://bitwarden.kokev.de";
            ROCKET_PORT = ports.vaultwarden;
            WEBSOCKET_ENABLED = true; # Enable WebSocket notifications
            SIGNUPS_ALLOWED = false;

            SMTP_HOST = "mail.kokev.de";
            SMTP_PORT = 25;
            SMTP_SECURITY = "starttls";

            SMTP_FROM = "bitwarden@kokev.de";
            SMTP_FROM_NAME = "Vaultwarden";
          };

        };
        prometheus.exporters = {
          node = {
            enable = true;
          };
        };
      };
      virtualisation.oci-containers.containers = {
        "joplin" = {
          # renovate: datasource=docker
          image = "docker.io/joplin/server:3.5.2@sha256:5d9e7f9d31b436cb1b99d1a6a65d8c5bf760829094617e8ad1e956fd925de888";
          environment = {
            APP_BASE_URL = "https://joplin.kokev.de";
            APP_PORT = "22300";
            DB_CLIENT = "sqlite3";
            SQLITE_DATABASE = "/db/joplin.db";
          };
          ports = [
            "22300:22300/tcp"
          ];
          log-driver = "journald";
          volumes = [
            "/root/docker-container/joplin/data/sqlite:/db/:rw"
          ];
        };
      };
    };
}
