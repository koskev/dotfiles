{
  inputs,
  ...
}:
let
  hostname = "kokev";
  username = "root";
in
{
  nixConfigs.${hostname} = {
    system = "x86_64-linux";
    useHomeManagerModule = true;
    modules = with inputs.self.modules.nixos; [
      inputs.self.modules.nixos.kokev
      common
      docker
      wireguard
      autoupdate
    ];
    users.${username} = {
      modules = with inputs.self.modules.homeManager; [
        neovim
        shell
        base
      ];
    };
  };
}
