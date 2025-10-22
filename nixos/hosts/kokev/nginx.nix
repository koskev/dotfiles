{
  config,
  settings,
  ...
}:
{
  environment.etc = {
    "www/pubkey.txt".source = ./files/pubkey.txt;
    "www/.well-known/security.txt".source = ./files/security.txt;
  };
  sops = {
    secrets =
      let
        sopsFile = ../../../secrets/${settings.hostname}/nginx.yaml;
      in
      {
        "prometheus" = {
          inherit sopsFile;
          owner = "nginx";
        };
      };
  };
  services.nginx = {
    enable = true;
    # This is the server section
    virtualHosts =
      let
        addProxy = proxyUrl: host: {
          ${host} = {
            forceSSL = true;
            enableACME = true;
            locations."/" = {
              proxyPass = "${proxyUrl}";
              extraConfig = ''
                # Upgrade for websockets. Sould be fine to do it on every connection
                proxy_set_header Upgrade $http_upgrade;
                proxy_set_header Connection "upgrade";

                proxy_set_header Host $host;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header X-Forwarded-Host $server_name;
              '';

            };
          };
        };
        addLocalhostProxy = host: port: addProxy "http://localhost:${port}" host;
      in
      {
        # XXX: Using security.acme.certs results in a cert with Issuer: CN=minica root ca 056599
        "mail.kokev.de" = {
          forceSSL = true;
          enableACME = true;
        };
        "kokev.de" = {
          forceSSL = true;
          enableACME = true;
          locations =
            let
              txtConfig = ''
                add_header Content-Type 'text/plain';
                add_header Cache-Control 'no-cache, no-store, must-revalidate';
                add_header Pragma 'no-cache';
                add_header Expires '0';
                add_header Vary '*';
              '';

            in
            {
              "/robots.txt" = {
                return = ''200 "User-agent: *\nDisallow: /"'';
              };
              "/ai.txt" = {
                return = ''200 "User-agent: *\nDisallow: /\nDisallow: *"'';
              };
              "= /.well-known/security.txt" = {
                extraConfig = txtConfig;
                alias = "/etc/www/.well-known/security.txt";
              };
              "=/pubkey.txt" = {
                extraConfig = txtConfig;
                alias = "/etc/www/pubkey.txt";
              };
              "/" = {
                extraConfig = ''
                  add_header Content-Type text/plain;
                '';

                return = ''200 "Nothing to see"'';
              };
              "/metrics/" = {
                proxyPass = "http://localhost:9100/metrics";
                # XXX: Nix does not offer a way to properly specify the realm
                extraConfig = ''
                  auth_basic "Prometheus";
                  auth_basic_user_file ${config.sops.secrets.prometheus.path};
                '';

              };
            };
        };
      }
      // addProxy "http://unix:/var/lib/etebase-server/etebase-server.sock" "etesync.kokev.de"
      // addLocalhostProxy "joplin.kokev.de" "22300"
      // addLocalhostProxy "ntfy.kokev.de" "${toString (import ./ports.nix { }).ntfy}"
      // addLocalhostProxy "bitwarden.kokev.de" "${toString config.services.vaultwarden.config.ROCKET_PORT}";
  };
}
