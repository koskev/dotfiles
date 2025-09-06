{
  settings,
  lib,
  ...
}:
{
  imports = [ ] ++ lib.optional (settings.system.kubernetes or false) ../packages/kubernetes.nix;
}
