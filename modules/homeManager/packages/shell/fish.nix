_: {
  flake.modules.homeManager.base = _: {
    programs = {
      fish = {
        enable = true;
      };
    };
  };
}
