" named scratch buffers
if exists('g:loaded_scratch')
  finish
endif

let g:loaded_scratch = 1


let s:scratch_prefix = '[scratch]'

function! s:ScratchBufferCreate(buff_name)
  let buff_suffix = 'etc'
  if !empty(a:buff_name)
    let buff_suffix = a:buff_name
  endif
  let buff_full_name = s:scratch_prefix . ' ' . buff_suffix
  let buff_num = bufnr(buff_full_name, 1)

  execute 'buffer ' . buff_num
endfunction

function! s:ScratchBufferSetup()
  setlocal buftype=nofile
  setlocal bufhidden=hide
  setlocal noswapfile
  setlocal buflisted
endfunction


augroup scratch_setup
  autocmd!
  autocmd BufNewFile \[scratch\]* call s:ScratchBufferSetup()
augroup END

command! -nargs=? Scratch call <SID>ScratchBufferCreate(<q-args>)

