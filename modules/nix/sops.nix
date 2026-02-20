{ inputs, ... }:
{

  flake.modules.nixos.nixos = {

    imports = [
      inputs.sops-nix.nixosModules.sops
      {
        sops.defaultSopsFile = ../../secrets/secrets.yaml;
      }
    ];
  };
}
