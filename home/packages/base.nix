{ pkgs, ... }:
{
  home.packages = with pkgs; [
    neofetch
    neovim
    git
    curl
    wget
    nixd
    nixfmt
    chezmoi
    gawk
    gcc
    zsh
    iconv
    lsd
  ];
}
