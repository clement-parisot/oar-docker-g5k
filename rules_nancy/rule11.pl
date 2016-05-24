# Title: Set default walltime to 1:00:00

my $default_wall = OAR::IO::sql_to_duration("1:00:00");
foreach my $mold (@{$ref_resource_list}){
    if (!defined($mold->[1])){
        print("[ADMISSION RULE] Set default walltime to $default_wall.\n");
        $mold->[1] = $default_wall;
    }
}
