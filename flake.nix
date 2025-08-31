{
  description = "My dotfile Nix";

  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    # TODO: switch nixkpgs to 25.11 once it is released
    #nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
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
      url = "git+https://forgejo.kokev.de/kevin/grustonnet-ls.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };
  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      nur,
      nixgl,
      disko,
      sops-nix,
      ...
    }@inputs:
    let
      inherit (nixpkgs) lib;
      settings = import ./settings.nix { };
      pkgs = import nixpkgs {
        system = settings.architecture;
        overlays = [
          nur.overlays.default
          nixgl.overlay
        ];
      };
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
        let
          userSettings = nixpkgs.lib.concatMapAttrs (username: userSettings: {
            # TODO: this does not support multiple users. The loop needs to be further down
            "${hostname}" = nixpkgs.lib.nixosSystem {
              modules = [
                ./nixos/hosts/${hostname}/configuration.nix
                ./nixos/profiles/${userSettings.profile}.nix
                ./nixos/common.nix
                disko.nixosModules.disko
                home-manager.nixosModules.home-manager
              ]
              ++ sopsModules
              ++ lib.optional (hostSettings.system.useHomeManagerModule or false) {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  users.${username} = import ./home/profiles/${userSettings.profile}.nix;
                  extraSpecialArgs = {
                    inherit inputs;
                    inherit nixgl;
                    inherit nixpkgs-unstable;
                    settings = settingsUser userSettings hostSettings username hostname;
                  };
                };
              };
              specialArgs = {
                inherit nixpkgs-unstable;
                settings = settingsUser userSettings hostSettings username hostname;
              };
            };
          }) hostSettings.users or { };
        in
        userSettings
      ) nixOSHosts;
      userSettings = nixpkgs.lib.concatMapAttrs (username: userSettings: {
      }) nixOSHosts;
      homeConfigurations = nixpkgs.lib.concatMapAttrs (
        hostname: hostSettings:
        let
          userSettings = nixpkgs.lib.concatMapAttrs (username: userSettings: {
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
                settings = settingsUser userSettings hostSettings username hostname;
              };
            };
          }) hostSettings.users;
        in
        userSettings
      ) nonNixOSHosts;
    };
}
