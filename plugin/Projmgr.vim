" Vim global plugin for loading/unloading/switching between sessions.
" Last Change: Tue Apr 23 2002
" Maintainer: Wenzhi Liang <wzhliang_at_yahoo.com>

if exists("loaded_projects_menu")
    finish
endif
if !has("gui")
   finish
endif

let loaded_projects_menu = 1

amenu 150.10 Projects.Save\ to\ project :call <SID>SaveToProj()<CR>
amenu 150.20 Projects.Refresh           :call <SID>RefreshList()<CR>
amenu 150.25 Projects.Current\ project  :echo fnamemodify( v:this_session, ":t:r" )<CR>
amenu 150.200 Projects.Unload.Empty      <nul>
unmenu Projects.Unload.Empty 


"Load the project.load menu
let s:proj_dir = expand("~") . "/.vim/projects/"
let s:lists = glob( s:proj_dir . "*.vim" )

while ( strlen( s:lists ) > 0 )
   let s:i = stridx( s:lists, "\n" )
   if ( s:i < 0 )
     let s:name = s:lists
     let s:lists = ""
   else
      let s:name = strpart( s:lists, 0, s:i )
      let s:lists = strpart( s:lists, s:i + 1, 19999 )
   endif

   let s:item = substitute(s:name, '.*[/\\:]\([^/\\:]*\)\.vim', '\1', '')
   let s:name = escape( s:name, ' \')
   exe "amenu 150.30 Projects.Load." . s:item . " :call <SID>LoadProject( \"" . s:item . "\")<CR>"
   exe "amenu 150.40 Projects.Delete." . s:item . " :call <SID>RemoveItem( \"" . s:item . "\")<CR>"
   unlet s:i
   unlet s:name
endwhile

unlet s:lists
"Finished adding Projects.Load. menus

"Load the Projects.Switch to menu
let s:lists = glob( s:proj_dir . "*.vim" )

while ( strlen( s:lists ) > 0 )
   let s:i = stridx( s:lists, "\n" )
   if ( s:i < 0 )
     let s:name = s:lists
     let s:lists = ""
   else
      let s:name = strpart( s:lists, 0, s:i )
      let s:lists = strpart( s:lists, s:i + 1, 19999 )
   endif

   let s:item = substitute(s:name, '.*[/\\:]\([^/\\:]*\)\.vim', '\1', '')
   let s:name = escape( s:name, ' \')
   exe 'amenu 150.30 Projects.Switch\ to.' . s:item . " :call <SID>SwitchToProject( \"" . s:item . "\")<CR>"
   unlet s:i
   unlet s:name
endwhile

unlet s:lists
"Finished loading the Projects.Switch to menu

function! <SID>LoadProject( item )
   let s:cmd = ":so " . s:proj_dir . a:item . ".vim"
   "echo s:cmd 
   silent! aunmenu Projects.Unload.Empty
   exe "amenu 150.200 Projects.Unload." . a:item . " :call <SID>UnloadProject( \"" . a:item . "\")<CR>" 
   "exe ":so \"" . s:what_file . "\"<CR>"
   exe s:cmd
endfunc

function! <SID>SaveToProj()
   let s:item = input( "Name of the project: " ) 
   let s:name = s:proj_dir . s:item . ".vim"
   "echo s:name
   if filereadable( s:name )  
       let s:overwrite = input ("File exsist already, overwrite?")
       if s:overwrite == "y"
          "echo s:name
          exe "mksession! " . s:name 
       endif
       unlet s:overwrite
   else
       "echo s:name
       exe "mksession " . s:name 
       exe "amenu 150.30 Projects.Load." . s:item . " :so " s:name . "<CR>"
       exe "amenu 150.40 Projects.Delete." . s:item . " :call <SID>RemoveItem( \"" . s:item . "\")<CR>"
   endif
   exe "redraw | echo \"\\rProject " . s:item . " saved.      \""
   unlet s:name
endfunc

function! <SID>RefreshList()
   let s:lists = glob( s:proj_dir . "*.vim" )

   "echo s:lists
   aunmenu Projects.Load
   aunmenu Projects.Delete

   while ( strlen( s:lists ) > 0 )
      let s:i = stridx( s:lists, "\n" )
      if ( s:i < 0 )
        let s:name = s:lists
        let s:lists = ""
      else
         let s:name = strpart( s:lists, 0, s:i )
         let s:lists = strpart( s:lists, s:i + 1, 19999 )
      endif

     " let s:item = substitute( s:name, '.*\\\(.*\)\.vim', "\1", "")
      let s:item = substitute(s:name, '.*[/\\:]\([^/\\:]*\)\.vim', '\1', '')
      let s:name = escape( s:name, ' \')
      exe "amenu 150.30 Projects.Load." . s:item . " :so " . s:name . "<CR>"
      exe "amenu 150.40 Projects.Delete." . s:item . " :call <SID>RemoveItem( \" " . s:item . "\")<CR>"
      unlet s:i
      unlet s:name
   endwhile

   unlet s:lists
   echo 'proj.vim: List updated.'
endfunc

function! <SID>RemoveItem( item )
   let s:name = s:proj_dir . a:item . ".vim"

   let s:sure = input ( "Are you sure you want to delete that file?" )
   if s:sure != "y"
      return
   endif

   let s:deleted = delete( s:name )
   if s:deleted == 0
      exe "aunmenu Projects.Delete." . a:item
      exe "aunmenu Projects.Load." . a:item
      exe "redraw | echo \"\\rOK.\""
   else
      exe "redraw | echo \"\\r:(\""
   endif
   unlet s:name
endfunc

function! <SID>UnloadProject( proj )
"Have to fix this later
   let s:cmd = expand ("~") . "/.vim/plugin/perl/buffers.pl " . s:proj_dir . a:proj . ".vim"
   let s:bufs_to_unload = system( s:cmd )

   while strlen( s:bufs_to_unload ) > 0 
      let s:i = stridx( s:bufs_to_unload , "\n" )
      if s:i < 0 " or s:i == strlen(s:bufs_to_unload)
         finish
      else
         let s:this_buffer= strpart( s:bufs_to_unload, 0, s:i )
         exe "bd " . s:this_buffer
         let s:bufs_to_unload = strpart( s:bufs_to_unload, s:i + 2, 19999 )
      endif
   endwhile

   exe "aunmenu Projects.Unload." . a:proj
   silent! aunmenu Projects.Unload.Empty

   unlet s:cmd
   unlet s:i
   unlet s:this_buffer
   unlet s:bufs_to_unload
endfunc

function! <SID>SwitchToProject( proj )
   let s:proj_name = fnamemodify( v:this_session,":t:r" )
   if s:proj_name == a:proj
      echo 'Why do you want to switch to yourself?'
      return
   endif

   call <SID>UnloadProject( s:proj_name )
   call <SID>LoadProject( a:proj )

endfunc

"This is the end of the script.   
