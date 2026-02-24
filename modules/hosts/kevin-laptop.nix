{
  inputs,
  lib,
  ...
}:
let
  hostname = "kevin-laptop";
  username = "kevin";
in
{
  nixConfigs.${hostname} = {
    system = "x86_64-linux";
    modules = with inputs.self.modules.nixos; [
      ../../nixos/hosts/${hostname}/configuration.nix
      common
      desktop
      gaming
      waydroid
      virt
      docker
      wireguard
    ];
    users.${username} = {
      modules = with inputs.self.modules.homeManager; [
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
  };
}
