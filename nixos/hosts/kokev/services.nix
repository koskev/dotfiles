{
  config,
  settings,
  ...
}:
let
  ports = import ./ports.nix { };
in
{
  sops = {
    secrets =
      let
        sopsFile = ../../../secrets/${settings.hostname}/vaultwarden.yaml;
      in
      {
        "vaultwarden.env" = {
          inherit sopsFile;
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
      port = ports.etebase;
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
