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
        ../../nixos/hosts/${hostname}/configuration.nix
        common
        docker
        wireguard
        (inputs.self.lib.mkHomeManagerModule username hostname)
      ];
    };
    modules.homeManager."${username}@${hostname}" = {

      imports = with inputs.self.modules.homeManager; [
        lsp
      ];
    };
    nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" hostname;
  };
}
