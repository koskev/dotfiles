{ inputs, ... }:
{
  flake.modules.homeManager.desktop =
    {
      pkgs,
      ...
    }:
    {
      home.packages = [
        inputs.pushtotalk.defaultPackage.${pkgs.stdenv.hostPlatform.system}
      ];
    };
}
