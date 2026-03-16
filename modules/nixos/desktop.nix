_: {
  flake.modules.nixos.desktop =
    {
      pkgs,
      ...
    }:

    {
      programs = {
        gnupg.agent = {
          enable = true;
          enableSSHSupport = true;
        };
        sway.enable = true;
      };

      security.pam = {
        u2f.enable = true;
        services = {
          login.u2fAuth = true;
          sudo.u2fAuth = true;
        };
      };

      environment.systemPackages = with pkgs; [
        sway
        caja
        engrampa
        unrar-free

        syncthing
        wdisplays
        xrandr
        libnotify
        influxdb2-cli
        postgresql

        xterm
        unzip
        tmux
        htop

        crosspipe
        pavucontrol

        gnupg

        keepassxc

        element-desktop
        thunderbird
        meld
        joplin-desktop

        go
        cargo
        rustc
        clippy
        python3

        nitrokey-app2
        networkmanagerapplet
      ];

      xdg.portal.wlr.enable = true;
      security.polkit.enable = true;
      services = {
        gnome.gnome-keyring.enable = true;
        udisks2.enable = true;
        devmon.enable = true;
        gvfs.enable = true;
        udev.packages = [ pkgs.nitrokey-udev-rules ];
        pcscd.enable = true;
      };

    };
}
