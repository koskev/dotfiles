_: {
  wayland.windowManager.sway = {
    enable = true;
    checkConfig = true;
    extraConfig = builtins.readFile ./sway.conf;
    config = null;
  };
}
