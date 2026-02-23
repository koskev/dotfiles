{
  inputs,
  ...
}:
let
  hostname = "kokev";
  username = "root";
in
{
  flake = {
    modules.nixos."${hostname}" = {
      imports = with inputs.self.modules.nixos; [
        common
        docker
        wireguard
        autoupdate
        (inputs.self.lib.mkHomeManagerModule username hostname)
      ];
    };
    modules.homeManager."${username}@${hostname}" = {

      imports = with inputs.self.modules.homeManager; [
        lsp
        neovim
        shell
        base
      ];
    };
    nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" hostname;
  };
}
