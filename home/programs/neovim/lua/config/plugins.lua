local map = vim.keymap.set

-- Theme
require("catppuccin").setup({
  flavour = "mocha",
  integrations = {
    blink_cmp = true,
    gitsigns = true,
    mini = { enabled = true },
    snacks = { enabled = true },
    telescope = { enabled = true },
  },
})
vim.cmd.colorscheme("catppuccin")

require("lualine").setup({
  options = { theme = "catppuccin-nvim", globalstatus = true },
})

-- Telescope
local telescope = require("telescope")
local builtin = require("telescope.builtin")
telescope.setup({
  defaults = {
    file_ignore_patterns = { "node_modules/", "%.git/", "dist/", "build/" },
  },
  pickers = {
    find_files = { hidden = true },
  },
})
telescope.load_extension("fzf")

map("n", "<leader><space>", builtin.find_files, { desc = "Find files" })
map("n", "<leader>/", builtin.live_grep, { desc = "Search project" })
map("n", "<leader>ff", builtin.find_files, { desc = "Files" })
map("n", "<leader>fg", builtin.live_grep, { desc = "Grep" })
map("n", "<leader>fw", builtin.grep_string, { desc = "Word under cursor" })
map("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
map("n", "<leader>fr", builtin.oldfiles, { desc = "Recent files" })
map("n", "<leader>fh", builtin.help_tags, { desc = "Help" })
map("n", "<leader>fd", builtin.diagnostics, { desc = "Diagnostics" })
map("n", "<leader>fs", builtin.lsp_document_symbols, { desc = "Symbols" })

-- Files: edit a directory like a buffer
require("oil").setup({
  view_options = { show_hidden = true },
})
map("n", "-", "<cmd>Oil<cr>", { desc = "Open parent directory" })

-- Treesitter (grammars come from Nix; just turn on highlighting and indent)
vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    if pcall(vim.treesitter.start, args.buf) then
      vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})
require("nvim-ts-autotag").setup({})

-- Completion
require("blink.cmp").setup({
  keymap = { preset = "default" }, -- <C-y> accept, <C-n>/<C-p> select, <C-space> open
  completion = { documentation = { auto_show = true } },
  signature = { enabled = true },
})

-- Formatting: project-local prettier/biome win, prettierd as fallback
local js = { "biome", "prettierd", stop_after_first = true }
require("conform").setup({
  formatters_by_ft = {
    javascript = js,
    javascriptreact = js,
    typescript = js,
    typescriptreact = js,
    json = js,
    jsonc = js,
    css = { "prettierd" },
    scss = { "prettierd" },
    html = { "prettierd" },
    markdown = { "prettierd" },
    yaml = { "prettierd" },
    nix = { "nixfmt" },
    lua = { "stylua" },
  },
  formatters = {
    -- Only use biome in projects that are set up for it
    biome = { require_cwd = true },
  },
  format_on_save = { timeout_ms = 1000, lsp_format = "fallback" },
})
map({ "n", "v" }, "<leader>cf", function()
  require("conform").format({ lsp_format = "fallback" })
end, { desc = "Format" })

-- Git
require("gitsigns").setup({
  on_attach = function(buf)
    local gs = require("gitsigns")
    local function bmap(lhs, rhs, desc)
      map("n", lhs, rhs, { buffer = buf, desc = desc })
    end
    bmap("]h", function() gs.nav_hunk("next") end, "Next hunk")
    bmap("[h", function() gs.nav_hunk("prev") end, "Previous hunk")
    bmap("<leader>gp", gs.preview_hunk, "Preview hunk")
    bmap("<leader>gr", gs.reset_hunk, "Reset hunk")
    bmap("<leader>gb", gs.blame_line, "Blame line")
  end,
})

local snacks = require("snacks")
snacks.setup({ lazygit = { enabled = true } })
map("n", "<leader>gg", function() snacks.lazygit() end, { desc = "Lazygit" })

-- Diagnostics / references panel
require("trouble").setup({})
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Project diagnostics" })
map("n", "<leader>xb", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer diagnostics" })
map("n", "<leader>xs", "<cmd>Trouble symbols toggle<cr>", { desc = "Symbols" })
map("n", "<leader>xr", "<cmd>Trouble lsp toggle<cr>", { desc = "LSP references/definitions" })
map("n", "<leader>xq", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix list" })

-- Sessions: saved per directory on exit
local persistence = require("persistence")
persistence.setup({})
map("n", "<leader>ss", function() persistence.load() end, { desc = "Restore session for this dir" })
map("n", "<leader>sl", function() persistence.load({ last = true }) end, { desc = "Restore last session" })
map("n", "<leader>sd", function() persistence.stop() end, { desc = "Don't save this session" })

-- Editing helpers
require("mini.pairs").setup()
require("mini.surround").setup() -- sa / sd / sr: add, delete, replace surroundings
require("mini.ai").setup() -- better text objects (functions, args, ...)
