{ inputs, ... }: {
  flake.modules.nixos.vr = { pkgs, ... }: {
    environment.pathsToLink = [ "/share/openhmd" ];

    environment.systemPackages = with pkgs; [
      wayvr
      bs-manager

      (pkgs.writeShellScriptBin "bs-manager-steam" ''
        /run/wrappers/bin/firejail --join="steam" ${lib.getExe pkgs.bs-manager} "$@"
      '')
      inputs.openhmd.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
    services.udev.extraRules = ''
      # OpenHMD udev rules
      # Oculus Rift CV1
        SUBSYSTEM=="usb", ATTR{idVendor}=="2833", MODE="0666", GROUP="plugdev"
    '';
  };
}
