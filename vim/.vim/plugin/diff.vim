
" https://gist.github.com/romainl/7198a63faffdadd741e4ae81ae6dd9e6
" With some modifications to make the scratch buffer (file on disk) behave like git index
" and window focus to be more inline with vim-fugitive
function! Diff(spec)
    let buffiletype = &filetype
    leftabove vnew
    setlocal bufhidden=wipe buftype=nofile nobuflisted noswapfile
    let &l:filetype = buffiletype
        let cmd = "++edit #"
    if len(a:spec)
        let cmd = "!git -C " . shellescape(fnamemodify(finddir('.git', '.;'), ':p:h:h')) . " show " . a:spec . ":#"
    endif
    execute "read " . cmd
    silent 0d_
    diffthis
    wincmd p
    diffthis
    wincmd p
endfunction
command! -nargs=? Diff call Diff(<q-args>)

