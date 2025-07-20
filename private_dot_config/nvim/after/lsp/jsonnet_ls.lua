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

local function getExtcodeFile()
	local foundFile = vim.fs.find("extcode.libsonnet",
		{ path = vim.loop.cwd(), upward = true, type = "file" })[1]
	if foundFile == nil then
		return nil
	end
	local filename = vim.fs.basename(foundFile)
	local retVal = {}
	retVal[vim.fn.fnamemodify(filename, ":r")] = foundFile
	return retVal
end

return {
	--cmd = { "/tmp/venv/bin/lsp-devtools", "agent", "--", "jsonnet-language-server" },
	cmd = vim.lsp.rpc.connect("127.0.0.1", 4874),
	--cmd = { "/tmp/venv/bin/lsp-devtools", "agent", "--", "/home/kevin/Dokumente/Projekte/Github/koskev/koskev-rs-lsps/jsonnet-ls-rs/target/debug/grustonnet-bin" },
	settings = {
		--ext_vars = getJson("extvars.json"),
		--ext_code = getJson("extcode.json"),
		enable_semantic_tokens = true,
		inlay_config = {
			enable_debug_ast = false,
			enable_index_value = true,
			enable_function_args = true,
		},
		workarounds = {
			assume_true_condition_on_error = true,
		},
		completion = {
			enable_snippets = true,
			use_type_in_detail = true,
			show_docstring = false,
		},
		diagnostics = {
			enable_lint_diagnostics = true,
			enable_eval_diagnostics = true,
		},
		paths = {
			ext_code = {
				find_upwards = true,
			},
			relative_jpaths = {
				"vendor",
				"lib",
				".",
			},
		}
	}
}
