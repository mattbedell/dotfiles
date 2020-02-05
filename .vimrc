let &t_SI = "\e[0 q"
let &t_SR = "\e[4 q"
let &t_EI = "\e[2 q"

syntax on

" toggle hybrid line numbers based on mode
:set number relativenumber
:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
:  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
:augroup END
