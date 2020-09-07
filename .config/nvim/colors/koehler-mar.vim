highlight clear
set background=dark
if exists("syntax_on")
	syntax reset
endif
runtime colors/koehler.vim
let g:colors_name = "koehler-mar"

hi Directory	ctermfg=blue
hi Search	ctermbg=blue
hi Comment	cterm=none	ctermfg=darkcyan
hi SpellBad	ctermbg=yellow
hi Identifier	ctermfg=cyan
hi MatchParen	ctermbg=green	ctermfg=red
hi Constant	ctermfg=blue
hi PreProc	ctermfg=magenta
hi ErrorMsg	ctermfg=white
hi LineNr	cterm=none	ctermfg=darkcyan
