# Title : Limit the maximum walltime for ALL jobs, not only for non-reservation interactive jobs PRODUCTION MODE
# Description : If user is not listed in unlimited users file, it checks if the specified walltime isnt larger than max_walltime_hours, which is defined in oar_max_walltime or is 168 by default
my $unlimited=0;
if (open(FILE, "< $ENV{HOME}/unlimited_reservation.users")) {
    while (<FILE>) {
        if (m/^s*$user\s*$/m) {
            $unlimited=1;
        }
    }
    close(FILE);
}
if (($queue_name eq "production") or ($queue_name eq "challenge")){
  $unlimited=1;
}
if ($unlimited == 0) {
    my $max_walltime_hours = 168;
    if (open(FILE, "< $ENV{HOME}/max_walltime")) {
        while (<FILE>) {
            chomp;
            $max_walltime_hours = $_;
        }
        close(FILE);
    }

    foreach my $mold (@{$ref_resource_list}){
      foreach my $r (@{$mold->[0]}){
        my $resource = $r->{resources}[0]->{resource};
        if ($resource =~ /chunks/) {
          $max_walltime_hours = 1680;
        }
      }   
    }

    my $max_walltime = OAR::IO::sql_to_duration("$max_walltime_hours:00:00");
    foreach my $mold (@{$ref_resource_list}){
        if ((defined($mold->[1])) and ($max_walltime < $mold->[1])){
            die("[ADMISSION RULE] Error: Walltime too big for this job, it is limited to $max_walltime_hours hours
");
        }
    }
}
