{
  config,
  pkgs,
  lib,
  inputs,
  settings,
  ...
}:
let
  userhost = "${settings.username}@${settings.hostname}";
  configPath = ../../configs/users/${userhost}/rufaco.yaml;
in
lib.mkIf (lib.pathExists configPath) {
  home.packages = [
    inputs.rufaco.defaultPackage.${pkgs.stdenv.hostPlatform.system}
  ];
  home.file = {
    "${config.xdg.configHome}/rufaco/config.yaml".text = builtins.readFile configPath;
  };
}
