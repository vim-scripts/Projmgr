#!/bin/bash 

echo "Input the directory where you installed vim:"
echo "(simply hit return if you want to install in your home directory)"
read vim_dir

case "$vim_dir" in
"")     
   vim_dir=${HOME}/.vim
                 ;;
*)      
   ./vimdir.pl ${vim_dir} > .vimdir_tmp.vim
                 ;;
esac

cp -r doc ${vim_dir}
cp -r plugin ${vim_dir}
mkdir -p ${HOME}/.vim/projects
