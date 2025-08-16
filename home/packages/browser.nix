{
  pkgs,
  ...
}:
{

  programs.zen-browser = {
    enable = true;
    profiles.default = {
      settings = {
        # Remove border
        "zen.theme.content-element-separation" = 0;
      };
      search = {
        default = "searx";
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

          searx = {
            name = "searx";
            urls =
              let
                preferences = "eJx1WMmS47gR_RrrwpiKGbfDDh90coz9A3NngECSRBNEsrBIYn29H7gCYvWh1M0HMJHIfLlRikAdO03-3pElJ8zNCNtF0dFdxMA3w1IYupO9pUfJ42Qo0L1j7gzdWvHQkm3tyLN5kNtxPUJAPTl-zfe_XKTbSKFndf_fn3_dvGjJk3Cyv_9-Cz2NdPc6ib1BSjTB1xBo6VkH0dz_K4ynm2J9HsECjx_sutv6Wu3DDA2VcMNNkg3kamF0Z0f8fz1cqIewklS9HbsK_Yzk5lrbOuiA95ed2rba6gCZ0rExK7i-lbSSq7VmCDIkN-k9h4Fmf1fUCqh_i87ULbtRhKBtd58chTDflPaiMdCBbKctzP3jn79vguvN8n_7-38OsHpoRezrev0XS__uRFfXnqUWphpJaQFQyDbabBNM01Dl4aihrhcnvKGr3O_fqERUGmtj9FqmJUMvYZXTIldRmAn6V0bb-KomIYd0CA4Lac1a4aukv35QXbfarOdbDxFw6fIwDdWonWOXbxBgkRKbGKtf7KunHvQu1wUt8wv5IVepgZZSjNOpeiO0iuUWANUqIBO0woPQ7X52o41Of5mJGrixkIXnq38aHWQfQZ0CaqIcKOyyp6aQE5TuutMKPJEFwT1lCi6O_pBSfqhcsuypHThxhxFBLiGGo2qNcCR0foicQMCWHCEANjVAbe8Bgk1SJ3zFnuqhEXXZuzNNb49XCyYwefbwryL6QggerlDkgwjan6oqemhhA5yayVGqqxBBKfo0W5-fq8BNclUfm-0C0HnGfa_hQ7iFVudJiUJKhIK_Ch5Jfx1fL5OtXfybrZX3PfEniXTweb6YkJ-qUUzYjt-k4cg_9ZSceu5CmqCZinuEeWSLEKNz1x-vTNFWOU4X3akDu6nQizAim-bbjJaDywFHCHZuwxNEqZR2yGIpn612bZ22gxZ5pLXznNmzI_3VI3nmiNXRn97ukEvF7ic8nE6TrKgh151rBGLzuD8zK3BX5bKXWnL1xIZ72TP4nrN4W5mMmKuRQef8NSRkcil5poqVe70XjRPpZ1OlF4lvq5NXgF5H6ECI_0hZcl1ZDtwetKkm9uFgRh87pPquFUfkZUiVeOkp-G-WPNLqkVP1qJrTJnrsYu5QbUV2RTDLIYDmfMOnnvNk9lP7nk95AwgivD-ZZGgc5wp-GWMKxaTGW81Zd0SPTPWLtWSFX60lySjM3yxreMHNVYoCrzONvn7bljIlt73cQp7t0Brk_kyrFByqjhGhiCvDjQ_04Xbbjsru_6Mg5CSOR52SJOKkMkgyJ_pa0uxJ95G_-iLdjs-xMTlgE9vwl7nATjvp7SzEeatRIPpoZ-EYjXkIhW6rSF8ZXMEIj-J-rGZPeZ1ADyPGvbSl-iIQ8ifzzsjZ16bYIGeILQeX64cbdvIkEIYjLiFI4cx_a4-g_V4FJ9VQLnpCA4XeakuQaC4QpuTz2jCljJndann-WHxwumLSKTYbkdFk0i8B4Jrn94VLapkYjYRHQlYp5PdLoYJea80BfiP-WNoP-O61oorA7qjwj91EixcqxaPQdpV_dlXnMbEZk10yU87T3jJ9RvTD-cELcNX184lSXOxLQKncCn3_6tWGTqCLBDf56fM-ALxTOlzC3hF6Jnee5XTXByRHznVyHAKSBswRmLIKsVpynL0u49zTpMXuskMxzx0XTeECXO-1wpd7rfCTJOrsWf21l9H7j2nGfLPnCSmUmj_2HLpX10n_hoJFF3zVM5XHKv0cKNIBut7vypxPvdOUJqz8MjtY-u6Er_dEBR6zNoSHGZGI8jCkPLgHUUi7oYQoTJej20mhKFTRepRh3-etokC5LBpKjiE2eb46kKN7FNqgF0r5KNv20GMxxDx1M-eCU9_XMA_-HSxMk4DPyCV1Eug5OnlFJ5JLPfwFfPoHcFK4yJVpa2ruF7-XEh48v_kyoYkmSMIfF7flixeS5otv41y-tDj39PGTTetQKMzUl72yluGLbaHbOKPJRM9YHRVW5ct__Pjxr9cpWUVFNg_YL5s4l4njn0Tf5KUNLxy2tHSTNhxOiRYl0BUFNwFXeStciFuha_6KzdzRuPcIE5F7Y-mSu3D-kAamJzU5gYUs_Juer8q4iC4hl2jAjaXry13JTlk9ZBTilx7Yok5UfrZs55Fyy9Lwdr8Vuob9Al_TG_wpi0rgH10q5dmrgTmkUSNZ_C2PPzCPLN8ENrM9hTE9DGzfmDtiwiuoHoL70BlFlqbmyvoVvk7dC1xcG23K2eGtoYy5_BwzyhH8H9kAPg3dR8dZHfZkvXRogz9jZmpcgTAIoDlcP1Es-A39U_F9Z5398Js-rrj8a0g_LtOfTT1Wek7NwPo5pfjk8dKPt6SyD45vnyKutkpoYRMZXfoCUFDzHFxztEt1lk9rLeNNtrxOWJcjN7w4NJ_GYIcs32gLB2qOuSczbM9YMEr3KLtfNGes2P5i_DiWe1QelKjrjtSfgulEAe3m3nOCJFa9dfaom3JgJIjW8HP3iR9iE22IOz0i5q3oj5bdTyhU7ZwJYaMVvO_Wiecoqbw0JgcDlsL4nupS-itcXTT75_fEyUQQzt9Z1Otn0icISwcd92UpjIzI1pwYnMyzrSwsN22tbctL2UaPhokFFw9bV-Bq2ZMc0muY65C-1zu4ZUqu09dOh4KAF27oIGDd-_8Bqdpq3w==";
              in
              [ { template = "https://searx.tiekoetter.com/?preferences=${preferences}&q={searchTerms}"; } ];

          };

        };

      };
    };
  };

}
