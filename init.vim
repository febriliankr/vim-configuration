call plug#begin('~/.local/share/nvim/site/autoload/plug.vim')  

" Specify a directory for plugins
call plug#begin('~/.vim/plugged')
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'airblade/vim-rooter'
Plug 'skywind3000/asyncrun.vim'
Plug 'samgriesemer/vim-roam'
Plug 'antoinemadec/FixCursorHold.nvim'
Plug '907th/vim-auto-save'
Plug 'github/copilot.vim'
Plug 'projekt0n/github-nvim-theme'
Plug 'arcticicestudio/nord-vim'
Plug 'mattn/emmet-vim'
Plug 'airblade/vim-gitgutter'
" Golang Setup
Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}
Plug 'scrooloose/nerdcommenter'

"Plug 'prettier/vim-prettier', {
  "\ 'do': 'yarn install --frozen-lockfile --production',
  "\ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'vue', 'svelte', 'yaml', 'html'] }
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'sonph/onehalf', {'rtp': 'vim/'}
Plug 'Yggdroot/indentLine' 
Plug 'HerringtonDarkholme/yats.vim' " TS Syntax
" Initialize plugin system
call plug#end()

colorscheme github_dark

" Prettier coc setup
command! -nargs=0 Prettier :call CocAction('runCommand', 'prettier.formatFile')
" Prettier / press '\p' to run prettier command
nnoremap <leader>p :Prettier<return>

" highlight removal remapping (on press \)
nnoremap \ :noh<return>

" Netrw Configuration
let g:netrw_banner = 0        " remove directions at top of file listing
let g:netrw_liststyle=3       " tree style listing
let g:netrw_browse_split = 3  " split horizontal
let g:netrw_altv = 1
let g:netrw_winsize=25        " width of window
let g:netrw_preview=1
nnoremap <Leader>da :Lexplore<CR>
nnoremap <leader>dd :Lexplore %:p:h<CR>
let g:cursorhold_updatetime = 100
" CoC Configuration
let g:coc_borderchars = ['─', '│', '─', '│', '╭', '╮', '╯', '╰']
" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')
" CoC Explorer Configuration
" Fzf Configuration
nmap <space>e <Cmd>CocCommand explorer<CR>
nnoremap <silent> <C-p> :Files<CR>
nnoremap <silent> <C-g> :GFiles<CR>
nnoremap <silent> <C-o> :Buffers<CR>
nnoremap <C-f> :Rg! 

inoremap jk <ESC>

set mouse=a
set number
set hidden
set cursorline
set expandtab
set autoindent
set smartindent
set shiftwidth=4
set tabstop=4
set encoding=UTF-8
set history=5000
set clipboard=unnamedplus

" NERDCommenter Configuration
vmap ++ <plug>NERDCommenterToggle
nmap ++ <plug>NERDCommenterToggle

set autochdir

"let g:prettier#quickfix_enabled = 0
"let g:prettier#quickfix_auto_focus = 0
 "run prettier on save
"let g:prettier#autoformat = 0
"autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue,*.yaml,*.html PrettierAsync


" j/k will move virtual lines (lines that wrap)
noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')
nnoremap <C-s> :w<CR>
nnoremap <C-Q> :wq<CR>

" shift+arrow selection
nmap <S-Up> v<Up>
nmap <S-Down> v<Down>
nmap <S-Left> v<Left>
nmap <S-Right> v<Right>
vmap <S-Up> <Up>
vmap <S-Down> <Down>
vmap <S-Left> <Left>
vmap <S-Right> <Right>
imap <S-Up> <Esc>v<Up>
imap <S-Down> <Esc>v<Down>
imap <S-Left> <Esc>v<Left>
imap <S-Right> <Esc>v<Right>

set cindent

set laststatus=2
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_statusline_ontop=0
let g:airline_theme='base16_tomorrow'

let g:airline#extensions#tabline#formatter = 'default'
" navegação entre os buffers
nnoremap <M-Right> :bn<cr>
nnoremap <M-Left> :bp<cr>
nnoremap <c-x> :bp \|bd #<cr>

" -------------------------------------------------------------------------------------------------
" coc.nvim default settings
" -------------------------------------------------------------------------------------------------

" Remap for rename current word
nmap <F2> <Plug>(coc-rename)

" if hidden is not set, TextEdit might fail.
set hidden
" Better display for messages
set cmdheight=2
" Smaller updatetime for CursorHold & CursorHoldI
set updatetime=300
" don't give |ins-completion-menu| messages.
set shortmess+=c
" always show signcolumns
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
"inoremap <silent><expr> <TAB>
      "\ pumvisible() ? "\<C-n>" :
      "\ <SID>check_back_space() ? "\<TAB>" :
      "\ coc#refresh()
"inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)

" disable vim-go :GoDef short cut (gd)
" this is handled by LanguageClient [LC]
let g:go_doc_popup_window = 1
let g:go_def_mapping_enabled = 0
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
vmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

" disable vim-go :GoDef short cut (gd)
" this is handled by LanguageClient [LC]
let g:go_def_mapping_enabled = 0
