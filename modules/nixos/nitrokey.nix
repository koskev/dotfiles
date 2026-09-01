_: {
  flake.modules.nixos.desktop = { pkgs, ... }: {
    security.pam = {
      u2f = {
        # pamu2fcfg > ~/.config/Yubico/u2f_keys
        # TODO: define in nix
        cue = true;
        enable = true;
      };
      services = {
        login.u2fAuth = true;
        sudo.u2fAuth = true;
      };
    };
    services.udev.extraRules = ''
      ACTION=="remove",\
       ENV{ID_BUS}=="usb",\
       ENV{ID_MODEL_ID}=="42b2",\
       ENV{ID_VENDOR_ID}=="20a0",\
       RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"
    '';
  };
}
