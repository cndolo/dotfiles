" Basic editor settings
set showmatch                 " Show matching brackets.
"set number relativenumber     " Turn relative line numbers on.
"set nonumber norelativenumber " Turn hybrid line numbers off.
"set number! relativenumber!   " Toggle hybrid line numbers
set formatoptions+=o          " Continue comment marker in new lines.
set textwidth=0               " Hard-wrap long lines as you type them.
set shiftwidth=4              " Indentation amount for < and > commands.
set tabstop=4                 " Render TABs using this many spaces.
set linespace=0               " Set line-spacing to minimum.
set expandtab                 " Put spaces instead of tabs.
set nojoinspaces              " Prevents inserting two spaces after punctuation
set encoding=utf-8
augroup my_textwidth
au!
autocmd FileType text,markdown,tex setlocal textwidth=100
augroup END

" More natural splits
set splitbelow                " Horizontal split below current.
set splitright                " Vertical split to right of current.

if !&scrolloff
  set scrolloff=3             " Show next 3 lines while scrolling.
endif
if !&sidescrolloff
  set sidescrolloff=5         " Show next 5 columns while side-scrolling.
endif
set nostartofline             " Do not jump to first character with page commands.

" Search
set ignorecase                " Make searching case insensitive
set smartcase                 " ... unless the query has capital letters.
set gdefault                  " Use 'g' flag by default with :s/foo/bar/.
set magic                     " Use 'magic' patterns (extended regular expressions).
set cpoptions+=x
set autoread

"Colours
set background=dark
syntax enable
let g:airline_theme='distinguished'

" use ripgrep as :grep backend if available
if executable('rg')
    set grepprg=rg\ --vimgrep\ --color=never
endif

" Plugins
call plug#begin()
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

Plug 'ctrlpvim/ctrlp.vim'
Plug 'scrooloose/nerdtree'
Plug 'junegunn/fzf'
Plug 'nvim-neo-tree/neo-tree.nvim'

Plug 'lervag/vimtex'

Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-orgmode/orgmode'

Plug 'ntpeters/vim-better-whitespace'
Plug 'rcarriga/nvim-notify'

call plug#end()

" Open file menu
nnoremap <Leader>o :CtrlP<CR>
" Open buffer menu
nnoremap <Leader>b :CtrlPBuffer<CR>
" Open most recently used files
nnoremap <Leader>f :CtrlPMRUFiles<CR>
" CtrlP ignore files
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.o,*.bak*,*/target/*
" CtrlP custom ignore
let g:ctrlp_custom_ignore = 'build/\|DS_Store\|git'

" configure which whitespace checks to enable.
" indent: mixed indent within a line
" long:   overlong lines
" trailing: trailing whitespace
" mixed-indent-file: different indentation in different lines
let g:airline#extensions#whitespace#checks = ['trailing', 'long']

" Enable highlighting
let g:better_whitespace_enabled=1
" Stripping whitespace on save by default
"let g:strip_whitespace_on_save=1
nnoremap ss :NextTrailingWhitespace<CR>
nnoremap SS :PrevTrailingWhitespace<CR>

let g:python_recommended_style=0	"turn off PEP-8 style by setting
let g:tex_flavor = "latex"

" Snippets
let g:UltiSnipsExpandTrigger='<tab>'

" Coc LSP
let g:coc_global_extensions = ['coc-rust-analyzer', 'coc-pyright', 'coc-go', 'coc-sh', 'coc-texlab', 'coc-json', 'coc-git', 'coc-markdownlint']

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <Tab>
      \ coc#pum#visible() ? coc#pum#next(1):
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Coc GoTo code navigation.
nmap <leader>d <Plug>(coc-definition)
nmap <leader>t <Plug>(coc-type-definition)
nmap <leader>i <Plug>(coc-implementation)
nmap <leader>r <Plug>(coc-references)

"FZF
" This is the default extra key bindings
let g:fzf_action = {
  \ 'ctrl-s': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" An action can be a reference to a function that processes selected lines
function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

let g:fzf_action = {
  \ 'ctrl-q': function('s:build_quickfix_list'),
  \ 'ctrl-s': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" Default fzf layout
" - Popup window
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }

" - down / up / left / right
"let g:fzf_layout = { 'down': '40%' }

" - Window using a Vim command
let g:fzf_layout = { 'window': 'enew' }
let g:fzf_layout = { 'window': '-tabnew' }
let g:fzf_layout = { 'window': '10new' }

" Customize fzf colors to match your color scheme
" - fzf#wrap translates this to a set of `--color` options
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" Nerdtree
nmap <F1> :NERDTreeToggle<CR>

" Auto reload vim configurations after writing init.vim
augroup myvimrchooks
  au!
  autocmd bufwritepost init.vim source ~/.config/nvim/init.vim
augroup END

" NVIM orgmode
lua << EOF
-- Load custom tree-sitter grammar for org filetype
require('orgmode').setup_ts_grammar()

-- Tree-sitter configuration
require'nvim-treesitter.configs'.setup {
  -- If TS highlights are not enabled at all, or disabled via `disable` prop, highlighting will fallback to default Vim syntax highlighting
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = {'org'}, -- Required for spellcheck, some LaTex highlights and code block highlights that do not have ts grammar
  },
  ensure_installed = {'org'}, -- Or run :TSUpdate org
}

require('orgmode').setup({
   -- org_agenda_files = {'~/Dropbox/org/*', '~/my-orgs/**/*'},
   -- org_default_notes_file = '~/Dropbox/org/refile.org',
})
EOF
