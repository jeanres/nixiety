{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    # Plugins come from nixpkgs (pinned by flake.lock), no plugin manager
    plugins = with pkgs.vimPlugins; [
      # UI
      catppuccin-nvim
      lualine-nvim
      nvim-web-devicons

      # Finding and files
      telescope-nvim
      telescope-fzf-native-nvim
      plenary-nvim
      oil-nvim

      # Syntax
      nvim-treesitter.withAllGrammars
      nvim-ts-autotag

      # LSP, completion, formatting
      nvim-lspconfig
      blink-cmp
      friendly-snippets
      conform-nvim

      # Git
      gitsigns-nvim
      snacks-nvim # lazygit float

      # Editing
      mini-nvim

      # Load the project's direnv environment inside nvim
      direnv-vim
    ];

    # Fallback tools. Neovim's wrapper appends these to PATH, so anything a
    # project provides through direnv (node, eslint, prettier, ...) wins.
    extraPackages = with pkgs; [
      # JavaScript / TypeScript
      vtsls
      vscode-langservers-extracted # eslint, json, css, html
      prettierd

      # Nix
      nixd
      nixfmt

      # Lua (for this config)
      lua-language-server
      stylua

      # Used by plugins
      direnv
      ripgrep
      fd
      lazygit
    ];

    initLua = ''
      require("config")
    '';
  };

  xdg.configFile."nvim/lua".source = ./lua;
}
