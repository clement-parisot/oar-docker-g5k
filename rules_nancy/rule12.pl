# Title: Verify types of jobs (allowed by OAR)
# Description: Verify types of jobs (allowed by OAR)
my @types = ("container","inner","deploy","desktop_computing","besteffort","cosystem","idempotent","timesharing","allow_classic_ssh","iscsi","nfs","destructive","mic","production");
foreach my $t (@{$type_list}){
    my $i = 0;
    while (($types[$i] ne $t) and ($i <= $#types)){
        $i++;
    }
    if (($i > $#types) and ($t !~ /^timesharing|inner/)){
        die("[ADMISSION RULE] The job type $t is not handled by OAR; Right values are : @types\n");
    }
}
