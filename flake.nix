{
  description = "My dotfile Nix";

  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    # TODO: switch nixkpgs to 25.11 once it is released
    #nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    # follow `main` branch of this repository, considered being stable
    nixos-raspberrypi.url = "github:nvmd/nixos-raspberrypi/v1.20260102.0";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      # IMPORTANT: we're using "libgbm" and is only available in unstable so ensure
      # to have it up-to-date or simply don't specify the nixpkgs input
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    disko.url = "github:nix-community/disko";
    sops-nix.url = "github:Mic92/sops-nix";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rufaco = {
      url = "github:koskev/rufaco";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    swayautonames = {
      url = "github:koskev/swayautonames";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pushtotalk = {
      url = "github:koskev/PushToTalk";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    grustonnet = {
      url = "github:koskev/grustonnet-ls";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vrl-ls = {
      url = "github:koskev/vrl-ls";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    jsonnet-debugger = {
      url = "github:koskev/jsonnet-debugger";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # For steam deck
    jovian = {
      url = "github:jovian-experiments/jovian-nixos/development";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    difftastic = {
      url = "github:koskev/difftastic?ref=feature/jsonnet";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mergiraf = {
      url = "git+https://codeberg.org/kokev/mergiraf.git?ref=feature/jsonnet";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    extra-substituters = [
      "https://nixos-raspberrypi.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
    ];
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      nixpkgs-stable,
      home-manager,
      nur,
      nixgl,
      disko,
      sops-nix,
      nixos-raspberrypi,
      ...
    }@inputs:
    let
      inherit (nixpkgs) lib;
      settings = import ./settings.nix { };
      nixOSHosts = lib.filterAttrs (n: v: (v.system.nixos or false)) settings.hosts;
      #nonNixOSHosts = lib.filterAttrs(n: v: (!v.system.nixos or false)) settings.hosts;
      nonNixOSHosts = settings.hosts;

      settingsUser =
        userSettings: hostSettings: username: hostname:
        settings
        // {
          # Pass in the profile name to properly add the hms alias
          inherit userSettings;
          inherit (hostSettings) system;
          inherit hostname;
          inherit username;
          homedir = userSettings.home or "/home/${username}";
        };
      sopsModules = [
        sops-nix.nixosModules.sops
        {
          sops.defaultSopsFile = ./secrets/secrets.yaml;
        }
      ];
    in
    {
      nixosConfigurations = nixpkgs.lib.concatMapAttrs (
        hostname: hostSettings:
        nixpkgs.lib.concatMapAttrs (
          username: userSettings:
          let
            nix_system =
              if hostSettings.system.rpi or false then
                nixos-raspberrypi.lib.nixosSystemFull
              else
                nixpkgs.lib.nixosSystem;
            extra_modules =
              if hostSettings.system.rpi or false then
                with nixos-raspberrypi.nixosModules;
                [
                  raspberry-pi-3.base
                  usb-gadget-ethernet
                ]
              else
                [ ];
            pkgs-stable = import nixpkgs-stable {
              system = hostSettings.system.architecture or "x86_64-linux";
              overlays = [
                nur.overlays.default
                nixgl.overlay
              ];
            };

          in
          {
            # TODO: this does not support multiple users. The loop needs to be further down
            "${hostname}" = nix_system {
              modules = [
                ./nixos/hosts/${hostname}/configuration.nix
                ./nixos/profiles/${userSettings.profile}.nix
                ./nixos/common.nix
                disko.nixosModules.disko
                home-manager.nixosModules.home-manager
              ]
              ++ extra_modules
              ++ sopsModules
              ++ lib.optional (hostSettings.system.useHomeManagerModule or false) {
                home-manager = {
                  useGlobalPkgs = false;
                  useUserPackages = true;
                  backupFileExtension = "backup";
                  users.${username} = {
                    imports = [
                      ./home/profiles/common.nix
                      ./home/profiles/${userSettings.profile}.nix
                    ];
                  };
                  extraSpecialArgs = {
                    inherit inputs;
                    inherit nixgl;
                    inherit nixpkgs-unstable;
                    inherit pkgs-stable;
                    settings = settingsUser userSettings hostSettings username hostname;
                  };
                };
              };
              specialArgs = {
                inherit inputs;
                inherit nixpkgs-unstable;
                inherit pkgs-stable;
                inherit nixos-raspberrypi;
                settings = settingsUser userSettings hostSettings username hostname;
              };
            };
          }
        ) hostSettings.users or { }
      ) nixOSHosts;

      homeConfigurations = nixpkgs.lib.concatMapAttrs (
        hostname: hostSettings:
        nixpkgs.lib.concatMapAttrs (
          username: userSettings:
          let
            pkgs = import nixpkgs {
              system = hostSettings.system.architecture or "x86_64-linux";
              overlays = [
                nur.overlays.default
                nixgl.overlay
              ];
            };
            pkgs-stable = import nixpkgs-stable {
              system = hostSettings.system.architecture or "x86_64-linux";
              overlays = [
                nur.overlays.default
                nixgl.overlay
              ];
            };

          in
          {
            "${username}@${hostname}" = home-manager.lib.homeManagerConfiguration {
              inherit pkgs;
              modules = [
                ./home/profiles/common.nix
                ./home/profiles/${userSettings.profile}.nix
              ];
              extraSpecialArgs = {
                inherit inputs;
                inherit nixgl;
                inherit nixpkgs-unstable;
                inherit pkgs-stable;
                settings = settingsUser userSettings hostSettings username hostname;
              };
            };
          }
        ) hostSettings.users
      ) nonNixOSHosts;
    };
}
