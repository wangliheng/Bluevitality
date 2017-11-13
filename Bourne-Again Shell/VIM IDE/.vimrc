function! Setup_ExecNDisplay()
  execute "w"
  execute "silent !chmod +x %:p"
  let n=expand('%:t')
  execute "silent !%:p 2>&1 | tee ~/.vim/output_".n
  " I prefer vsplit"
  execute "split ~/.vim/output_".n
  execute "vsplit ~/.vim/output_".n
  execute "redraw!"
  set autoread
endfunction

:nmap <F5> :call Setup_ExecNDisplay()

