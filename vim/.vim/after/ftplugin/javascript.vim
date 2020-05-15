setlocal makeprg=npx\ eslint\ --format\ unix
augroup JSLint
  autocmd! * <buffer>
  autocmd BufWritePost <buffer> silent make! <afile> | silent redraw!
  autocmd QuickFixCmdPost [^l]* cwindow " auto open quickfix window
augroup END

