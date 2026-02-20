_: {
  flake.modules.homeManager.desktop =
    {
      self,
      ...
    }:
    {

      programs.rofi = {
        enable = true;
        theme = "rounded-nord-dark";
        extraConfig = {
          show-icons = true;
        };
      };

      xdg.configFile."rofi/themes" = {
        source = "${self}/configs/rofi/themes";
      };
    };
}
