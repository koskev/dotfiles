{
  description = "My dotfile Nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
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
  };
  outputs =
    {
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      settings = import ./settings.nix { };
      pkgs = import nixpkgs { system = settings.system; };
    in
    {
      nixosConfigurations = builtins.mapAttrs (
        key: val:
        nixpkgs.lib.nixosSystem {
          modules = [
            ./nixos/${key}/configuration.nix
            ./nixos/common.nix
          ];
          specialArgs = {
            inherit settings;
          };
        }
      );
      homeConfigurations = nixpkgs.lib.concatMapAttrs (
        hostname: hostSettings:
        let
          userSettings = nixpkgs.lib.concatMapAttrs(username: userSettings: {
            "${username}@${hostname}" = home-manager.lib.homeManagerConfiguration {
              inherit pkgs;
              modules = [
                ./home/profiles/common.nix
                ./home/profiles/${userSettings.profile}.nix
              ];
              extraSpecialArgs = {
                inherit inputs;
                settings = settings // {
                  # Pass in the profile name to properly add the hms alias
                  profile = userSettings.profile;
                  hostname = hostname;
                  username = username;
                  homedir = "/home/${username}";
                };
              };
            };
          })
          hostSettings.users;
        in
          userSettings
      )
      settings.hosts;
    };
}
