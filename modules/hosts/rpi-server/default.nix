{
  inputs,
  lib,
  ...
}:
let
  hostname = "rpi-server";
  username = "root";
in
{
  nixConfigs.${hostname} = {
    system = lib.mkDefault "aarch64-linux";
    useHomeManagerModule = true;
    modules = with inputs.self.modules.nixos; [
      inputs.self.modules.nixos.${hostname}
      common
      docker
      kubernetes
      glusterfs
      {
        userSettings.home = "/root";
      }
    ];
    users.${username} = {
      modules = with inputs.self.modules.homeManager; [
        neovim
        shell
        base
        {
          userSettings.home = "/root";
        }
      ];
    };
  };
}
