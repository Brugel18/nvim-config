-- Pin Mason-installed tools (LSPs, formatters, linters) to exact versions.
-- Lockfile: ~/.config/nvim/mason-lock.json (commit it alongside lazy-lock.json)
-- :MasonLock         -> write current tool versions to the lockfile
-- :MasonLockRestore  -> reinstall the exact versions from the lockfile
return {
  "zapling/mason-lock.nvim",
  dependencies = { "mason-org/mason.nvim" },
  init = function()
    require("mason-lock").setup({
      lockfile_path = vim.fn.stdpath("config") .. "/mason-lock.json",
    })
  end,
}
