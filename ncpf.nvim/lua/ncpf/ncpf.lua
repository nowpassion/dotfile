-- Neovim C Project File
local ncpf_lib = require('ncpf.ncpf_lib')

ncpf = {

}

ncpf.init = function(ncpf_top_dir)
	ncpf_lib.ncpf_setup(ncpf_top_dir)
end

return ncpf
