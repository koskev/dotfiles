{
  lib,
  ...
}:
{
  environment.etc."www/pubkey.txt".source = ./files/pubkey.txt;
  environment.etc."www/.well-known/security.txt".source = ./files/security.txt;
  services.nginx = {
    enable = true;
    # This is the server section
    virtualHosts =
      let
        addProxy = host: port: {
          ${host} = {
            #forceSSL = true;
            #enableACME = true;
            locations."/" = {
              proxyPass = "http://localhost:${port}";
            };
          };
        };
      in
      {
        "kokev.de" = {
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
              "= /.well-known/security.txt" = {
                extraConfig = txtConfig;
                alias = "/etc/www/.well-known/security.txt";
              };
              "=/pubkey.txt" = {
                extraConfig = txtConfig;
                alias = "/etc/www/pubkey.txt";
              };
            };
        };
      }
      // addProxy "etesync.kokev.de" "3735"
      // addProxy "joplin.kokev.de" "22300"
      // addProxy "ntfy.kokev.de" "8982"
      // addProxy "bitwarden.kokev.de" "8792";

  };
}
