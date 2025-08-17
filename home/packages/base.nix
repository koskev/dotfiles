{ pkgs, ... }:
{
  home.packages = with pkgs; [
    neofetch
    neovim
    sqlite
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

  # To fix neoclip
  programs.zsh.initExtra = ''
    export LD_LIBRARY_PATH=${pkgs.sqlite.out}/lib:$LD_LIBRARY_PATH
  '';

}
