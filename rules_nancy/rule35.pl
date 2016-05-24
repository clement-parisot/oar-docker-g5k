# Title : Only authorized users can submit in the challenge file
if ($queue_name eq "challenge"){
  open(FILE, "$ENV{HOME}/challenge.users") || die("[ADMISSION RULE] Challenge user list is empty");
  my $authorized = 0;
  while (<FILE>){
    if (m/^\s*$user\s*$/m){
      $authorized = 1;
    }
  }
  close(FILE);
  if($authorized eq 1){
    print("[ADMISSION RULE] Change assigned queue into challenge\n");
    $queue_name = "challenge";
  } 
  else{
    die("[ADMISSION RULE] $user is not authorized to submit in challenge queue\n");
  }
}
