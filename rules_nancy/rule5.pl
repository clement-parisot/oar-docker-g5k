# Title: Automatically add the besteffort constraint on the resources PRODUCTION

if (grep(/^besteffort$/, @{$type_list}) and not $queue_name eq "besteffort" and not $queue_name eq "production" and not $queue_name eq "challenge"){
    $queue_name = "besteffort";
    print("[ADMISSION RULE] Automatically redirect in the besteffort queue\n");
}
if ($queue_name eq "besteffort" and not grep(/^besteffort$/, @{$type_list})) {
    push(@{$type_list},"besteffort");
    print("[ADMISSION RULE] Automatically add the besteffort type\n");
}
if (grep(/^besteffort$/, @{$type_list})){
    if ($jobproperties ne ""){
        $jobproperties = "($jobproperties) AND besteffort = \'YES\'";
    }else{
        $jobproperties = "besteffort = \'YES\'";
    }
    print("[ADMISSION RULE] Automatically add the besteffort constraint on the resources\n");
}
