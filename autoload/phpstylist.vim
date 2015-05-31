" File: phpstylist.vim
" Version: 0.2
" Author: oppara <oppara _at_ oppara.tv>
" WebPage: https://github.com/oppara/phpstylist.vim
" License: MIT License

let s:save_cpo = &cpo
set cpo&vim

if !exists('g:phpstylist_options')
  let g:phpstylist_options = {
    \ 'default' : [
    \ '--indent_size 4 ',
    \ '--keep_redundant_lines ',
    \ '--space_after_comma ',
    \ '--space_around_assignment ',
    \ '--space_around_comparison ',
    \ '--space_around_arithmetic ',
    \ '--space_around_logical ',
    \ '--space_around_colon_question ',
    \ '--line_before_function ',
    \ '--space_after_if ',
    \ '--space_inside_for ',
    \ '--add_missing_braces ',
    \ '--indent_case ',
    \ '--space_around_double_arrow ',
    \ '--space_around_concat ',
    \ '--vertical_array ',
    \ '--align_array_assignment',
    \ '--line_before_comment_multi ',
    \ '--align_var_assignment ',
    \ '--line_after_break '
    \]
  \}
endif

if !exists('g:phpstylist_tmp_path')
  let g:phpstylist_tmp_path = '/tmp/phpstylist'
endif

if !exists('g:phpstylist_php_interpreter')
  let g:phpstylist_php_interpreter = system('echo -n `which php`')
endif


function! phpstylist#php_stylist(has_range, line1, line2, ...)
  if (len(a:000) != 0)
    if (!has_key(g:phpstylist_options, a:000[0]))
      echoerr "no exists key: " . a:000[0]
      return
    endif
    let l:opts = g:phpstylist_options[a:000[0]]
  else
    let l:opts = g:phpstylist_options['default']
  endif

  if !exists('g:phpstylist_cmd_path')
    echoerr "you must be set g:phpstylist_cmd_path."
    return
  endif

  if !filereadable(g:phpstylist_cmd_path)
    echoerr "could not readable g:phpstylist_cmd_path [" . g:phpstylist_cmd_path . "]."
    return
  endif

  let l:cmd = g:phpstylist_php_interpreter . ' ' . g:phpstylist_cmd_path . ' '
  let l:tmp = g:phpstylist_tmp_path

  let l:args = ''
  for opt in l:opts
    let l:args .= ' ' . opt
  endfor
  if a:has_range
    call writefile(getline(a:line1, a:line2), g:phpstylist_tmp_path)
    let l:res = system(l:cmd . g:phpstylist_tmp_path . l:args)

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
    execute ':%:!' . l:cmd . ' % ' . l:args
    execute ':normal `x'
  endif

endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
