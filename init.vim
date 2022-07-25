call plug#begin('~/.local/share/nvim/site/autoload/plug.vim')  
" init vim references for treesitter: https://github.com/elijahmanor/dotfiles/blob/master/nvim/.config/nvim/init.vim
" Specify a directory for plugins
call plug#begin('~/.vim/plugged')
Plug 'leafOfTree/vim-svelte-plugin'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'preservim/nerdtree'
" Snippet Plugins
Plug 'SirVer/ultisnips'
Plug 'mlaursen/vim-react-snippets'
" Treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Fzf for Search
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'yuki-yano/fzf-preview.vim', { 'branch': 'release/rpc' }

Plug 'airblade/vim-rooter'
Plug 'skywind3000/asyncrun.vim'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'antoinemadec/FixCursorHold.nvim'
Plug '907th/vim-auto-save'
Plug 'github/copilot.vim'
" Theme
Plug 'projekt0n/github-nvim-theme'

Plug 'mattn/emmet-vim'
Plug 'airblade/vim-gitgutter'
Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}
Plug 'scrooloose/nerdcommenter'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'arthurxavierx/vim-caser'
Plug 'sonph/onehalf', {'rtp': 'vim/'}
Plug 'Yggdroot/indentLine' 
Plug 'HerringtonDarkholme/yats.vim' " TS Syntax
" Initialize plugin system
call plug#end()

colorscheme github_dark

" coc-go settings for Go/Golang Development
autocmd BufWritePre *.go :silent call CocAction('runCommand', 'editor.action.organizeImport')

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
let g:cursorhold_updatetime = 80
" CoC Configuration
let g:coc_borderchars = ['─', '│', '─', '│', '╭', '╮', '╯', '╰']
" Use Shift + K to show documentation in preview window
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
:nmap <space>e <Cmd>CocCommand explorer<CR>

" Fzf Configuration
"if has('nvim')
  "aug fzf_setup
    "au!
    "au TermOpen term://*FZF tnoremap <silent> <buffer> <esc><esc> <c-c>
  "aug END
"end
" Files + devicons + floating fzf
function! FzfFilePreview()
  let l:fzf_files_options = '--preview "bat --theme="OneHalfDark" --style=numbers,changes --color always {3..-1} | head -200" --expect=ctrl-v,ctrl-x'
  let s:files_status = {}

  function! s:cacheGitStatus()
    let l:gitcmd = 'git -c color.status=false -C ' . $PWD . ' status -s'
    let l:statusesStr = system(l:gitcmd)
    let l:statusesSplit = split(l:statusesStr, '\n')
    for l:statusLine in l:statusesSplit
      let l:fileStatus = split(l:statusLine, ' ')[0]
      let l:fileName = split(l:statusLine, ' ')[1]
      let s:files_status[l:fileName] = l:fileStatus
    endfor
  endfunction

  function! s:files()
    call s:cacheGitStatus()
    let l:files = split(system($FZF_DEFAULT_COMMAND), '\n')
    return s:prepend_indicators(l:files)
  endfunction

  function! s:prepend_indicators(candidates)
    return s:prepend_git_status(s:prepend_icon(a:candidates))
  endfunction

  function! s:prepend_git_status(candidates)
    let l:result = []
    for l:candidate in a:candidates
      let l:status = ''
      let l:icon = split(l:candidate, ' ')[0]
      let l:filePathWithIcon = split(l:candidate, ' ')[1]

      let l:pos = strridx(l:filePathWithIcon, ' ')
      let l:file_path = l:filePathWithIcon[pos+1:-1]
      if has_key(s:files_status, l:file_path)
        let l:status = s:files_status[l:file_path]
        call add(l:result, printf('%s %s %s', l:status, l:icon, l:file_path))
      else
        " printf statement contains a load-bearing unicode space
        " the file path is extracted from the list item using {3..-1},
        " this breaks if there is a different number of spaces, which
        " means if we add a space in the following printf it breaks.
        " using a unicode space preserves the spacing in the fzf list
        " without breaking the {3..-1} index
        call add(l:result, printf('%s %s %s', ' ', l:icon, l:file_path))
      endif
    endfor

    return l:result
  endfunction

  function! s:prepend_icon(candidates)
    let l:result = []
    for l:candidate in a:candidates
      let l:filename = fnamemodify(l:candidate, ':p:t')
      let l:icon = WebDevIconsGetFileTypeSymbol(l:filename, isdirectory(l:filename))
      call add(l:result, printf('%s %s', l:icon, l:candidate))
    endfor

    return l:result
  endfunction

  function! s:edit_file(lines)
    if len(a:lines) < 2 | return | endif

    let l:cmd = get({'ctrl-x': 'split',
                 \ 'ctrl-v': 'vertical split',
                 \ 'ctrl-t': 'tabe'}, a:lines[0], 'e')

    for l:item in a:lines[1:]
      let l:pos = strridx(l:item, ' ')
      let l:file_path = l:item[pos+1:-1]
      execute 'silent '. l:cmd . ' ' . l:file_path
    endfor
  endfunction

  call fzf#run({
        \ 'source': <sid>files(),
        \ 'sink*':   function('s:edit_file'),
        \ 'options': '-m --preview-window=right:70%:noborder --prompt Files\> ' . l:fzf_files_options,
        \ 'down':    '40%',
        \ 'window': 'call FloatingFZF()'})

endfunction
nnoremap <silent> <C-p> :Files<CR>
nnoremap <silent> <C-g> :GFiles<CR>
nnoremap <silent> <C-o> :Buffers<CR>
nnoremap <C-f> :Rg 

" Set No background, so I can use iTerm2 Background Image
hi Normal guibg=NONE ctermbg=NONE
hi airline_tabfill ctermbg=NONE guibg=NONE
hi airline_c  ctermbg=NONE guibg=NONE
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

set cindent

" Treesitter
" nvim-treesitter {{{
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = { 'go', 'html', 'javascript', 'typescript', 'tsx', 'css', 'json', 'svelte' },
  -- ensure_installed = "all", -- or maintained
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = true
  },
  indent = {
    enable = false
  },
  context_commentstring = {
    enable = true
  }
}
EOF
" }}}
" Journaling
iabbrev onething What's the one thing that I can do today, such by doing that, everything else will become easier?

set laststatus=2
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_statusline_ontop=0
let g:airline_theme='transparent'

let g:airline#extensions#tabline#formatter = 'default'

" Remap moving between buffers
"nnoremap <M-Up> :bn<cr>
"nnoremap <M-Down> :bp<cr>
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
" Set relative number
set relativenumber

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
"nmap <silent> gy <Plug>(coc-type-definition)
"nmap <silent> gi <Plug>(coc-implementation)
"nmap <silent> gr <Plug>(coc-references)

" Golang Coc 
cabbrev t tabnew
cabbrev coc CocCommand
cabbrev ccgt CocCommand go.tags.add json
cabbrev ccgic CocCommand go.impl.cursor
cabbrev ccgtt CocCommand go.test.toggle
autocmd FileType go nmap gic :CocCommand go.impl.cursor <cr>
autocmd FileType go nmap gtj :CocCommand go.tags.add json<cr>
autocmd FileType go nmap gtd :CocCommand go.tags.add db<cr>
autocmd FileType go nmap gtx :CocCommand go.tags.clear<cr>
" Remap for format selected region
vmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
"nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
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

" this is handled by LanguageClient [LC]
let g:go_def_mapping_enabled = 0
