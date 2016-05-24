# Title: Automatically change the type to subnet when needed

foreach my $mold (@{$ref_resource_list}){
    foreach my $r (@{$mold->[0]}){
        my $resource = $r->{resources}[0]->{resource};
        if ($resource =~ /slash/) {
            $r->{property} = "type = \'subnet\'";
            print("[ADMISSION RULE] Modify resource description as subnet\n");
        }
    }
}
