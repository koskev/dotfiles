{
  pkgs,
  ...
}:
{
  imports = [
    ../packages/glusterfs.nix
  ];

  environment.systemPackages = with pkgs; [
    kubernetes
    kubectl
  ];
}
