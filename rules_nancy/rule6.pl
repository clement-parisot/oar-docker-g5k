# Title : a job cannot both be of type besteffort and be a reservation

if ((grep(/^besteffort$/, @{$type_list})) and ($reservationField ne "None")){
    die("[ADMISSION RULE] Error: a job cannot both be of type besteffort and be a reservation.\n");
}
