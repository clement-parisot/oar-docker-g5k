# Title: deploy = YES

if (grep(/^deploy$/, @{$type_list})){
    if ($jobproperties ne ""){
        $jobproperties = "($jobproperties) AND deploy = \'YES\'";
    }else{
        $jobproperties = "deploy = \'YES\'";
    }
}
