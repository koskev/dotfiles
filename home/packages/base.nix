{
  pkgs,
  lib,
  settings,
  nixgl,
  ...
}:
{
  home.packages = with pkgs; [
    fastfetch
    sqlite
    git
    curl
    wget
    nixfmt
    gawk
    gcc
    zsh
    iconv
    lsd
    ripgrep
    unzip
    ncdu
    compsize
  ];

  # https://nix-community.github.io/home-manager/index.xhtml#sec-usage-gpu-non-nixos

}
// lib.optionalAttrs (!settings.system.nixos) {
  nixGL = {
    inherit (nixgl) packages;
    vulkan.enable = false;
    defaultWrapper = "mesa";
    installScripts = [
      "mesa"
    ];
  };
}
