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

  # https://nix-community.github.io/home-manager/index.xhtml#sec-usage-gpu-non-nixos
  nixGL = {
    inherit (nixgl) packages;
    defaultWrapper = "mesa";
    installScripts = [
      "mesa"
    ];
  };

  xdg.configFile.cantata = {
    source = ../../configs/cantata;
  };

}
