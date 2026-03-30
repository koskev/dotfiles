_: {
  flake.modules.homeManager.deck-emulation =
    {
      pkgs,
      lib,
      ...
    }:
    {
      nixpkgs.config.allowUnfreePredicate =
        pkg:
        builtins.elem (lib.getName pkg) [
          "shipwright"
          "2ship2harkinian"
        ];

      home.packages = with pkgs; [
        shipwright
        _2ship2harkinian
      ];
      programs.retroarch = {
        enable = true;
        cores = {
          mgba.enable = true; # Uses pkgs.libretro.mgba
          mupen64plus.enable = true;
          mame.enable = true;
          dolphin.enable = true;
          bsnes-hd.enable = true;
          # neogeo
          beetle-ngp.enable = true;

        };
        settings = {
          menu_driver = "xmb";
          video_aspect_ratio_auto = "true";
          video_fullscreen = "true";
          video_driver = "vulkan";
          # Steam Deck controller mappings
          input_player1_a_btn = "1";
          input_player1_analog_dpad_mode = "0";
          input_player1_b_btn = "0";
          input_player1_device_reservation_type = "0";
          input_player1_down_btn = "h0down";
          input_player1_joypad_index = "0";
          input_player1_l2_axis = "+2";
          input_player1_l3_btn = "9";
          input_player1_l_btn = "4";
          input_player1_l_x_minus_axis = "-0";
          input_player1_l_x_plus_axis = "+0";
          input_player1_l_y_minus_axis = "-1";
          input_player1_l_y_plus_axis = "+1";
          input_player1_left_btn = "h0left";
          input_player1_mouse_index = "0";
          input_player1_r2_axis = "+5";
          input_player1_r3_btn = "10";
          input_player1_r_btn = "5";
          input_player1_r_x_minus_axis = "-3";
          input_player1_r_x_plus_axis = "+3";
          input_player1_r_y_minus_axis = "-4";
          input_player1_r_y_plus_axis = "+4";
          input_player1_reserved_device = "";
          input_player1_right_btn = "h0right";
          input_player1_select_btn = "6";
          input_player1_start_btn = "7";
          input_player1_up_btn = "h0up";
          input_player1_x_btn = "3";
          input_player1_y_btn = "2";
        };
      };
    };
}
