# Title: Modify resource description with type constraints

foreach my $mold (@{$ref_resource_list}){
    foreach my $r (@{$mold->[0]}){
        my $prop = $r->{property};
        if (($prop !~ /[\s\(]type[\s=]/) and ($prop !~ /^type[\s=]/)){
            if (!defined($prop)){
                $r->{property} = "type = \'default\'";
            }else{
                $r->{property} = "($r->{property}) AND type = \'default\'";
            }
        }
    }
}
print("[ADMISSION RULE] Modify resource description with type constraints\n");
