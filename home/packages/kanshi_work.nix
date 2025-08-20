_: {
  services.kanshi = {
    enable = true;
    profiles = {
      home = {
        outputs = [
          {
            criteria = "eDP-1";
            position = "1920,0";
          }
          {
            criteria = "BNQ BenQ EX2510 HBL05326019";
            position = "0,0";
            mode = "1920x1080@144Hz";
          }
        ];
      };
    };
  };

}
