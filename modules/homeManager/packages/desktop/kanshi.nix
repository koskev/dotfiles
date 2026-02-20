_: {
  flake.modules.homeManager.desktop = _: {
    services.kanshi = {
      enable = true;
      settings = [
        {
          profile.name = "home_work";
          profile.outputs = [
            {
              criteria = "eDP-1";
              scale = 1.0;
              position = "1920,0";
            }
            {
              criteria = "BNQ BenQ EX2510 HBL05326019";
              position = "0,0";
              mode = "1920x1080@144Hz";
            }
          ];
        }
        {
          profile.name = "home";
          profile.outputs = [
            {
              criteria = "LG Electronics L227W 0x00039366";
              position = "0,0";
              mode = "1680x1050@60Hz";
            }
            {
              criteria = "BNQ BenQ EX2510 HBL05326019";
              position = "1680,0";
              mode = "1920x1080@144Hz";
            }
          ];
        }
      ];
    };

  };
}
