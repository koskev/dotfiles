{ lib, ... }:
with lib;
{
  options.hostsettings = {
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
      nixos = mkEnableOption "sets if this is a NixOS installation";
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
    users = mkOption {
      description = "List of users";
      default = { };
      type = types.attrsOf (
        types.submodule (
          { name, ... }:
          {
            options = {
              profile = mkOption {
                description = "Name of the profile";
                type = types.enum [
                  "desktop"
                  "server"
                  "laptop"
                ];
              };
              defaultDesktop = mkOption {
                description = "name of the default desktop";
                type = types.enum [
                  "hyprland"
                  "sway"
                ];
              };
              waybarTheme = mkOption {
                description = "Name of the used waybar theme";
                types = types.str;
              };
              home = mkOption {
                types = types.str;
                default = "/home/${name}";
                description = "Home dir";
              };
            };
          }
        )
      );
    };
  };
}
