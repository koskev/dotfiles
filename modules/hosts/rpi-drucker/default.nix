{
  inputs,
  lib,
  ...
}:
let
  hostname = "rpi-drucker";
  username = "root";
in
{
  nixConfigs.${hostname} = {
    system = lib.mkDefault "aarch64-linux";
    useHomeManagerModule = true;
    modules = with inputs.self.modules.nixos; [
      inputs.self.modules.nixos.rpi-drucker
      common
      docker
      octoprint
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
