_: {
  flake.modules.nixos.wireguard =
    { lib, ... }:
    {
      wireguardSettings = {
        kevin-nix = {
          enable = true;
          addresses = [
            "10.200.200.2/32"
            "fd00::2/64"
          ];
          public_key = "7ZU/0Z040UhoL0+5nG51vBlNj22RocojWUq0UHqpZRo=";
          client = {
            enable = true;
            server = "kokev";
          };
        };
        kokev = {
          enable = true;
          addresses = [
            "10.200.200.1/32"
            "fd00::1/64"
          ];
          public_key = "YnBm0BIAJ8SD8bOve7OWWXjk72xBfabcpMljk/kI1Cg=";
          server = {
            enable = true;
            host = "kokev.de";
            listen_port = lib.mkDefault 51871;
            interface = lib.mkForce "ens3";
          };
        };
        kevin-laptop = {
          enable = true;
          addresses = [
            "10.200.200.3/32"
            "fd00::3/64"
          ];
          public_key = "NBEu8T7lx8HVl4zKlRuBsV4un3lPkdh6w0IC+sF6iw0=";
          client = {
            enable = true;
            server = "kokev";
          };
        };

        kevin-deck = {
          enable = true;
          addresses = [
            "10.200.200.4/32"
            "fd00::4/64"
          ];
          public_key = "HE6unv/YLKTN71Xyi/sEUZLRYwbZoluhXxVhP6sFNX8=";
          client = {
            enable = true;
            server = "kokev";
          };
        };

      };
    };
}
