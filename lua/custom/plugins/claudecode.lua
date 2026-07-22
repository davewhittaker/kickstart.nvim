-- Claude Code editor integration.
-- https://github.com/coder/claudecode.nvim
--
-- nvim runs a WebSocket server that the `claude` CLI connects to, giving Claude
-- live awareness of the current file, your visual selection, and the ability to
-- propose edits as native nvim diffs. Claude still runs commands itself via its
-- own Bash tool, so a single session both edits code and runs/debugs it.
--
-- provider = 'none': the plugin does NOT open Claude inside nvim. Instead Claude
-- runs in a global tmux popup (prefix + a, see ~/.config/tmux/tmux.conf) and
-- connects back to this nvim over the WebSocket. That makes one Claude session
-- reachable from any tmux window while staying editor-aware here.

vim.pack.add { 'https://github.com/coder/claudecode.nvim' }

require('claudecode').setup {
  terminal = {
    provider = 'none', -- Claude is launched/managed externally (tmux popup)
  },
  diff_opts = {
    open_in_new_tab = true,          -- diff opens in a fresh tab, never pollutes current layout
    hide_terminal_in_new_tab = true, -- no terminal split in the diff tab (we use tmux popup)
  },
}

-- Document the <leader>a group in which-key (loaded earlier in init.lua).
pcall(function() require('which-key').add { { '<leader>a', group = '[A]I (Claude)' } } end)

-- These all work over the WebSocket regardless of where Claude runs, so they
-- drive the popup's Claude from inside nvim:
vim.keymap.set('n', '<leader>ab', '<Cmd>ClaudeCodeAdd %<CR>', { desc = 'Claude: add current [b]uffer' })
vim.keymap.set('v', '<leader>as', '<Cmd>ClaudeCodeSend<CR>', { desc = 'Claude: [s]end selection' })
vim.keymap.set('n', '<leader>aa', '<Cmd>ClaudeCodeDiffAccept<CR>', { desc = 'Claude: [a]ccept diff' })
vim.keymap.set('n', '<leader>ad', '<Cmd>ClaudeCodeDiffDeny<CR>', { desc = 'Claude: [d]eny diff' })
