#!/bin/bash
set -e
set -x
cluster_name="node"
cluster_size=3

# Add ressources to OAR DB
cpu_nb=2
core_nb=2
thread_nb=2
oar_resources_add -H $cluster_size -C $cpu_nb -c $core_nb -t $thread_nb --host-prefix $cluster_name | bash -

# Add custom g5k properties
# Char properties
for p in ip_virtual cpuarch cputype cpufreq virtual disktype ib10g ib10gmodel ib20g ib40g myri10g myri10gmodel nodemodel rconsole grub cluster maintenance production;
do
    oarproperty -a $p -c || echo "Error for $p";
done;
# Integer properties
for p in cpucore ethnb memnode memcpu memcore max_walltime;
do
    oarproperty -a $p || echo "Error for $p";
done;

# Set some properties if needed
# default values
declare -A default_properties;
default_properties=(
["ip_virtual"]='YES'
["cpuarch"]='x86_64'
["cputype"]='Intel Xeon E5-2630 v3'
["virtual"]='ivt'
["disktype"]='SCSI'
["ib10g"]='NO'
["ib20g"]='NO'
["ib40g"]='NO'
["myri10g"]='NO'
["nodemodel"]='Dell PowerEdge R630'
["rconsole"]='YES'
["cluster"]=$cluster_name
["cpufreq"]=3.2
["cpucore"]=$(($cpu_nb * $core_nb))
["ethnb"]=1
["maintenance"]='NO'
["memnode"]=129024
["memcpu"]=64512
["memcore"]=8064
["max_walltime"]=0
["production"]='NO')

for i in $(seq 1 $cluster_size);
do
    for p in "${!default_properties[@]}";
    do
        oarnodesetting -h ${cluster_name}$i -p $p=${default_properties["$p"]};
    done
done

# Import admission rules
# Clean existing admission rules
rules_nb=$(oaradmissionrules -S | grep -c RULE) # Ugly trick to get number of rules
for n in $(seq 1 $rules_nb);
do
    oaradmissionrules -d $n
done;
# Import rules
rules_path="/mnt/rules_nancy"
for r in $(ls -1 ${rules_path}/* | sort -V);
do
    oaradmissionrules -n -r $r
done;
# Set priority and activate rules
#TODO Fix this part, priority is set to rule number...
for n in $(oaradmissionrules -S | grep RULE | sed "s/.*RULE #\(.*\)/\1/");
do
    oaradmissionrules -m $n -P $n -Y;
done;

# Create queues
oarnotify --add-queue admin,10,oar_sched_gantt_with_timesharing
oarnotify --add-queue production,3,oar_sched_gantt_with_timesharing_and_fairsharing
oarnotify --add-queue challenge,3,oar_sched_gantt_with_timesharing_and_fairsharing
oarnotify --add-queue testing,5,oar_sched_gantt_with_timesharing
