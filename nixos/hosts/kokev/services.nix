_: {
  services = {
    etebase-server = {
      enable = true;
      port = 3735;
    };
    ntfy-sh = {
      enable = true;
      settings = {
        listen-http = ":${(import ./ports.nix { }).ntfy}";
      };
    };
    vaultwarden = {
      enable = true;
      config = {
        DOMAIN = "https://bitwarden.kokev.de";
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
