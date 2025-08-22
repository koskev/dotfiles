{
  config,
  pkgs,
  lib,
  settings,
  ...
}:
let
  userhost = "${settings.username}@${settings.hostname}";
  configPath = ../../configs/users/${userhost}/rufaco.yaml;
in
lib.mkIf (lib.pathExists configPath) {
  home.packages = [
    (builtins.getFlake "github:koskev/rufaco").defaultPackage.${pkgs.system}
  ];
  home.file = {
    "${config.xdg.configHome}/rufaco/config.yaml".text = builtins.readFile configPath;
  };
}
