return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
			-- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
			{
				"s1n7ax/nvim-window-picker", -- for open_with_window_picker keymaps
				version = "2.*",
				config = function()
					require("window-picker").setup({
						filter_rules = {
							include_current_win = false,
							autoselect_one = true,
							-- filter using buffer options
							bo = {
								-- if the file type is one of following, the window will be ignored
								filetype = { "neo-tree", "neo-tree-popup", "notify" },
								-- if the buffer type is one of following, the window will be ignored
								buftype = { "terminal", "quickfix" },
							},
						},
					})
				end,
			},
		},
		opts = {
			close_if_last_window = true,
			popup_border_style = "rounded",
			enable_git_status = true,
			enable_diagnostics = true,

			-- Better icons and visuals
			default_component_configs = {
				container = {
					enable_character_fade = true,
				},
				indent = {
					indent_size = 2,
					padding = 1,
					with_markers = true,
					indent_marker = "│",
					last_indent_marker = "└",
					highlight = "NeoTreeIndentMarker",
				},
				icon = {
					folder_closed = "",
					folder_open = "",
					folder_empty = "",
					default = "",
					highlight = "NeoTreeFileIcon",
				},
				modified = {
					symbol = "[+]",
					highlight = "NeoTreeModified",
				},
				name = {
					trailing_slash = false,
					use_git_status_colors = true,
					highlight = "NeoTreeFileName",
				},
				git_status = {
					symbols = {
						-- Change type
						added = "✚",
						modified = "",
						deleted = "✖",
						renamed = "󰁕",
						-- Status type
						untracked = "",
						ignored = "",
						unstaged = "󰄱",
						staged = "",
						conflict = "",
					},
				},
				file_size = {
					enabled = true,
					required_width = 64,
				},
				type = {
					enabled = true,
					required_width = 122,
				},
				last_modified = {
					enabled = true,
					required_width = 88,
				},
			},

			filesystem = {
				filtered_items = {
					visible = true,
					hide_dotfiles = false,
					hide_gitignored = false,
					hide_hidden = false,
					never_show = { ".git" },
				},
				never_show = {},
				follow_current_file = {
					enabled = true,
					leave_dirs_open = false,
				},
				group_empty_dirs = false,
				use_libuv_file_watcher = true,
			},

			window = {
				position = "left",
				width = 20,
				font = {
					name = "Hack Nerd Font Mono",
					size = 8,
				},
				mapping_options = {
					noremap = true,
					nowait = true,
				},
				mappings = {
					["<space>"] = "none",
					["l"] = "open",
					["h"] = "close_node",
					["<cr>"] = "open",
					["S"] = "split_with_window_picker",
					["s"] = "vsplit_with_window_picker",
				},
			},
		},
	},
}
