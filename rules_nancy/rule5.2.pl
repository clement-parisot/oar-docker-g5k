# Title: A job cannot be of both types besteffort and production
if ((grep(/^besteffort$/, @{$type_list})) and (grep(/^production$/, @{$type_list}))){
    die("[ADMISSION RULE] Error: a job cannot be of both types besteffort and production\n");
}
