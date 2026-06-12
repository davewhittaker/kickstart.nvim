-- plugin/ruby.lua
-- Ruby / Rails support. Committed to the repo but DORMANT by default:
-- everything below only runs when Neovim is launched inside a project that has
-- a Gemfile (searched upward from the cwd). On non-Ruby projects/machines this
-- file installs nothing and changes nothing.

local gemfile = vim.fs.find('Gemfile', {
  upward = true,
  path = vim.fn.getcwd(),
  stop = vim.uv.os_homedir(),
})[1]
if not gemfile then return end

-- init.lua's `gh` helper is local to that file, so define our own.
local function gh(name) return 'https://github.com/' .. name end

-- Plugins (installed on first launch inside a Ruby project; cheap thereafter).
vim.pack.add {
  gh 'tpope/vim-rails',
  gh 'tpope/vim-bundler',
  gh 'tpope/vim-endwise',
  gh 'vim-test/vim-test',
}

-- Ensure Ruby + ERB parsers are ready (avoids first-open delay; auto otherwise).
pcall(function()
  require('nvim-treesitter').install { 'ruby', 'embedded_template' }
end)

-- ruby-lsp: uses nvim-lspconfig's bundled default config (cmd = { 'ruby-lsp' },
-- filetypes ruby/eruby, root markers Gemfile/.git). Install the gem separately
-- (`gem install ruby-lsp` with the project's Ruby active).
vim.lsp.enable 'ruby_lsp'

-- vim-test: run specs in a built-in terminal split (auto-detects RSpec + bundler).
vim.g['test#strategy'] = 'neovim'
vim.g['test#neovim#term_position'] = 'vert botright'

-- Buffer-local test keymaps for Ruby buffers only.
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'ruby', 'eruby' },
  callback = function(ev)
    local map = function(lhs, rhs, desc)
      vim.keymap.set('n', lhs, rhs, { buffer = ev.buf, desc = desc })
    end
    map('<leader>tn', '<cmd>TestNearest<cr>', '[T]est [N]earest')
    map('<leader>tf', '<cmd>TestFile<cr>',    '[T]est [F]ile')
    map('<leader>ts', '<cmd>TestSuite<cr>',   '[T]est [S]uite')
    map('<leader>tl', '<cmd>TestLast<cr>',    '[T]est [L]ast')
  end,
})

-- OPTIONAL (left off to match the barebones style): format Ruby on save.
-- vim.api.nvim_create_autocmd('BufWritePre', {
--   pattern = { '*.rb', '*.rake', '*.erb' },
--   callback = function(ev) require('conform').format { bufnr = ev.buf } end,
-- })
