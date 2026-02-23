{ inputs, lib, ... }:
{
  flake.lib = {
    mkNixos = system: name: {
      ${name} = inputs.nixpkgs.lib.nixosSystem {
        modules = [
          inputs.self.modules.nixos.${name}
          inputs.disko.nixosModules.disko
          inputs.self.modules.nixos.nixos
          inputs.self.modules.generic.settings
          {
            nixpkgs.hostPlatform = lib.mkDefault system;
            hostSettings.hostName = lib.mkDefault name;
          }
        ];

      };
    };
    mkHomeManager = system: name: hostname: {
      "${name}@${hostname}" = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = inputs.nixpkgs.legacyPackages.${system};
        modules = [
          inputs.self.modules.homeManager."${name}@${hostname}"
          inputs.self.modules.generic.settings
          inputs.self.modules.homeManager.common
        ];
      };
    };

    mkHomeManagerModule = username: modules: {
      imports = [
        inputs.home-manager.nixosModules.home-manager
        inputs.self.modules.nixos.homeManager
      ];
      inputs.home-manager.users.${username}.imports = modules;
    };
  };
}
