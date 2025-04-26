-- Neovim C Project File
local ncpf_lib = require('ncpf.ncpf_lib')

ncpf = {

}

ncpf.init = function(ncpf_top_dir)
	local capabilities = require('cmp_nvim_lsp').default_capabilities()
	local ncpf_cmd

	ncpf_lib.ncpf_setup(ncpf_top_dir)
	ncpf_cmd = ncpf_lib.get_clangd_cmd()

	vim.lsp.enable('clangd')
	vim.lsp.config('clangd', {
		capabilities = capabilities,
		cmd = ncpf_cmd
	})
end

return ncpf
