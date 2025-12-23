{ pkgs, ... }:
let
  heads-sign-boot = pkgs.writeShellScriptBin "heads-sign-boot" ''
     export PATH="${pkgs.busybox}/bin:$PATH"
    ${builtins.readFile ./generate_menu.sh}
  '';

in
{
  environment.systemPackages = [
    heads-sign-boot
  ];
}
