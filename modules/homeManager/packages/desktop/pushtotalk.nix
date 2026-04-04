{ inputs, ... }:
{
  flake.modules.homeManager.desktop =
    {
      pkgs,
      ...
    }:
    {
      home.packages = [
        inputs.pushtotalk.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
    };
}
