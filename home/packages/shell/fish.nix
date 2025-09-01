{ aliases, shellIntegrations }:
_:
let

  programIntegrations = builtins.listToAttrs (
    map (name: {
      inherit name;
      value = {
        enableFishIntegration = true;
      };
    }) shellIntegrations
  );

in
{
  programs = programIntegrations // {
    fish = {
      enable = true;
      shellAliases = aliases;
    };
  };
}
