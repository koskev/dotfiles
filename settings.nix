_: {
  # TODO: Somehow add some kind of schema? mkOption?
  architecture = "x86_64-linux";
  stateVersion = "25.11"; # Did you read the comment?
  hosts = {
    "kevin-arch" = {
      system = {
        nixos = false;
      };
      users.kevin.profile = "desktop";
    };
    "rpi-drucker" = {
      system = {
        nixos = true;
        rpi = true;
        flake = "/root/nix";
        kubernetes = true;
        useHomeManagerModule = false;
      };
      users.root = {
        profile = "server";
        home = "/root";
      };
    };
    "kokev" = {
      system = {
        nixos = true;
        flake = "/root/nix";
        useHomeManagerModule = true;
        wireguard = {
          addresses = [
            "10.200.200.1/32"
            "fd00::1/64"
          ];
          public_key = "YnBm0BIAJ8SD8bOve7OWWXjk72xBfabcpMljk/kI1Cg=";
          server = {
            enable = true;
            host = "kokev.de";
            listen_port = 51871;
            interface = "ens3";
          };
        };
      };
      users.root = {
        profile = "server";
        home = "/root";
      };
    };
    "kevin-nix" = {
      system = {
        nixos = true;
        flake = "/home/kevin/nix";
        sensors = {
          cpu = "/dev/internal_coretemp/temp1_input";
          water = "/dev/openfanhub/temp1_input";
        };
        wireguard = {
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
      };
      users.kevin = {
        profile = "desktop";
        defaultDesktop = "hyprland";
        waybarTheme = "koskev";
      };
    };
    "kevin-laptop" = {
      system = {
        nixos = true;
        flake = "/home/kevin/nix";
        wireguard = {
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
      };
      users.kevin = {
        profile = "desktop";
        defaultDesktop = "hyprland";
        waybarTheme = "koskev";
      };
    };
    "kevin-deck" = {
      system = {
        nixos = true;
        flake = "/home/kevin/nix";
        useHomeManagerModule = true;
        wireguard = {
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
      users.kevin = {
        profile = "deck";
        defaultDesktop = "hyprland";
        waybarTheme = "koskev";
      };
    };
    "liag0005" = {
      system = {
        nixos = false;
        flake = "/home/kko/nix";
      };
      users.kko = {
        profile = "work";
        defaultDesktop = "hyprland";
        waybarTheme = "koskev";
      };
    };
  };
}
