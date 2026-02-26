{
  lib,
  config,
  inputs,
  ...
}:
with lib;
let
  userOptions = _: {
    options = {
      modules = mkOption {
        type = types.listOf types.deferredModule;
        description = "List of the modules";
        default = [ ];
      };
    };
  };
  systemOptions = _: {
    options = {
      system = mkOption {
        type = types.str;
        description = "System of the host";
        default = "x86_64-linux";
      };
      useHomeManagerModule = mkOption {
        type = types.bool;
        default = false;
        description = "Use home manager as a module";
      };
      nonNixos = mkOption {
        type = types.bool;
        default = false;
        description = "This system is not using nixos";
      };
      modules = mkOption {
        type = types.listOf types.deferredModule;
        description = "List of the modules";
        default = [ ];
      };
      users = mkOption {
        default = { };
        type = with lib.types; attrsOf (submodule userOptions);
      };
    };
  };
in
{

  options.nixConfigs = lib.mkOption {
    description = "List systems";
    default = { };
    type = with lib.types; attrsOf (submodule systemOptions);
  };
  config = {
    flake =
      let
        commonHomeManagerModules = [
          inputs.self.modules.generic.settings
          inputs.self.modules.homeManager.common
          {
            hostSettings.hostName = lib.mkDefault hostname;
          }
        ];

      in
      {
        nixosConfigurations = lib.concatMapAttrs (hostname: hostSettings: {
          "${hostname}" = inputs.nixpkgs.lib.nixosSystem {
            modules = [
              inputs.disko.nixosModules.disko
              inputs.self.modules.nixos.nixos
              inputs.self.modules.generic.settings
              {
                nixpkgs.hostPlatform = lib.mkDefault hostSettings.system;
                hostSettings.hostName = lib.mkDefault hostname;
                _module.args.pkgs-stable = import inputs.nixpkgs-stable {
                  inherit (hostSettings) system;
                };
              }

            ]
            ++ hostSettings.modules
            ++ lib.optional hostSettings.useHomeManagerModule {
              imports = [
                inputs.home-manager.nixosModules.home-manager
                inputs.self.modules.nixos.homeManager
              ];
              home-manager.users = lib.concatMapAttrs (username: userSettings: {
                ${username}.imports = commonHomeManagerModules ++ userSettings.modules;
              }) hostSettings.users;
            };
          };
        }) (lib.filterAttrs (n: v: !v.nonNixos) config.nixConfigs);
        homeConfigurations = lib.concatMapAttrs (
          hostname: hostSettings:
          lib.concatMapAttrs (username: userSettings: {
            "${username}@${hostname}" = inputs.home-manager.lib.homeManagerConfiguration {
              pkgs = inputs.nixpkgs.legacyPackages.${hostSettings.system};
              modules =
                commonHomeManagerModules
                ++ userSettings.modules
                ++ lib.optional hostSettings.nonNixos {
                  hostSettings.system.nonNixos = true;
                };
            };
          }) hostSettings.users
        ) config.nixConfigs;
      };
  };
}
