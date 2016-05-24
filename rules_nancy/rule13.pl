# Title: maintenance = 'NO'

if ( ($queue_name ne "admin") and ($queue_name ne "testing") ) {
  if ($jobproperties ne "") {
    $jobproperties = "($jobproperties) AND maintenance = 'NO'";
  } else {
    $jobproperties = "maintenance = 'NO'";
  }
}
