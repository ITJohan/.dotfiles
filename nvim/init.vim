call plug#begin("~/.vim/plugged")

" Theme
Plug 'morhetz/gruvbox'

" Intellisense
Plug 'neoclide/coc.nvim', {'branch': 'release'}
let g:coc_global_extensions = ['coc-emmet', 'coc-css', 'coc-html', 'coc-json', 'coc-prettier', 'coc-tsserver']

" Syntax highlighting for all languages
Plug 'sheerun/vim-polyglot'
Plug 'chemzqm/vim-jsx-improve' 

" Search for files
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Infobar at bottom
Plug 'vim-airline/vim-airline'

" For searching in files
Plug 'mileszs/ack.vim'

call plug#end()

" General settings
set expandtab     " Insert spaces when tab is pressed
set tabstop=2     " Number of characters inserted when tab is pressed
set shiftwidth=2  " Number of space characters inserted for indentation
set softtabstop=2 " Insert and delete number of spaces
set cursorline    " Highlight current line
set number relativenumber " Show hybrid line numbers to the left
set visualbell
set splitright    " Open vertical split to right
set splitbelow    " Open horizontal split at bottom
set termguicolors " Enable theming support
set scrolloff=20  " Lines above and below cursor when scrolling
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o  " Disable auto comment on next line on enter after comment

" Theme
syntax on
set background=dark " Theme color (dark/light)
let g:gruvbox_italic=1
colorscheme gruvbox
" Set the background to terminal background (for transparency)
hi! Normal ctermbg=NONE guibg=NONE

nnoremap <C-p> :FZF<CR>
let g:fzf_action = {
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-s': 'split',
      \ 'ctrl-v': 'vsplit'
      \}
" requires silversearcher-ag
" used to ignore gitignore files
let $FZF_DEFAULT_COMMAND = 'ag -g ""'

" use alt+hjkl to move between split/vsplit panels
tnoremap <A-h> <C-\><C-n><C-w>h
tnoremap <A-j> <C-\><C-n><C-w>j
tnoremap <A-k> <C-\><C-n><C-w>k
tnoremap <A-l> <C-\><C-n><C-w>l
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Pressing Shift+k inspects thing over cursor
nnoremap <S-k> :call CocActionAsync('doHover')<cr>
