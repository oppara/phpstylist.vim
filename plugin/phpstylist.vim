" File: phpstylist.vim
" Version: 0.2
" Author: oppara <oppara _at_ oppara.tv>
" WebPage: https://github.com/oppara/phpstylist.vim
" License: MIT License

if exists('g:loaded_phpstylist')
  finish
endif
let g:loaded_phpstylist = 1

let s:save_cpo = &cpo
set cpo&vim

command! -nargs=? -range=0 PhpStylist call phpstylist#php_stylist(<count>, <line1>, <line2>, <args>)

let &cpo = s:save_cpo
unlet s:save_cpo
