return {

	"windwp/nvim-spectre",
	opts = {
		live_update = true,
		is_insert_mode = false,
		mappings = {
			["change_replace_sed"] = {
				map = "jrs",
				cmd = "<cmd>lua require('spectre').change_engine_replace('sed')<CR>",
				desc = "use sed to replace",
			},
			["change_replace_oxi"] = {
				map = "jro",
				cmd = "<cmd>lua require('spectre').change_engine_replace('oxi')<CR>",
				desc = "use oxi to replace",
			},
			["toggle_live_update"] = {
				map = "ju",
				cmd = "<cmd>lua require('spectre').toggle_live_update()<CR>",
				desc = "update when vim writes to file",
			},
			["toggle_ignore_case"] = {
				map = "ji",
				cmd = "<cmd>lua require('spectre').change_options('ignore-case')<CR>",
				desc = "toggle ignore case",
			},
			["toggle_ignore_hidden"] = {
				map = "jh",
				cmd = "<cmd>lua require('spectre').change_options('hidden')<CR>",
				desc = "toggle search hidden",
			},
		},
	},
}
