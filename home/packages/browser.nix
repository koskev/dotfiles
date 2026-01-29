{
  pkgs,
  inputs,
  lib,
  settings,
  config,
  ...
}:
let
  zen_version = "twilight";
  zen_package = inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".${zen_version};
in
{
  imports = [
    inputs.zen-browser.homeModules.${zen_version}
  ];

  xdg = {
    mimeApps = {
      enable = true;
      defaultApplications =
        let
          browser = "zen-${zen_version}.desktop";
        in
        {
          "default-web-browser" = [ browser ];
          "text/html" = [ browser ];
          "x-scheme-handler/http" = [ browser ];
          "x-scheme-handler/https" = [ browser ];
          "x-scheme-handler/about" = [ browser ];
          "x-scheme-handler/unknown" = [ browser ];
        };
    };
  };
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "video-downloadhelper"
    ];

  programs.zen-browser = {
    enable = true;

    nativeMessagingHosts = [ pkgs.keepassxc ];
    languagePacks = [
      "de"
      "en-US"
    ];
    profiles.default = {
      extensions = {
        packages = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
          dearrow
          clearurls
          sponsorblock
          augmented-steam
          decentraleyes
          istilldontcareaboutcookies
          keepassxc-browser
          mal-sync
          violentmonkey
          videospeed
          temporary-containers
          return-youtube-dislikes
          privacy-redirect
          offline-qr-code-generator
          video-downloadhelper
        ];
      };

      settings = {
        # Remove border
        "zen.theme.content-element-separation" = 0;
        # Fix broken search bar theme (ctrl+f): https://togithub.com/zen-browser/desktop/issues/9600
        "ui.systemUsesDarkTheme" = 1;
        # Remove window controls as they are useless on sway
        "zen.view.experimental-no-window-controls" = true;
      };
      search = {
        default = "searx";
        # Needed since zen/firefox writes the file :/
        force = true;
        engines = {
          nix-packages = {
            name = "Nix Packages";
            urls = [
              {
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "type";
                    value = "packages";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];

            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@np" ];
          };

          nixos-wiki = {
            name = "NixOS Wiki";
            urls = [ { template = "https://wiki.nixos.org/w/index.php?search={searchTerms}"; } ];
            iconMapObj."16" = "https://wiki.nixos.org/favicon.ico";
            definedAliases = [ "@nw" ];
          };
          home-manager = {
            name = "Home Manager";
            urls = [ { template = "https://home-manager-options.extranix.com/?query={searchTerms}"; } ];
            definedAliases = [ "@hm" ];
          };

          searx = {
            name = "searx";
            urls = [
              {
                template =
                  let
                    preferences = builtins.readFile ./searx_preferences;
                  in
                  "https://searx.tiekoetter.com/?preferences=${preferences}&q={searchTerms}";
              }
            ];

          };

        };

      };
    };
  }
  // lib.optionalAttrs (!settings.system.nixos) {
    package = lib.mkForce (config.lib.nixGL.wrap zen_package);
  };
}
