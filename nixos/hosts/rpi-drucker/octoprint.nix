{ config, settings, ... }:
{

  services = {
    octoprint = {
      enable = true;
      openFirewall = true;
    };
    nginx = {
      enable = true;

      virtualHosts = {
        "octoprint.kokev.de" = {
          forceSSL = true;
          acmeRoot = null;
          enableACME = true;
          locations."/" = {
            proxyPass = "http://localhost:${toString config.services.octoprint.port}";
          };
        };
      };
    };
  };

  sops = {
    secrets =
      let
        sopsFile = ../../../secrets/${settings.hostname}/acme.yaml;
      in
      {
        "desec_token" = {
          inherit sopsFile;
          owner = "nginx";
        };
      };
  };

  security = {
    acme = {
      acceptTerms = true;
      defaults = {
        email = "letsencrypt@kokev.de";
        dnsProvider = "desec";
        credentialFiles = {
          "DESEC_TOKEN_FILE" = config.sops.secrets.desec_token.path;
        };
      };
    };
  };
}
