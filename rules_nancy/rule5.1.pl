# Title: Automatically add the production constraint on the resources

if (grep(/^production$/, @{$type_list}) and not $queue_name eq "besteffort" and not $queue_name eq "production" and not $queue_name eq "challenge"){
    $queue_name = "production";
    print("[ADMISSION RULE] Automatically redirect in the production queue\n");
}
if ($queue_name eq "production" and not grep(/^production$/, @{$type_list})) {
    push(@{$type_list},"production");
    print("[ADMISSION RULE] Automatically add the production type\n");
}
if (grep(/^production$/, @{$type_list})){
    if ($jobproperties ne ""){
        $jobproperties = "($jobproperties) AND production = \'YES\'";
    }else{
        $jobproperties = "production = \'YES\'";
    }
    print("[ADMISSION RULE] Automatically add the production constraint on the resources\n");
}

