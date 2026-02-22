{
  description = "My dotfile Nix";

  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    # TODO: switch nixkpgs to 25.11 once it is released
    #nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      # IMPORTANT: we're using "libgbm" and is only available in unstable so ensure
      # to have it up-to-date or simply don't specify the nixpkgs input
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    disko.url = "github:nix-community/disko";
    sops-nix.url = "github:Mic92/sops-nix";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rufaco = {
      url = "github:koskev/rufaco";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    swayautonames = {
      url = "github:koskev/swayautonames";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pushtotalk = {
      url = "github:koskev/PushToTalk";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    grustonnet = {
      url = "github:koskev/grustonnet-ls";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vrl-ls = {
      url = "github:koskev/vrl-ls";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    jsonnet-debugger = {
      url = "github:koskev/jsonnet-debugger";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # For steam deck
    jovian = {
      url = "github:jovian-experiments/jovian-nixos/development";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    difftastic = {
      url = "github:koskev/difftastic?ref=feature/jsonnet";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mergiraf = {
      url = "git+https://codeberg.org/kokev/mergiraf.git?ref=feature/jsonnet";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };
  outputs =
    {
      flake-parts,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        (inputs.import-tree ./modules)
      ];
    };
}
