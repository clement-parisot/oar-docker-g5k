# Title: Warn users who make reservation in close future that they can lose nodes
if ($reservationField eq "toSchedule") {
  my $besteffort_kill_duration = OAR::Conf::get_conf_with_default_param("SCHEDULER_BESTEFFORT_KILL_DURATION_BEFORE_RESERVATION",0);
  my $current_date = OAR::IO::get_date($dbh);

  if ($startTimeReservation - $current_date < $besteffort_kill_duration) {
    print "[ADMISSION RULE] Warning: your reservation starts very soon, you might get less nodes than what you required!\n";
  }
}
