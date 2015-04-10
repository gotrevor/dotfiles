" from http://vim.wikia.com/wiki/VimTip271
map ,# :s/^/#/<CR>
call pathogen#infect()
filetype plugin indent on
set foldmethod=syntax
nnoremap <Space> za
syntax on
" set number
set ts=2
set shiftwidth=2
set expandtab
set mouse=a
map <ScrollWheelUp> <C-Y>
map <ScrollWheelDown> <C-E>
" set clipboard=unnamed
set scrolloff=7
nmap <F2> :set paste<CR>:r !pbpaste<CR>:set nopaste<CR>
imap <F2> <Esc>:set paste<CR>:r !pbpaste<CR>:set nopaste<CR>

nnoremap <silent> <F5> :call <SID>StripTrailingWhitespaces()<CR>
function! <SID>StripTrailingWhitespaces()
  " Preparation: save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " Do the business:
  %s/\s\+$//e
  " Clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction
