# Title : OpenAccess group restrictions
# Description : restrict OpenAccess user group  

my $GROUP="open-access";
system("id -Gn $user | grep -w $GROUP >/dev/null");
if ($? == 0){
  my $max_batch_hour = OAR::IO::sql_to_duration("24:00:00");
  my $current_date = OAR::IO::get_date($dbh);
  if (($startTimeReservation - $current_date) > $max_batch_hour){
    die ("[ADMISSION RULE] OpenAccess: Cannot book more than 24 hours in advance\n");
  }
}
