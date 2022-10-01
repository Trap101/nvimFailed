require("user.options")
local lsp_formatting = function(bufnr)
    vim.lsp.buf.format({
        filter = function(client)
            -- apply whatever logic you want (in this example, we'll only use null-ls)
            return client.name == "null-ls"
        end,
        bufnr = bufnr,
    })
end

-- if you want to set up formatting on save, you can use this as a callback
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

-- add to your shared on_attach callback
local on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
        vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
                lsp_formatting(bufnr)
            end,
        })
    end
	end
local wilder = require("wilder")
vim.g.coq_settings = {
	auto_start = "shut-up",
}

local coq = require("coq")
require("bufferline").setup({

	options = {
		diagnostics = "nvim_lsp",
		diagnostics_indicator = function(count, level, diagnostics_dict, context)
			local s = " "
			for e, n in pairs(diagnostics_dict) do
				local sym = e == "error" and " " or (e == "warning" and " " or "")
				s = s .. n .. sym
			end
			return s
		end,
	},
})
wilder.setup({ modes = { ":", "/", "?" } })
local null_ls = require("null-ls")
require("null-ls").setup({
	sources = {
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.formatting.yapf,
		null_ls.builtins.diagnostics.flake8,
		null_ls.builtins.formatting.rustfmt,
	},
})
wilder.set_option("pipeline", {
	wilder.branch(
		wilder.python_file_finder_pipeline({
			file_command = function(ctx, arg)
				if string.find(arg, ".") ~= nil then
					return { "fdfind", "-tf", "-H" }
				else
					return { "fdfind", "-tf" }
				end
			end,
			dir_command = { "fd", "-td" },
			filters = { "fuzzy_filter" },
		}),
		wilder.substitute_pipeline({
			pipeline = wilder.python_search_pipeline({
				skip_cmdtype_check = 1,
				pattern = wilder.python_fuzzy_pattern({
					start_at_boundary = 0,
				}),
			}),
		}),
		wilder.cmdline_pipeline({
			fuzzy = 2,
			fuzzy_filter = wilder.lua_fzy_filter(),
		}),
		{
			wilder.check(function(ctx, x)
				return x == ""
			end),
			wilder.history(),
		},
		wilder.python_search_pipeline({
		       	pattern = wilder.python_fuzzy_pattern({
				start_at_boundary = 0,
			}),
		})
	),
})
wilder.set_option(
	"renderer",
	wilder.popupmenu_renderer(wilder.popupmenu_palette_theme({
		highlighter = {
			wilder.lua_fzy_highlighter(),
			wilder.basic_highlighter(),
		},
		left = { " ", wilder.popupmenu_devicons() },
		right = { " ", wilder.popupmenu_scrollbar() },
		highlights = {
			accent = wilder.make_hl("WilderAccent", "Pmenu", { { a = 1 }, { a = 1 }, { foreground = "#f4468f" } }),
		},
		-- 'single', 'double', 'rounded' or 'solid'
		-- can also be a list of 8 characters, see :h wilder#popupmenu_palette_theme() for more details
		border = "rounded",
		max_height = "75%", -- max height of the palette
		min_height = 0, -- set to the same as 'max_height' for a fixed height window
		prompt_position = "top", -- 'top' or 'bottom' to set the location of the prompt
		reverse = 0, -- set to 1 to reverse the order of the list, use in combination with 'prompt_position'
	}))
)
local on_attach = function(client, bufnr)
	
	local opts = { silent = true, noremap = true }
	local keymap = vim.api.nvim_buf_set_keymap
	keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
	keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
	keymap(bufnr, "n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
	keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
	keymap(bufnr, "n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
	keymap(bufnr, "n", "<leader>lf", "<cmd>lua vim.lsp.buf.formatting()<cr>", opts)
	keymap(bufnr, "n", "<leader>li", "<cmd>LspInfo<cr>", opts)
	keymap(bufnr, "n", "<leader>lf", "<cmd>LspInstallInfo<cr>", opts)
	keymap(bufnr, "n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
	keymap(bufnr, "n", "<leader>lj", "<cmd>lua vim.diagnostic.goto_next({buffer=0})<cr>", opts)
	keymap(bufnr, "n", "<leader>lk", "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<cr>", opts)
	keymap(bufnr, "n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
	keymap(bufnr, "n", "<leader>ls", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
	keymap(bufnr, "n", "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
end
require("mason").setup()
require("mason-lspconfig").setup()
local lsp = require("lspconfig")
lsp.sumneko_lua.setup({
	on_attach = on_attach,
})
lsp.jedi_language_server.setup(coq.lsp_ensure_capabilities({
	on_attach = on_attach,
}))
lsp.sumneko_lua.setup(coq.lsp_ensure_capabilities())
lsp.rust_analyzer.setup(coq.lsp_ensure_capabilities({
	on_attach = on_attach,
}))

require("coq_3p")({
	{ src = "nvimlua", short_name = "nLUA", conf_only = false },
})
require("telescope").load_extension("fzy_native")
require("nvim-treesitter.configs").setup({
	-- A list of parser names, or "all"
	ensure_installed = { "c", "lua", "rust", "python" },

	-- Install parsers synchronously (only applied to `ensure_installed`)
	sync_install = false,

	-- Automatically install missing parsers when entering buffer
	auto_install = true,

	-- List of parsers to ignore installing (for "all")

	---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
	-- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

	highlight = {
		-- `false` will disable the whole extension
		enable = true,

		-- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
		-- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
		-- the name of the parser)
		-- list of language that will be disabled
		disable = {},

		-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
		-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
		-- Using this option may slow down your editor, and you may see some duplicate highlights.
		-- Instead of true it can also be a list of languages
		additional_vim_regex_highlighting = true,
	},
})
