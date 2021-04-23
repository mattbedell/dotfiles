local usr_util = require'usr.util'

usr_util.create_augroups({
  WinAutoResize = {
    {'VimResized', '*', 'wincmd ='},
  }
})
