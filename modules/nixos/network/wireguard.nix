_: {
  flake.modules.nixos.wireguard =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    with lib;
    let
      cfg = config.wireguardSettings.${config.hostSettings.hostName};
      wireguardOptions =
        { ... }:
        {
          options = {
            enable = mkOption {
              type = types.bool;
              default = false;
              description = "enable wireguard";
            };
            addresses = mkOption {
              type = types.listOf types.str;
              description = "Addresses for the wireguard interface";
            };
            public_key = mkOption {
              type = types.str;
              description = "Public key of this instance";
            };
            client = {
              enable = mkOption {
                type = types.bool;
                default = false;
                description = "enable wireguard client mode";
              };
              server = mkOption {
                description = "Name of the server to use";
              };
            };
            server = {
              enable = mkOption {
                type = types.bool;
                default = false;
                description = "enable wireguard server mode";
              };
              host = mkOption {
                type = types.str;
                description = "hostname of the server";
              };
              listen_port = mkOption {
                type = types.port;
                default = 51871;
                description = "port to listen to";
              };
              interface = mkOption {
                type = types.str;
                description = "name of the interface to bind to";
              };
            };
          };
        };
    in
    {
      options.wireguardSettings = mkOption {
        description = "List of all wireguard options";
        default = { };
        type = with lib.types; attrsOf (submodule wireguardOptions);
      };
      config = mkIf cfg.enable {
        sops = {
          secrets =
            let
              sopsFile = ../../../secrets/${config.hostSettings.hostName}/wireguard.yaml;
            in
            {
              "key" = {
                inherit sopsFile;
              };
            };
        };
        environment.systemPackages = with pkgs; [
          wireguard-tools
        ];
        networking = {
          wg-quick.interfaces = {
            wg0 = {
              privateKeyFile = config.sops.secrets."key".path;
              address = cfg.addresses;
            }
            // lib.optionalAttrs cfg.client.enable or false {
              autostart = false;
              peers =
                let
                  serverConfig = config.wireguardSettings.${cfg.client.server};
                in
                [
                  {
                    publicKey = serverConfig.public_key;
                    allowedIPs = [
                      "0.0.0.0/0"
                      "::/0"
                    ];
                    endpoint = "${serverConfig.server.host}:${toString serverConfig.server.listen_port}";
                    persistentKeepalive = 25;
                  }
                ];
            }

            // lib.optionalAttrs cfg.server.enable or false {
              listenPort = cfg.server.listen_port;
              peers =
                let
                  wireguardClients = lib.filterAttrs (n: v: (v.client.enable or false)) config.wireguardSettings;

                in

                lib.mapAttrsToList (name: val: {
                  publicKey = val.public_key;
                  allowedIPs = val.addresses;
                }) wireguardClients;
              # This allows the wireguard server to route your traffic to the internet and hence be like a VPN
              postUp = ''
                ${pkgs.iptables}/bin/iptables -A FORWARD -i wg0 -j ACCEPT
                ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -o ${cfg.server.interface} -j MASQUERADE

                ${pkgs.iptables}/bin/ip6tables -A FORWARD -i wg0 -j ACCEPT
                ${pkgs.iptables}/bin/ip6tables -t nat -A POSTROUTING -o ${cfg.server.interface} -j MASQUERADE
              '';

              postDown = ''
                ${pkgs.iptables}/bin/iptables -D FORWARD -i wg0 -j ACCEPT
                ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -o ${cfg.server.interface} -j MASQUERADE

                ${pkgs.iptables}/bin/ip6tables -D FORWARD -i wg0 -j ACCEPT
                ${pkgs.iptables}/bin/ip6tables -t nat -D POSTROUTING -o ${cfg.server.interface} -j MASQUERADE
              '';
            };
          };
        }
        // lib.optionalAttrs cfg.server.enable or false {
          nat = {
            enable = true;
            enableIPv6 = true;
            externalInterface = "${cfg.server.interface}";
            internalInterfaces = [ "wg0" ];
          };
          firewall.allowedUDPPorts = [
            cfg.server.listen_port
          ];
        };
      };
    };
}
