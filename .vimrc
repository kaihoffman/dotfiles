syntax enable " syntax highlighting

" Get off my lawn to teach me to stop relying on arrow keys
nnoremap <Left> :echoe "Use h for left"<CR>
nnoremap <Right> :echoe "Use l for right"<CR>
nnoremap <Up> :echoe "Use k for up"<CR>
nnoremap <Down> :echoe "Use j for down"<CR>

" Show line numbers, but relative in current file & only in visual mode. When not in focus or when in insert mode, show absolute line numbers. Credit to Jeff Kreetmeijer (https://jeffkreeftmeijer.com/vim-number/)
set number relativenumber
:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
:  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
:augroup END
