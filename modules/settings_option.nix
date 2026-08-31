_: {
  flake.modules.generic.settings =
    {
      config,
      lib,
      pkgs,
      ...
    }:
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
          defaultDesktop = mkOption {
            description = "name of the default desktop";
            type = types.enum [
              "hyprland"
              "sway"
            ];
            default = "hyprland";
          };
          desktopBar = mkOption {
            description = "which bar to use";
            type = types.enum [
              "waybar"
              "noctalia5"
            ];
            default = "waybar";
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

          copyNeovimConfig = mkEnableOption "copies the neovim config instead of linking it";
          professional = mkOption {
            type = types.bool;
            default = false;
            description = "Try to be somewhat professional and disable stuff like anime pictures :(";
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
          root = {
            shell = mkOption {
              default = pkgs.zsh;
              description = "Default shell for the root user";
            };
            keys = mkOption {
              type = types.listOf types.str;
              default = [
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB/TBxpOVXoWVtMV77vC8nUBsG0GpBj6ydjc4P59mChf kevin@kevin-arch"
              ];
              description = "Known ssh keys with access to the root user";
            };
          };
          system = {
            nonNixos = mkEnableOption "sets if this is a not a NixOS installation";
            rpi = mkEnableOption "sets if this is a RasperryPI";
            flake = mkOption {
              default = "${config.userSettings.home}/nix";
              description = "Location of the nix flake";
            };
            kubernetes = mkEnableOption "enable kubernetes node";
            useHomeManagerModule = mkEnableOption "use home manager as a NixOS module";
            monitors = mkOption {
              type = types.listOf (
                types.submodule {
                  options = {
                    output = mkOption {
                      type = types.str;
                      description = "Port of the monitor e.g. DP-1";
                    };
                    mode = mkOption {
                      type = types.str;
                      description = "Resolution and refresh rate. e.g. 1920x1080@144";
                    };
                    position = mkOption {
                      type = types.str;
                      description = "Position of the monitor. e.g. 0x0";
                      default = "0x0";
                    };
                    scale = mkOption {
                      type = types.number;
                      description = "Scale of the monitor. e.g. 0.5";
                      default = 1.0;
                    };
                  };
                }
              );
            };
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
                default = "";
              };
              water = mkOption {
                type = types.str;
                description = "Path to the water temperature";
                default = "";
              };
            };
          };
        };
      };
    };
}
