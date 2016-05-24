# Title : resource is not allowed with a deploy or allow_classic_ssh type

my @bad_resources = ("core","cpu","resource_id",);
if (grep(/^(deploy|allow_classic_ssh|mic)$/, @{$type_list})){
    foreach my $mold (@{$ref_resource_list}){
        foreach my $r (@{$mold->[0]}){
            my $i = 0;
            while (($i <= $#{$r->{resources}})){
                if (grep(/^$r->{resources}->[$i]->{resource}$/i, @bad_resources)){
                    die("[ADMISSION RULE] '$r->{resources}->[$i]->{resource}' resource is not allowed with a deploy or allow_classic_ssh or mic type job\n");
                }
                $i++;
            }
        }
    }
}
