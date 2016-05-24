# Title: Storage5k rule
# Description: Automatically change the type to storage when needed
        my $not_storage = 0;
        my $storage = 0;
        foreach my $mold (@{$ref_resource_list}){
        foreach my $r (@{$mold->[0]}){
        my $resource = $r->{resources}[0]->{resource};
        my $value = $r->{resources}[0]->{value};
        if ($resource ne 'chunks')
        {
          $not_storage = 1;
        }
        if ($resource =~ /chunks/) {
            if ($value <= 0){
              die("[ADMISSION RULE] Error: Chunks number must be great than 0\n");
            }
            $r->{property} = "type = \'storage\'";
            print("[ADMISSION RULE] Modify resource description as storage\n");
            $storage = 1;
        }
    }
    if ($not_storage && $storage)
        {
           die("[ADMISSION RULE] Storage resource cannot be reserved with another resource type\n");
        }
}
