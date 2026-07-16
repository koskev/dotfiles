_: {
  flake.modules.nixos.kevin-nix =
    { pkgs, ... }:
    let
      vrAudio = pkgs.writeShellScriptBin "vr-audio" ''
        ${pkgs.pulseaudio}/bin/pactl set-default-sink alsa_output.usb-Oculus_Rift_Audio_WMHD3156300GT-00.analog-stereo
        "$@"
        ${pkgs.pulseaudio}/bin/pactl set-default-sink alsa_output.usb-BEHRINGER_UMC202HD_192k-00.HiFi__Line__sink
      '';

    in
    {
      environment.systemPackages = [
        vrAudio
      ];
    };
}
