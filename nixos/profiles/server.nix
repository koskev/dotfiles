{
  settings,
  lib,
  ...
}:
{
  imports = [
    ../packages/autoupdate.nix
  ]
  ++ lib.optional (settings.system.kubernetes or false) ../packages/kubernetes.nix;
}
