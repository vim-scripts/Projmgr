#!/usr/bin/perl
###############################################################################
## file:        $RCSfile: buffers.pl,v $ $Revision: 1.3 $
## module:      @MODULE@
## authors:     YOURNAME
## last mod:    $Author: wliang $ at $Date: 2002/04/25 23:46:17 $
##
## created:     Thu Apr 18 21:55:05 2002
##
## copyright:   (c) 2002 YOURNAME
##
## notes:
##
###############################################################################

sub BufferList
{
   my $proj_file;
   open ( $proj_file, @_[0] ) or die "can't open the fucking file.";
   my @lines = <$proj_file>;
   close $proj_file;
   my $currentPath;
   my $retVal;

   for ( @lines )
   {
#print $_;
      if ( /^cd\s+(.*)/ )
      {
         $currentPath = $1 . '/';
      }

#if ( /^edit\s+(.*)/ )
#{
#$retVal = $retVal . $currentPath . $1 . "\n";
#}

      if ( /^badd\s+\+\d+\s+(.*)/ )
      {
         $retVal = $retVal . $currentPath . $1 . "\n";
      }
   }

   return $retVal;
}
         
         
######
# Main part of the script
######

print BufferList( $ARGV[0] );
