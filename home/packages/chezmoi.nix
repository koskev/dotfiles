{
  pkgs,
  lib,
  ...
}:
{
  home.packages = with pkgs; [
    chezmoi
  ];

  home.activation.chezmoi = lib.hm.dag.entryAfter [ "installPackages" ] ''
    $DRY_RUN_CMD ${pkgs.chezmoi}/bin/chezmoi init --apply koskev/dotfiles
  '';
}
