" File: phpstylist.vim
" Version: 0.1
" Author: oppara <oppara _at_ oppara.tv>
" WebPage: https://github.com/oppara/phpstylist.vim
" License: MIT License

if exists('g:loaded_phpstylist')
  finish
endif
let g:loaded_phpstylist = 1


if !exists('g:phpstylist_cmd_opts')
  let g:phpstylist_cmd_opts = [
        \ '--indent_size 4 ',
        \ '--line_before_comment_multi ',
        \ '--keep_redundant_lines ',
        \ '--space_after_comma ',
        \ '--space_around_assignment ',
        \ '--align_var_assignment ',
        \ '--space_around_comparison ',
        \ '--space_around_arithmetic ',
        \ '--space_around_logical ',
        \ '--space_around_colon_question ',
        \ '--line_before_function ',
        \ '--space_after_if ',
        \ '--add_missing_braces ',
        \ '--space_inside_for ',
        \ '--indent_case ',
        \ '--line_after_break ',
        \ '--space_around_double_arrow ',
        \ '--space_around_concat ',
        \ '--vertical_array ',
        \ '--align_array_assignment'
        \]
endif

if !exists('g:phpstylist_tmp_path')
  let g:phpstylist_tmp_path = '/tmp/phpstylist'
endif

if !exists('g:phpstylist_php_interpreter')
  let g:phpstylist_php_interpreter = system('echo -n `which php`')
endif

let s:save_cpo = &cpo
set cpo&vim

function! s:php_stylist(has_range, line1, line2)
  if !exists('g:phpstylist_cmd_path')
    echoerr "you must be set g:phpstylist_cmd_path."
    return
  endif

  if !filereadable(g:phpstylist_cmd_path)
    echoerr "could not readable g:phpstylist_cmd_path [" . g:phpstylist_cmd_path . "]."
    return
  endif

  let l:cmd = g:phpstylist_php_interpreter . ' ' . g:phpstylist_cmd_path . ' '
  let l:opts = ''
  for opt in g:phpstylist_cmd_opts
    let l:opts .= ' ' . opt
  endfor

  let l:tmp = g:phpstylist_tmp_path
  if a:has_range
    call writefile(getline(a:line1, a:line2), g:phpstylist_tmp_path)
    let l:res = system(l:cmd . g:phpstylist_tmp_path . l:opts)

    let l:res = substitute(l:res, '<?php\s*', '', "")
    let l:res = substitute(l:res, '\s*?>$', '', "")
    let l:lines = split(l:res, "\n")

    execute ':silent ' . a:line1 . ',' . a:line2 . 'delete'
    call append(a:line1 - 1, l:lines)
    call delete(tmp)

    let l:cnt = len(l:lines) - 1
    execute ':normal! kV' . (l:cnt) .'k'
    execute ':normal! ='
  else
    execute ':normal mx'
    execute ':%:!' . l:cmd . ' % ' . l:opts
    execute ':normal `x'
  endif

endfunction

command! -range=0 PhpStylist call s:php_stylist(<count>, <line1>, <line2>)

let &cpo = s:save_cpo
unlet s:save_cpo
