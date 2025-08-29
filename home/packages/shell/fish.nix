{ aliases }:
_: {
  programs.fish = {
    enable = true;
    shellAliases = aliases;
  };
}
