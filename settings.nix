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
        flake = "/root/nix";
        kubernetes = true;
        useHomeManagerModule = true;
      };
      users.root = {
        profile = "server";
      };
    };
    "kokev" = {
      system = {
        nixos = true;
        flake = "/root/nix";
        useHomeManagerModule = true;
      };
      users.root = {
        profile = "server";
        home = "/root";
      };
      wireguard = {
        address = "";
        server_key = "";
        server_ip = "";
        server = {
          enable = true;
        };
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
