-- Live markdown preview in a browser tab, with mermaid diagram support.
-- https://github.com/iamcco/markdown-preview.nvim
--
-- Requires `npm install` in the plugin's app/ directory (see PackChanged handler in init.lua).
-- Usage: <leader>mp toggles the preview open/closed.

vim.pack.add { 'https://github.com/iamcco/markdown-preview.nvim' }

vim.keymap.set('n', '<leader>mp', '<Cmd>MarkdownPreviewToggle<CR>', { desc = '[M]arkdown [P]review toggle' })
