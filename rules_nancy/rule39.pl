# Title: Limit checkpoint duration to 1 minute with besteffort jobs 
if (($queue_name eq "besteffort" or grep(/^besteffort$/, @{$type_list})) and $checkpoint > 60) {
  die("[ADMISSION RULE] Error: you can't set a checkpoint longer than 1 minute in a besteffort job.");
}
