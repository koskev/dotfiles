{
  pkgs,
  config,
  settings,
  ...
}:
let
  linkNvim = name: {
    "nvim/${name}" = {
      source = ../../configs/nvim/${name};
    };
  };
in
{
  programs.neovim = {
    enable = true;
  };

  # To fix neoclip
  programs.zsh.initContent = ''
    export LD_LIBRARY_PATH=${pkgs.sqlite.out}/lib:$LD_LIBRARY_PATH
  '';

  # Link lockfile to flake dir to allow for easy updating by lazyvim
  # Link them one by one to actually link the correct file and not the store
  xdg.configFile = {
    "nvim/lazy-lock.json".source =
      config.lib.file.mkOutOfStoreSymlink "${settings.system.flake}/configs/nvim/lazy-lock.json";
  }
  // linkNvim "lua"
  // linkNvim "after"
  // linkNvim "init.lua";
}
