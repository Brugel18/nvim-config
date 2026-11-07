-- Make clangd find compile_commands.json in CMake multi-config build folders
-- (e.g. build/RelWithDebInfo/), which clangd doesn't search on its own.
-- Looks in the project root and every folder above it; first match wins.
-- A project's own .clangd file (CompileFlags: CompilationDatabase: ...) still overrides this.
local build_dirs = {
  "build/RelWithDebInfo",
  "build/Debug",
  "build/Release",
  "build/MinSizeRel",
}

local function find_compile_commands(root)
  if not root then
    return nil
  end
  for dir in vim.fs.parents(root .. "/_") do
    for _, sub in ipairs(build_dirs) do
      local candidate = dir .. "/" .. sub
      if vim.uv.fs_stat(candidate .. "/compile_commands.json") then
        return candidate
      end
    end
  end
end

return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      clangd = {
        cmd = function(dispatchers, config)
          local cmd = { "clangd" }
          local db = find_compile_commands(config.root_dir)
          if db then
            table.insert(cmd, "--compile-commands-dir=" .. db)
          end
          return vim.lsp.rpc.start(cmd, dispatchers, {
            cwd = config.cmd_cwd,
            env = config.cmd_env,
            detached = config.detached,
          })
        end,
      },
    },
  },
}
