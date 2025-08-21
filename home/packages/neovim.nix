{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    extraWrapperArgs = [
      "--suffix"
      "LIBRARY_PATH"
      ":"
      # To fix neoclip
      "${pkgs.sqlite.out}/lib:$LD_LIBRARY_PATH"
    ];
  };

  xdg.configFile.nvim = {
    source = ../../configs/nvim;
    recursive = true;
  };
}
