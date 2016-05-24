# Title : Limit the number of waiting jobs per user to max_nb_jobs
# Description : If user is not listed in unlimited users file, it checks if the current number of waiting jobs is under $max_nb_jobs. $max_nb_jobs is defined in ~oar/max_jobs or is 50 by default. The computation includes jobs put on hold etc.
my $unlimited=0;
if (open(FILE, "< $ENV{HOME}/unlimited_reservation.users")) {
    while (<FILE>) {
        if (m/^\s*$user\s*$/m) {
            $unlimited=1;
        }
    }
    close(FILE);
}
if ($unlimited == 0) {
    my $max_nb_jobs = 50;
    if (open(FILE, "< $ENV{HOME}/max_jobs")) {
        while (<FILE>) {
            chomp;
            $max_nb_jobs=$_;
        }
        close(FILE);
    }

    my $nb_jobs = $dbh->selectrow_array(
        qq{ SELECT COUNT(job_id) 
            FROM jobs 
            WHERE job_user = ? 
            AND (state = \'Waiting\' 
            OR state = \'Hold\' 
            OR state = \'toLaunch\' 
            OR state = \'toAckReservation\' 
            OR state = \'Launching\' 
            OR state = \'Suspended\' 
            OR state = \'Resuming\' 
            OR state = \'Finishing\') },
        undef,
        $user);

    if (($nb_jobs + $array_job_nb) > $max_nb_jobs) {
        die("[ADMISSION RULE] Error: you cannot have more than $max_nb_jobs jobs waiting in the queue at the same time.\n");
    }
}
