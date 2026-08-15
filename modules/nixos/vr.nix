_: {
  flake.modules.nixos.vr = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      wayvr
      bs-manager

      (pkgs.writeShellScriptBin "bs-manager-steam" ''
        /run/wrappers/bin/firejail --join="steam" ${lib.getExe pkgs.bs-manager} "$@"
      '')
    ];
    services.udev.extraRules = ''
      # OpenHMD udev rules
      # Oculus Rift CV1
        SUBSYSTEM=="usb", ATTR{idVendor}=="2833", MODE="0666", GROUP="plugdev"
    '';
  };
}
