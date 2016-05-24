# Title: Limit number of reservation per user (interactive)
# Description: If a use submit more than 2 reservation in interactive job, limit them
if ($reservationField eq "toSchedule") {
  my $unlimited=0;
  if (open(FILE, "< $ENV{HOME}/unlimited_reservation.users")) {
    while (<FILE>){
      if (m/^\s*$user\s*$/m){
        $unlimited=1;
      }
    }
    close(FILE);
  }
  my $start_time_thres = time() + 3600;
  if ($startTimeReservation < $start_time_thres) {
    printf("[ADMISSION RULE] Reservation starts in less than one hour, not limited\n");
  } elsif ($unlimited > 0) {
    print("[ADMISSION RULE] $user is granted the privilege to do unlimited reservations\n");
  } else {
    foreach my $mold (@{$ref_resource_list}){
      foreach my $r (@{$mold->[0]}){
        my $resource = $r->{resources}[0]->{resource};
        if ($resource =~ /chunks/) {
          printf("[ADMISSION RULE] Type storage, so unlimited reservations\n");
        } else {
          my $max_nb_resa = 2;
          my $nb_resa = $dbh->do("SELECT job_id
                                  FROM jobs
                                  WHERE
                                  job_user = \'$user\' AND
                                  (reservation = \'toSchedule\' OR
                                  reservation = \'Scheduled\') AND
                                  (state = \'Waiting\' OR state = \'Hold\') AND
                                  (start_time > $start_time_thres)
                                  ");
          if ($nb_resa >= $max_nb_resa){
            die("[ADMISSION RULE] Error : you cannot have more than $max_nb_resa waiting reservations.\n");
          } # if resa
        } # if non chunk
      } # foreach r (chunk)
    } # foreach mold
  } # if unlimited
} #if reservatuib to Schedule
