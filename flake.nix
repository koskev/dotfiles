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
      nixosConfigurations = {
        "kevin-nix" = nixpkgs.lib.nixosSystem {
          modules = [
            ./nixos/kevin-nix/configuration.nix
          ];
          specialArgs = {
            inherit settings;
          };
        };
      };
      homeConfigurations = {
        "desktop" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./home/profiles/desktop.nix
            ./home/profiles/common.nix
            inputs.zen-browser.homeModules.twilight
          ];
          extraSpecialArgs = {
            settings = settings // {
              # Pass in the profile name to properly add the hms alias
              # TODO: fix this. Maybe use hostnames?
              profile = "desktop";
            };
          };
        };
        "work" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./home/profiles/work.nix
            ./home/profiles/desktop.nix
            ./home/profiles/common.nix
            inputs.zen-browser.homeModules.twilight
          ];
          extraSpecialArgs = {
            settings = settings // {
              profile = "work";
            };
          };
        };
      };
    };
}
