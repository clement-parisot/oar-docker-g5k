
# Production job duration 
# my $max_walltime = OAR::IO::sql_to_duration("168:00:00");
# print("[ADMISSION RULE] Max walltime: $max_walltime\n");
if ($queue_name eq "production"){
  print("[ADMISSION RULE] Limit walltime\n");
  foreach my $mold (@{$ref_resource_list}){
    if (defined($mold->[1])){
      # if($max_walltime < $mold->[1]){
      #  die("[ADMISSION RULE] Walltime to big for a PRODUCTION job. Max walltime :$max_walltime.\n");
      # }
      if ($jobproperties ne ""){
        $jobproperties = "($jobproperties) AND (max_walltime >= $mold->[1] OR max_walltime <= 0)";
      }else{
        $jobproperties = "(max_walltime >= $mold->[1] OR max_walltime <= 0)";
      }
    }
  }
}
