{ aliases, shellIntegrations }:
{
  lib,
  ...
}:
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
# XXX: We can't just do programs = pprogramIntegrations // [..] since this will break the LSPs :/
lib.recursiveUpdate
  {
    programs = {
      fish = {
        enable = true;
        shellAliases = aliases;
      };
    };
  }
  {
    programs = programIntegrations;
  }
