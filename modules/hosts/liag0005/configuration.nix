_: {
  flake.modules.homeManager.liag0005 =
    {
      pkgs,
      config,
      ...
    }:
    {
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
    };
}
