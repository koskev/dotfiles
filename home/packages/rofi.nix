{
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
    source = ../../configs/rofi/themes;
  };
}
