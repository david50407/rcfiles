function! VSCodeNotifyVisual(cmd, leaveSelection, ...)
    let mode = mode()
    if mode ==# 'V'
        let startLine = line('v')
        let endLine = line('.')
        call VSCodeNotifyRange(a:cmd, startLine, endLine, a:leaveSelection, a:000)
    elseif mode ==# 'v' || mode ==# "\<C-v>"
        let startPos = getpos('v')
        let endPos = getpos('.')
        call VSCodeNotifyRangePos(a:cmd, startPos[1], endPos[1], startPos[2], endPos[2] + 1, a:leaveSelection, a:000)
    else
        call VSCodeNotify(a:cmd, a:000)
    endif
endfunction

xnoremap <C-/> <Cmd>call VSCodeNotifyVisual('editor.action.commentLine', 1)<CR>
xnoremap u <Cmd>call VSCodeNotify('undo')<CR>
xnoremap <C-r> <Cmd>call VSCodeNotify('redo')<CR>

xmap gc  <Plug>VSCodeCommentary
nmap gc  <Plug>VSCodeCommentary
omap gc  <Plug>VSCodeCommentary
nmap gcc <Plug>VSCodeCommentaryLine

nnoremap <C-w><C-b> <Cmd>call VSCodeNotify('workbench.view.explorer')<CR>

""region Commands
command Reload :so $HOME/.config/nvim/vscode.vim | :echo "vscode.vim reloaded"
command Tree :call VSCodeNotify('workbench.view.explorer')
""endregion
