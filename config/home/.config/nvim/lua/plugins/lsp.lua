-- Ref: [Masonをやめようかな、ま、そんなところです](https://zenn.dev/vim_jp/articles/f24212092323d9)
return {
  {
    "neovim/nvim-lspconfig",
  },

  -- formatting
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        svelte = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        -- markdown = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        -- graphql = { "prettier" },
        go = { "goimports" },
        sh = { "shfmt" },
        lua = { "stylua" },
        -- python = { "isort", "black" },
        -- TODO: scss, ...
      },
    },
  },

  -- linting
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        -- svelte = { "eslint_d" },
        css = { "stylelint" },
        html = { "prettier" },
        markdown = { "markdownlint-cli2" },
        go = { "staticcheck" }, -- golangcilint
        -- python = { "flake8", pylint" }, -- ruff
        sh = { "shellcheck" },
        lua = { "selene" }, -- luacheck
        yaml = { "eslint_d" },
        json = { "eslint_d" },
        dockerfile = { "hadolint" },
        ghaction = { "actionlint" },
        -- terraform = { "tflint" },
        -- TODO: jsx? scss? tailwindcss?
        -- TODO: toml
        -- TODO: cpp
        -- TODO: sql
        -- ["*"] = { "typos" }, -- Run typos linter on all filetypes
        -- ["*"] = { "cspell" },
        -- ["_"] = { "fallback_linter" }, -- Use this linter for filetypes without specific linters
      },
    },
  },
}
