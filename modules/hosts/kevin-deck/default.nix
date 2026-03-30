{
  inputs,
  pkgs,
  ...
}:
let
  hostname = "kevin-deck";
  username = "kevin";
in
{
  # TODO: There are probably still some packets missing. Check on next update
  nixConfigs.${hostname} = {
    system = "x86_64-linux";
    useHomeManagerModule = true;
    modules = with inputs.self.modules.nixos; [
      inputs.jovian.nixosModules.default
      kevin-deck
      gaming
      desktop
      common
      wireguard
    ];
    users.${username} = {
      modules = with inputs.self.modules.homeManager; [
        neovim
        shell
        base
        deck-emulation
      ];
    };
  };
}
