{
  pkgs,
  config,
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
}
