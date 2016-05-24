# Title: Allow users
# Description: root, oar and g5kadmin users are not allowed to submit jobs
die ("[ADMISSION RULE] root, oar and g5kadmin users are not allowed to submit jobs.\n") if ( $user eq "root" or $user eq "oar" or $user eq "g5kadmin" );
