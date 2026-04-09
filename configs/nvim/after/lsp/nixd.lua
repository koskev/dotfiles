local function nixd_options_expr(flake_attr)
	return string.format([[
	let
		flake = builtins.getFlake (toString ./.);
		configs = flake.%s or {invalid="";};
		firstName = builtins.head (builtins.attrNames configs);
	in
		configs.${firstName}.options or {}
  ]], flake_attr)
end
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
					expr = nixd_options_expr("homeConfigurations"),
				},
				nixos = {
					expr = nixd_options_expr("nixosConfigurations"),
				},
			},
		},
	},
}
