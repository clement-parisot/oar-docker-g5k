# Title: Admin queue

my $admin_group = "support";
if ($queue_name eq "admin") {
    my $members; 
    (undef,undef,undef, $members) = getgrnam($admin_group);
    my %h = map { $_ => 1 } split(/ /,$members);
    if ( $h{$user} ne 1 ) {
        die("[ADMISSION RULE] Only member of the group ".$admin_group." can submit jobs in the admin queue\n");
    }
}
