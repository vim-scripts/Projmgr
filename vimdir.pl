#!/usr/bin/perl
###############################################################################
## file:        $RCSfile: vimdir.pl,v $ $Revision: 1.2 $
## module:      @MODULE@
## authors:     YOURNAME
## last mod:    $Author: wliang $ at $Date: 2002/04/27 20:31:01 $
##
## created:     Thu Apr 18 21:55:05 2002
##
## copyright:   (c) 2002 YOURNAME
##
## notes:
## 
## description: This script is used by install.sh when using user specified
##              vim direcotry. It replace the default vim directory 
##              $home/.vim/ with the command line argument
##
###############################################################################
use File::Copy;

sub VimDirectory
{
   open PROJ_FILE, 'plugin/Projmgr.vim'  or die "can't open the vim script file.";
   open TMP_FILE, '>', '.vimdir_tmp.vim' or die "can't open temporary file.";

   while ( <PROJ_FILE> )
   {
      if ( /^(let s:projmgr_dir =).*/ )
      {
         printf TMP_FILE "%s \"%s", $1, @_[0];
         print TMP_FILE '/' if @_[0] !~ m#/$#;
         print TMP_FILE "plugin/\"\n";
      }
      else
      {
         print TMP_FILE $_;
      }
   }

   close( PROJ_FILE );
   close( TMP_FILE );
}
         
         
######
# Main part of the script
######

VimDirectory( $ARGV[0] );

copy( ".vimdir_tmp.vim", "plugin/Projmgr.vim" ) 
   or die "Copy failed.\n";
unlink( TMP_FILE );
