#!/bin/bash
set -e
set -x
cluster_name="node"
cluster_size=3

# Add ressources to OAR DB
cpu_nb=2
core_nb=4
thread_nd=1
oar_resources_add -H $cluster_size -C $cpu_nb -c $core_nb -t $thread_nb --host-prefix $cluster_name | bash -

# Add custom g5k properties
# Char properties
for p in ip_virtual cpuarch cputype cpufreq virtual disktype ib10g ib10gmodel ib20g ib40g myri10g myri10gmodel nodemodel rconsole grub cluster;
do
    oarproperty -a $p -c;
done;
# Integer properties
for p in cpucore ethnb memnode memcpu memcore;
do
    oarproperty -a $p;
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
["memnode"]=129024
["memcpu"]=64512
["memcore"]=8064)

for i in $(seq 1 $cluster_size);
do
    for p in "${!default_properties[@]}";
    do
        oarnodesetting -h ${cluster_name}-$i -p $p=${default_properties["$p"]};
    done
done

# Import admission rules
# TODO
