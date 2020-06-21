" -- Vim Native linting --
" setlocal makeprg=npx\ eslint\ --format\ unix
" augroup JSLint
"   autocmd! * <buffer>
"   autocmd BufWritePost <buffer> silent make! <afile> | silent redraw!
"   autocmd QuickFixCmdPost [^l]* cwindow " auto open quickfix window
" augroup END

if exists('g:lsp_loaded')
  setlocal omnifunc=lsp#complete
endif

setlocal include=^\\s*[^\/]\\+\\(from\\\|require(['\"]\\)

