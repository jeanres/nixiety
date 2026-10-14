-- Server configs come from nvim-lspconfig; servers come from Nix or the
-- project's direnv environment.

vim.lsp.config("*", {
  capabilities = require("blink.cmp").get_lsp_capabilities(),
})

vim.lsp.config("lua_ls", {
  settings = {
    Lua = { diagnostics = { globals = { "vim" } } },
  },
})

-- Point nixd at this repo's flake so it completes nix-darwin and
-- Home Manager options, not just packages
local flake = '(builtins.getFlake "' .. vim.fn.expand("~/.nixiety") .. '")'
local darwin = flake .. '.darwinConfigurations."Jeanres-MacBook-Pro"'
vim.lsp.config("nixd", {
  settings = {
    nixd = {
      nixpkgs = { expr = "import " .. flake .. ".inputs.nixpkgs { }" },
      formatting = { command = { "nixfmt" } },
      options = {
        ["nix-darwin"] = { expr = darwin .. ".options" },
        ["home-manager"] = {
          expr = darwin .. ".options.home-manager.users.type.getSubOptions [ ]",
        },
      },
    },
  },
})

vim.lsp.enable({
  "vtsls", -- JavaScript / TypeScript
  "eslint", -- uses the project's eslint
  "jsonls",
  "cssls",
  "html",
  "nixd",
  "lua_ls",
})

vim.diagnostic.config({
  virtual_text = true,
  severity_sort = true,
  float = { border = "rounded" },
})

-- Keys when a server attaches. Neovim already provides:
--   K hover, grn rename, gra code action, grr references, gri implementation
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local builtin = require("telescope.builtin")
    local function map(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { buffer = args.buf, desc = desc })
    end
    map("gd", builtin.lsp_definitions, "Go to definition")
    map("gD", vim.lsp.buf.declaration, "Go to declaration")
    map("gy", builtin.lsp_type_definitions, "Go to type definition")
    map("<leader>ca", vim.lsp.buf.code_action, "Code action")
    map("<leader>cr", vim.lsp.buf.rename, "Rename")
    map("<leader>fR", builtin.lsp_references, "References")
    map("<leader>ce", "<cmd>LspEslintFixAll<cr>", "ESLint fix all")
  end,
})
