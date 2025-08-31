local function getJson(filename)
	local foundFile = vim.fs.find(filename, { path = vim.loop.cwd(), upward = true, type = "file" })[1]
	if foundFile == nil then
		return nil
	end
	local f = io.open(foundFile, "r")
	if f == nil then
		return nil
	end
	local data = f:read("*all")
	return vim.json.decode(data)
end

local grustonnet_settings = getJson("./grustonnet.json");
return {
	--cmd = vim.lsp.rpc.connect("127.0.0.1", 4874),
	cmd = { "grustonnet-ls" },
	filetypes = { 'jsonnet', 'libsonnet' },
	root_markers = { 'jsonnetfile.json', '.git' },
	settings = grustonnet_settings,
}
