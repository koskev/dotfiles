{ inputs, ... }:
{
  flake.modules.homeManager.nixgl = {

    targets.genericLinux.nixGL = {
      inherit (inputs.nixgl) packages;
      vulkan.enable = false;
      defaultWrapper = "mesa";
      installScripts = [
        "mesa"
      ];
    };
  };
}
