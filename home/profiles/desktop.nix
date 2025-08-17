{
  inputs,
  ...
}:
{
  imports = [
    ../packages/browser.nix
    inputs.zen-browser.homeModules.twilight
  ];
}
