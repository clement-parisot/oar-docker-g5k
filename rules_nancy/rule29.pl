
# Title : a job cannot both be in queue production and be a reservation

if (($queue_name eq "production") and ($reservationField ne "None")){
    die("[ADMISSION RULE] Error: a job cannot both be in queue production and be a reservation.
");
}
