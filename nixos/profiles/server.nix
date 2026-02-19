{
  self,
  settings,
  lib,
  ...
}:
{
  imports = [
    self.nixosModules.autoupdate
  ]
  ++ lib.optional (settings.system.kubernetes or false) ../packages/kubernetes.nix;
}
