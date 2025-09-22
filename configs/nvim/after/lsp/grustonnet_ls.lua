local function getJson(filename)
	-- https://neovim.io/doc/user/lua.html#lua-script-location
	local current_file = debug.getinfo(1, "S").source:sub(2)
	local current_dir = vim.fn.fnamemodify(current_file, ":h")

	local file_content = vim.fn.readfile(current_dir .. "/" .. filename)
	return vim.json.decode(table.concat(file_content, "\n"))
end

local grustonnet_settings = getJson("grustonnet.json");
return {
	-- cmd = vim.lsp.rpc.connect("127.0.0.1", 4874),
	cmd = { "grustonnet-ls" },
	filetypes = { 'jsonnet', 'libsonnet' },
	root_markers = { 'jsonnetfile.json', '.git' },
	settings = grustonnet_settings,
}
