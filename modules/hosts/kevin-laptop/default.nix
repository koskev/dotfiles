{
  inputs,
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
      kevin-laptop
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
