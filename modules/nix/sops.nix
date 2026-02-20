{ inputs, self, ... }:
{

  flake.modules.nixos.nixos = {

    imports = [
      inputs.sops-nix.nixosModules.sops
      {
        sops.defaultSopsFile = "${self}/secrets/secrets.yaml";
      }
    ];
  };
}
