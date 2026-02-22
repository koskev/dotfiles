_: {
  flake.modules.homeManager.shell = _: {
    programs = {
      fish = {
        enable = true;
      };
    };
  };
}
