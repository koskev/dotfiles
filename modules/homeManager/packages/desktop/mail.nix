_: {
  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    let
      patched-etesync-dav = pkgs.etesync-dav.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [
          # Patch to fix writing to radicale. Can be removed once https://togithub.com/etesync/etesync-dav/pull/357 is merged
          (pkgs.fetchpatch {
            name = "Fix-usage-with-radicale-3.5.1.patch";
            url = "https://github.com/etesync/etesync-dav/pull/357.patch";
            hash = "sha256-hKPakl+v95jb11LfvrQp6+u/ojtD/sLaR2gY/OZeQ+s=";
          })
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
    };
}
