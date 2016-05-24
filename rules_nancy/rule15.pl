# Title : Add inner job type if used during a practical session
# Description :  If $OAR_IN is defined, add -t inner=$OAR_IN to the job
if ($ENV{'OAR_IN'} =~ m/[0-9]+/ && !grep(/^inner/, @{$type_list})) {
        print("ADMISSION RULE] Work inside container job $ENV{'OAR_IN'}.\n") ;
        push(@{$type_list},"inner="."$ENV{'OAR_IN'}");
}
