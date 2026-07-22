-- Seamless navigation between Neovim splits and tmux panes.
-- https://github.com/christoomey/vim-tmux-navigator
--
-- <C-h/j/k/l> move between nvim splits; when there is no split in that
-- direction, the motion continues into the adjacent tmux pane instead.
-- The matching tmux-side keybinds live in ~/.config/tmux/tmux.conf.

-- Disable the plugin's built-in mappings so we can define them ourselves
-- below. This MUST be set before the plugin is loaded by vim.pack.add.
vim.g.tmux_navigator_no_mappings = 1

vim.pack.add { 'https://github.com/christoomey/vim-tmux-navigator' }

vim.keymap.set('n', '<C-h>', '<Cmd>TmuxNavigateLeft<CR>', { desc = 'Navigate left (nvim split / tmux pane)' })
vim.keymap.set('n', '<C-j>', '<Cmd>TmuxNavigateDown<CR>', { desc = 'Navigate down (nvim split / tmux pane)' })
vim.keymap.set('n', '<C-k>', '<Cmd>TmuxNavigateUp<CR>', { desc = 'Navigate up (nvim split / tmux pane)' })
vim.keymap.set('n', '<C-l>', '<Cmd>TmuxNavigateRight<CR>', { desc = 'Navigate right (nvim split / tmux pane)' })
