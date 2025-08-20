{
  pkgs,
  lib,
  settings,
  nixgl,
  ...
}:
{
  home.packages =
    with pkgs;
    [
      neofetch
      neovim
      sqlite
      git
      curl
      wget
      nixd
      nixfmt
      gawk
      gcc
      zsh
      iconv
      lsd
    ]
    ++ lib.optional (!settings.system.nixos) pkgs.nixgl.auto.nixGLDefault;

  nixGL = {
    inherit (nixgl) packages;
    defaultWrapper = "mesa";
    installScripts = [
      "mesa"
    ];
  };

  # To fix neoclip
  programs.zsh.initContent = ''
    export LD_LIBRARY_PATH=${pkgs.sqlite.out}/lib:$LD_LIBRARY_PATH
  '';

}
