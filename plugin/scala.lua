-- plugin/scala.lua
-- Scala support. Committed to the repo but DORMANT by default: everything
-- below only runs when Neovim is launched inside a project that has a
-- build.sbt, build.sc, or project/build.properties (searched upward from the
-- cwd). On non-Scala projects/machines this file installs nothing and
-- changes nothing.

local marker = vim.fs.find({ 'build.sbt', 'build.sc', 'project/build.properties' }, {
  upward = true,
  path = vim.fn.getcwd(),
  stop = vim.uv.os_homedir(),
})[1]
if not marker then return end

-- init.lua's `gh` helper is local to that file, so define our own.
local function gh(name) return 'https://github.com/' .. name end

-- nvim-metals fully manages the Metals language server (install, build import,
-- decorations, worksheets, DAP) -- don't also enable lspconfig's plain `metals`
-- config alongside it. Requires coursier on PATH (`brew install coursier`);
-- nvim-metals uses it to fetch the `metals` server binary on first run.
vim.pack.add { gh 'scalameta/nvim-metals' }

-- Ensure the Scala parser is ready (avoids first-open delay; auto otherwise).
pcall(function()
  require('nvim-treesitter').install { 'scala' }
end)

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'scala', 'sbt' },
  group = vim.api.nvim_create_augroup('nvim-metals', { clear = true }),
  callback = function()
    local metals_config = require('metals').bare_config()
    metals_config.init_options.statusBarProvider = 'off'
    metals_config.capabilities = require('blink.cmp').get_lsp_capabilities()
    require('metals').initialize_or_attach(metals_config)
  end,
})
