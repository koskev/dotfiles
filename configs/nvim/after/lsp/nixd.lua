local flakePath = "~/nix"
return {
	cmd = { "nixd", "--semantic-tokens=true" },
	settings = {
		nixd = {
			nixpkgs = {
				expr = "import <nixpkgs> { }",
			},
			formatting = {
				command = { "nixfmt" },
			},
			options = {
				home_manager = {
					expr = '(builtins.getFlake (builtins.toString ' ..
					flakePath .. ')).homeConfigurations."kevin@kevin-nix".options',
				},
				nixos = {
					expr = '(builtins.getFlake (builtins.toString ' ..
					flakePath .. ')).nixosConfigurations."kevin".options',
				},
			},
		},
	},
}
