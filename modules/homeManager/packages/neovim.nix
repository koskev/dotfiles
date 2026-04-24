_: {
  flake.modules.homeManager.neovim =
    {
      pkgs,
      config,
      ...
    }:
    let
      linkNvim = name: {
        "nvim/${name}" = {
          source =
            if config.userSettings.copyNeovimConfig then
              ../../../configs/nvim/${name}
            else
              config.lib.file.mkOutOfStoreSymlink "${config.hostSettings.system.flake}/configs/nvim/${name}";
        };
      };
    in
    {
      home.packages = with pkgs; [
        teamtype

        tree-sitter
      ];
      programs.neovim = {
        enable = true;
        withRuby = false;
        withPython3 = false;
      };

      home.sessionVariables = {
        # To fix neoclip
        LD_LIBRARY_PATH = "${pkgs.sqlite.out}/lib:$LD_LIBRARY_PATH";
      };

      # Link lockfile to flake dir to allow for easy updating by lazyvim
      # Link them one by one to actually link the correct file and not the store
      xdg.configFile = {
      }
      // linkNvim "lazy-lock.json"
      // linkNvim "lua"
      // linkNvim "after"
      // linkNvim "init.lua";
    };
}
