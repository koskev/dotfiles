{
  inputs,
  ...
}:
let
  hostname = "test-vm";
  username = "admin";

in
{
  nixConfigs.${hostname} = {
    system = "x86_64-linux";
    useHomeManagerModule = true;
    modules = with inputs.self.modules.nixos; [
      common
      test-vm
    ];
    users.${username} = {
      modules = with inputs.self.modules.homeManager; [
        base
        shell
        neovim
        {
          userSettings.copyNeovimConfig = true;
          userSettings.home = "/home/admin";
        }
      ];
    };
  };
}
