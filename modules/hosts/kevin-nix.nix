{
  inputs,
  lib,
  ...
}:
let
  hostname = "kevin-nix";
  username = "kevin";
in
{
  flake = {
    modules.nixos."${hostname}" = {
      imports = with inputs.self.modules.nixos; [
        ../../nixos/hosts/${hostname}/configuration.nix
        common
        desktop
        gaming
        waydroid
        virt
        docker
      ];
    };
    modules.homeManager."${username}@${hostname}" = {
      imports = with inputs.self.modules.homeManager; [
        {
          hostSettings.hostName = lib.mkDefault hostname;
          hostSettings.system.sensors = {
            cpu = "/dev/internal_coretemp/temp1_input";
            water = "/dev/openfanhub/temp1_input";
          };
        }
        misc
        rufaco
        desktop
        lsp
        kubernetes
        neovim
        shell
        base
      ];
    };
    nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" hostname;
    homeConfigurations = inputs.self.lib.mkHomeManager "x86_64-linux" username hostname;
  };
}
