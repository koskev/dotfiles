{
  config,
  settings,
  pkgs-stable,
  ...
}:
let
  ports = import ./ports.nix { };
in
{
  sops = {
    secrets =
      let
        vaultwarden = ../../../secrets/${settings.hostname}/vaultwarden.yaml;
        etebase = ../../../secrets/${settings.hostname}/etebase.yaml;
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
}
