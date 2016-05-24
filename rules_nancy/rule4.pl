# Title: resource is not allowed

my @bad_resources = ("type","state","next_state","finaud_decision","next_finaud_decision","state_num","suspended_jobs","besteffort","deploy","expiry_date","desktop_computing","last_job_date","available_upto","scheduler_priority");
foreach my $mold (@{$ref_resource_list}){
    foreach my $r (@{$mold->[0]}){
        my $i = 0;
        while (($i <= $#{$r->{resources}})){
            if (grep(/^$r->{resources}->[$i]->{resource}$/i, @bad_resources)){
                die("[ADMISSION RULE] '$r->{resources}->[$i]->{resource}' resource is not allowed\n");
            }
            $i++;
        }
    }
}
