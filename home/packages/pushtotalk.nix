{
  pkgs,
  inputs,
  ...
}:
{
  home.packages = [
    inputs.pushtotalk.defaultPackage.${pkgs.system}
  ];
}
