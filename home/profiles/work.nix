{
  pkgs,
  config,
  nixgl,
  ...
}:

{

  imports = [
    ./desktop.nix
  ];

  home.packages = with pkgs; [
    (config.lib.nixGL.wrap teams-for-linux)
    gotestsum

    teleport_17
  ];
  programs = {
    fish = {
      interactiveShellInit = ''
        source ${./fish/tcs.fish}
      '';
    };
  };

  nixGL = {
    vulkan.enable = true;
    inherit (nixgl) packages;
  };
}
