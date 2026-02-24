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
      modules = mkOption {
        type = types.listOf types.deferredModule;
        description = "List of the modules";
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
    flake = {
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
              ${username}.imports = [
                inputs.self.modules.generic.settings
                inputs.self.modules.homeManager.common
              ]
              ++ userSettings.modules;
            }) hostSettings.users;

          };

        };
      }) config.nixConfigs;
      homeConfigurations = lib.concatMapAttrs (
        hostname: hostSettings:
        lib.concatMapAttrs (username: userSettings: {
          "${username}@${hostname}" = inputs.home-manager.lib.homeManagerConfiguration {
            pkgs = inputs.nixpkgs.legacyPackages.${hostSettings.system};
            modules = [
              inputs.self.modules.generic.settings
              inputs.self.modules.homeManager.common
            ]
            ++ userSettings.modules;
          };
        }) hostSettings.users
      ) config.nixConfigs;
    };
  };
}
