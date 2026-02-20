{
  self,
  settings,
  lib,
  ...
}:
{
  imports = [
    self.modules.nixos.autoupdate
  ]
  ++ lib.optional (settings.system.kubernetes or false) ../packages/kubernetes.nix;
}
