_: {
  flake.modules.homeManager.lsp =
    {
      pkgs,
      ...
    }:
    {
      home.packages =
        let
          # Workaround for https://togithub.com/NixOS/nixpkgs/issues/509480
          gotoolsWithoutModernize = pkgs.symlinkJoin {
            name = "gotools-without-modernize";
            paths = [ pkgs.gotools ];
            postBuild = ''
              rm -f "$out/bin/modernize"
            '';
          };
        in
        with pkgs;
        [
          bash-language-server
          # clangd
          clang-tools
          gopls
          helm-ls
          marksman
          openscad-lsp
          rustup
          bacon
          tofu-ls
          tflint
          yaml-language-server
          pyright
          nodejs

          # nix
          nil
          nixd

          # Debugger
          delve

          # Formatter
          gofumpt
          prettier
          # goimports
          gotoolsWithoutModernize
          golangci-lint
          golangci-lint-langserver
          golines
          gomodifytags

        ];
    };
}
