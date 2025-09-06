_:
let
  ports = import ./ports.nix { };
in
{
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
      config = {
        DOMAIN = "https://bitwarden.kokev.de";
        ROCKET_PORT = ports.vaultwarden;
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
