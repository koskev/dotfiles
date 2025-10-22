{ pkgs, ... }:
let
  patched-etesync-dav = pkgs.etesync-dav.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [
      # Patch to fix writing to radicale. Can be removed once https://togithub.com/etesync/etesync-dav/pull/357 is merged
      ./patches/0001-Fix-usage-with-radicale-3.5.1.patch
    ];
  });
in
{
  home.packages = with pkgs; [
    thunderbird
  ];
  services.etesync-dav = {
    enable = true;
    package = patched-etesync-dav;
    serverUrl = "https://etesync.kokev.de";
  };
}
