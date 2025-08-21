{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
  };

  # To fix neoclip
  programs.zsh.initContent = ''
    export LD_LIBRARY_PATH=${pkgs.sqlite.out}/lib:$LD_LIBRARY_PATH
  '';

  xdg.configFile.nvim = {
    source = ../../configs/nvim;
  };
}
