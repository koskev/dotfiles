_: {
  flake.modules.generic.settings =
    { config, lib, ... }:
    with lib;
    {
      options = {
        userSettings = {
          userName = mkOption {
            type = types.str;
            description = "The name of the user";
            default = "kevin";
          };
          stateVersion = mkOption {
            type = types.str;
            description = "DONT CHANGE THIS!!!";
            default = "25.11"; # Did you read the comment?
          };
          flakeLocation = mkOption {
            type = types.str;
            description = "Location of the flake for nh";
            default = "~/nix";
          };
          defaultDesktop = mkOption {
            description = "name of the default desktop";
            type = types.enum [
              "hyprland"
              "sway"
            ];
            default = "hyprland";
          };
          waybarTheme = mkOption {
            description = "Name of the used waybar theme";
            type = types.str;
            default = "koskev";
          };
          home = mkOption {
            type = types.str;
            default = "/home/${config.userSettings.userName}";
            description = "Home dir";
          };
        };
        hostSettings = {
          hostName = mkOption {
            type = types.str;
            description = "The hostname";
          };

          # TODO: Somehow add some kind of schema? mkOption?
          architecture = mkOption {
            type = types.str;
            default = "x86_64-linux";
          };
          stateVersion = mkOption {
            type = types.str;
            description = "DONT CHANGE THIS!!!";
            default = "25.11"; # Did you read the comment?
          };

          name = mkOption {
            type = types.str;
            description = "Name of the host";
          };
          system = {
            nonNixos = mkEnableOption "sets if this is a not a NixOS installation";
            rpi = mkEnableOption "sets if this is a RasperryPI";
            flake = mkOption {
              default = "~/nix";
              description = "Location of the nix flake";
            };
            kubernetes = mkEnableOption "enable kubernetes node";
            useHomeManagerModule = mkEnableOption "use home manager as a NixOS module";
            wireguard = {
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
                listen_port = {
                  type = types.port;
                  default = 51871;
                  description = "port to listen to";
                };
                interface = {
                  type = types.str;
                  description = "name of the interface to bind to";
                };
              };
            };
            sensors = {
              cpu = mkOption {
                type = types.str;
                description = "Path to the cpu temperature";
              };
              water = mkOption {
                type = types.str;
                description = "Path to the water temperature";
              };
            };
          };
        };
      };
    };
}
