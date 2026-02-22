{ inputs, ... }:
{
  flake.modules.homeManager.rufaco =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      userhost = "${config.userSettings.userName}@${config.hostSettings.hostName}";
      configPath = ../../../configs/users/${userhost}/rufaco.yaml;
    in
    lib.mkIf (lib.pathExists configPath) {
      home.packages = [
        inputs.rufaco.defaultPackage.${pkgs.stdenv.hostPlatform.system}
      ];
      home.file = {
        "${config.xdg.configHome}/rufaco/config.yaml".text = builtins.readFile configPath;
      };
    };
}
