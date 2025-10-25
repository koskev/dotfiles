{
  pkgs,
  config,
  ...
}:
let
  patched-cantata = pkgs.cantata.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [
      (pkgs.fetchpatch {
        name = "fix-build-with-qt-610-qfile-open.patch";
        url = "https://github.com/nullobsi/cantata/pull/89.patch";
        hash = "sha256-mxW1OmEVKaPINYns9yQSnS2lWVtVRUPKErYhEWdA7jo=";
      })
      (pkgs.fetchpatch {
        name = "fix-build-with-qt-610-invalidateFilter-deprecated.patch";
        url = "https://github.com/nullobsi/cantata/pull/90.patch";
        hash = "sha256-XQCh61Al76daRhw3xja+XhraRenIEWIn3eWGN40ESgw=";
      })

    ];
  });

in
{

  home.packages = with pkgs; [

    # Music
    mpc
    patched-cantata
    playerctl
  ];
  # RS version not in repo :/
  services.mpd-mpris.enable = true;

  xdg.configFile.cantata = {
    source = ../../configs/cantata;
  };
  services = {
    mpd = {
      enable = true;
      playlistDirectory = "${config.home.homeDirectory}/.config/mpd/playlists";
      dataDir = "${config.home.homeDirectory}/.config/mpd";
    };
  };
}
