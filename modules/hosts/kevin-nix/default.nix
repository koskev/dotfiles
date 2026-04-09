{
  inputs,
  ...
}:
let
  hostname = "kevin-nix";
  username = "kevin";
in
{
  nixConfigs.${hostname} = {
    system = "x86_64-linux";
    modules = with inputs.self.modules.nixos; [
      kevin-nix
      common
      desktop
      gaming
      waydroid
      virt
      wireguard
    ];
    users.${username} = {
      modules = with inputs.self.modules.homeManager; [
        {
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
