_: {
  flake.modules.nixos.octoprint =
    { config, ... }:
    {

      services = {
        octoprint = {
          enable = true;
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
                extraConfig = ''
                  proxy_set_header Host $host;
                  proxy_set_header Upgrade $http_upgrade;
                  proxy_set_header Connection "upgrade";
                  proxy_set_header X-Real-IP $remote_addr;
                  proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                  proxy_set_header X-Scheme $scheme;
                  proxy_http_version 1.1;

                  client_max_body_size 0;
                '';
              };
            };
          };
        };
      };
      networking.firewall = {
        allowedTCPPorts = [
          80
          443
        ];
      };

      sops = {
        secrets =
          let
            sopsFile = ../../../secrets/${config.hostSettings.hostName}/acme_token;
          in
          {
            "desec_token" = {
              inherit sopsFile;
              format = "binary";
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
    };
}
