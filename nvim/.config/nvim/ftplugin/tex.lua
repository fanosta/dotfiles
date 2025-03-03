local opts = { noremap = true, silent = true }

vim.api.nvim_buf_set_keymap(0, 'n', '<leader>lj', ":silent !/Applications/Skim.app/Contents/SharedSupport/displayline <C-r>=line('.')<CR> %<.pdf<CR>", opts)
