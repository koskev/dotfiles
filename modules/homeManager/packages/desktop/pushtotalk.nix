_: {
  flake.modules.homeManager.desktop =
    {
      pkgs,
      inputs,
      ...
    }:
    {
      home.packages = [
        inputs.pushtotalk.defaultPackage.${pkgs.stdenv.hostPlatform.system}
      ];
    };
}
