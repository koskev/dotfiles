_: {
  flake.nixosModules.wireguard =
    {
      config,
      settings,
      lib,
      pkgs,
      ...
    }:
    lib.optionalAttrs
      (
        settings.system.wireguard.client.enable or false || settings.system.wireguard.server.enable or false
      )
      {
        sops = {
          secrets =
            let
              sopsFile = ../../../secrets/${settings.hostname}/wireguard.yaml;
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
              address = settings.system.wireguard.addresses;
            }
            // lib.optionalAttrs settings.system.wireguard.client.enable or false {
              autostart = false;
              peers =
                let
                  serverConfig = settings.hosts.${settings.system.wireguard.client.server}.system.wireguard;
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

            // lib.optionalAttrs settings.system.wireguard.server.enable or false {
              listenPort = settings.system.wireguard.server.listen_port or 51820;
              peers =
                let
                  wireguardClients = lib.filterAttrs (
                    n: v: (v.system.wireguard.client.enable or false)
                  ) settings.hosts;

                in

                lib.mapAttrsToList (name: val: {
                  publicKey = val.system.wireguard.public_key;
                  allowedIPs = val.system.wireguard.addresses;
                }) wireguardClients;
              # This allows the wireguard server to route your traffic to the internet and hence be like a VPN
              postUp = ''
                ${pkgs.iptables}/bin/iptables -A FORWARD -i wg0 -j ACCEPT
                ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -o ${settings.system.wireguard.server.interface} -j MASQUERADE

                ${pkgs.iptables}/bin/ip6tables -A FORWARD -i wg0 -j ACCEPT
                ${pkgs.iptables}/bin/ip6tables -t nat -A POSTROUTING -o ${settings.system.wireguard.server.interface} -j MASQUERADE
              '';

              postDown = ''
                ${pkgs.iptables}/bin/iptables -D FORWARD -i wg0 -j ACCEPT
                ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -o ${settings.system.wireguard.server.interface} -j MASQUERADE

                ${pkgs.iptables}/bin/ip6tables -D FORWARD -i wg0 -j ACCEPT
                ${pkgs.iptables}/bin/ip6tables -t nat -D POSTROUTING -o ${settings.system.wireguard.server.interface} -j MASQUERADE
              '';
            };
          };
        }
        // lib.optionalAttrs settings.system.wireguard.server.enable or false {
          nat = {
            enable = true;
            enableIPv6 = true;
            externalInterface = "${settings.system.wireguard.server.interface}";
            internalInterfaces = [ "wg0" ];
          };
        };
      };
}
