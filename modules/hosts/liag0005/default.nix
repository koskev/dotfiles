{
  inputs,
  ...
}:
let
  hostname = "liag0005";
  username = "kko";
in
{
  nixConfigs.${hostname} = {
    system = "x86_64-linux";
    useHomeManagerModule = true;
    nonNixos = true;
    users.${username} = {
      modules = with inputs.self.modules.homeManager; [
        liag0005
        misc
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
