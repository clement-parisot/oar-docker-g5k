
# Production clusters ressources selection rule

if ($queue_name eq "production"){

}elsif ($queue_name eq "challenge" or $queue_name eq "admin" or $queue_name eq "besteffort" or $queue_name eq "testing"){
 print("[Admission rule] You can use production and non-production ressources\n");
}else{
 if ($jobproperties ne ""){
  $jobproperties = "($jobproperties) AND production = 'NO'";
 }else{
  $jobproperties = "production = 'NO'";
 }
}
