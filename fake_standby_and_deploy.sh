#!/bin/bash
#
# automates g5k customization of oardocker given by the OAR team
# (see http://oar.imag.fr/wiki:oardocker_setup_for_grid_5000)
#

set -x

if [[ "`hostname`" == "frontend" ]]
then
######################
#      FRONTEND      #
######################

    # this needs the oar repo to be linked with "oardocker start -v $PWD:/mnt"
    cd /mnt/ ; make node-build node-install node-setup
    
    # run daemons
    apt-get install -y at
    /etc/init.d/atd start
    cp /usr/local/share/oar/oar-node/init.d/oar-node /etc/init.d
    cp /usr/local/share/oar/oar-node/default/oar-node /etc/default/
    /etc/init.d/oar-node start
    apt-get install -y at
    /etc/init.d/atd start

    # re-write epilogue
    cat > /etc/oar/epilogue <<EPILOGUE
#!/bin/bash
# Usage:
# Script is run under uid of oar who is sudo
# argv[1] is the jobid
# argv[2] is the user's name
# argv[3] is the file which contains the list of nodes used
# argv[4] is the job walltime in seconds

exec 1> /tmp/epilogue.\$1.log
exec 2>&1
set -x

OARNODESETTINGCMD=/usr/local/sbin/oarnodesetting
# simulate the boot of the nodes with an at command -> put the node Alive asynchronously. 
for n in \$(uniq \$3); do 
    nodes="\$nodes -h \$n"
    echo "bash -xc '\$OARNODESETTINGCMD -h \$n -s Alive -p available_upto=2147483646' > /tmp/oarnodesetting.\$1.\$n 2>&1" | at now +3 minutes;
done
#\$OARNODESETTINGCMD \$nodes -s Absent -p available_upto=0
# set the nodes down, using the command used on g5k:
\$OARNODESETTINGCMD -n -s Absent -p available_upto=0 --sql "resource_id IN (select assigned_resources.resource_id from jobs,assigned_resources,resources where assigned_resource_index = 'CURRENT' AND jobs.state = 'Running' AND jobs.job_id = $1 and moldable_job_id = jobs.assigned_moldable_job AND (resources.resource_id = assigned_resources.resource_id AND resources.type='default'))"

exit 0
EPILOGUE

    # patch drawgantt config
    cat > /tmp/drawgantt_patch <<DRAWGANTT_PATCH
87c87
< \$CONF['timezone'] = "UTC";
---
> \$CONF['timezone'] = "Europe/Paris";
95c95
<   'network_address' => '/^([^-]+)-(\\d+)\\..*$/',
---
>   'network_address' => '/^([^-]+)(\\d+)$/',
98c98
<   'deploy', 'cpuset', 'besteffort', 'network_address', 'type', 'drain');
---
>   'deploy', 'cpuset', 'besteffort', 'network_address', 'type', 'drain', 'state', 'available_upto');
DRAWGANTT_PATCH
    patch /etc/oar/drawgantt-config.inc.php < /tmp/drawgantt_patch

    # patch OAR config
    cat > /tmp/oar_patch << OAR_PATCH
39c39
< OARSUB_DEFAULT_RESOURCES="/resource_id=1"
---
> OARSUB_DEFAULT_RESOURCES="/nodes=1"
42c42
< OARSUB_NODES_RESOURCES="network_address"
---
> OARSUB_NODES_RESOURCES="nodes"
OAR_PATCH
    patch /etc/oar/oar.conf < /tmp/oar_patch

## end of frontend's side
elif [[ "`hostname`" == "server" ]]
then
######################
#       SERVER       #
######################

    # run daemons
    apt-get install -y at
    /etc/init.d/atd start

    # re-write wake_up_nodes.sh
    cat > /etc/oar/wake_up_nodes.sh << WAKE_UP_NODES
#!/bin/bash
# Sample script for energy saving (wake-up)
 
DATE=\$(date +%F_%T)
OARNODESETTINGCMD=/usr/local/sbin/oarnodesetting

# stdout/err goes to oar.log
set -x
# simulate the boot time with an at command: will set the node Alive asynchronously
while read n; do
    for nn in \$n; do
        echo "bash -xc 'echo \$DATE; \$OARNODESETTINGCMD -h \$nn -s Alive -p available_upto=2147483646' > /tmp/wake-up.\$DATE.\$n 2>&1" | at now +1 minute;
    done
done
WAKE_UP_NODES

    # re-write shut_down_nodes.sh
    cat > /etc/oar/shut_down_nodes.sh << SHUT_DOWN_NODES
#!/bin/bash
# Sample script for energy saving (shut-down)
 
# stdout/err goes to oar.log 
set -x
# Nothing really needed here
while read n; do
    for nn in \$n; do
        echo shutting down \$n
    done
done
SHUT_DOWN_NODES

    # patch OAR config
    cat > /tmp/oar_patch << OAR_PATCH
66c66
< DEPLOY_HOSTNAME="127.0.0.1"
---
> DEPLOY_HOSTNAME="frontend"
69c69
< COSYSTEM_HOSTNAME="127.0.0.1"
---
> COSYSTEM_HOSTNAME="frontend"
196c196
< #PROLOGUE_EPILOGUE_TIMEOUT="60"
---
> PROLOGUE_EPILOGUE_TIMEOUT="180"
200,201c200,201
< #PROLOGUE_EXEC_FILE="/path/to/prog"
< #EPILOGUE_EXEC_FILE="/path/to/prog"
---
> PROLOGUE_EXEC_FILE="/etc/oar/prologue"
> EPILOGUE_EXEC_FILE="/etc/oar/epilogue"
384c384
< #SCHEDULER_NODE_MANAGER_IDLE_TIME="600"
---
> SCHEDULER_NODE_MANAGER_IDLE_TIME="300"
388c388
< #SCHEDULER_NODE_MANAGER_SLEEP_TIME="600"
---
> SCHEDULER_NODE_MANAGER_SLEEP_TIME="600"
393c393
< #SCHEDULER_NODE_MANAGER_WAKEUP_TIME="600"
---
> SCHEDULER_NODE_MANAGER_WAKEUP_TIME="600"
425c425
< ENERGY_SAVING_INTERNAL="no"
---
> ENERGY_SAVING_INTERNAL="yes"
432c432
< #ENERGY_SAVING_NODE_MANAGER_WAKE_UP_CMD="/etc/oar/wake_up_nodes.sh"
---
> ENERGY_SAVING_NODE_MANAGER_WAKE_UP_CMD="/etc/oar/wake_up_nodes.sh"
437c437
< #ENERGY_SAVING_NODE_MANAGER_SLEEP_CMD="/etc/oar/shut_down_nodes.sh"
---
> ENERGY_SAVING_NODE_MANAGER_SLEEP_CMD="/etc/oar/shut_down_nodes.sh"
444c444
< #ENERGY_SAVING_NODE_MANAGER_WAKEUP_TIMEOUT="900"
---
> ENERGY_SAVING_NODE_MANAGER_WAKEUP_TIMEOUT="1:200 81:400 161:600 241:800"
467c467
< #ENERGY_SAVING_WINDOW_FORKER_BYPASS="no"
---
> ENERGY_SAVING_WINDOW_FORKER_BYPASS="yes"
481c481
< #ENERGY_MAX_CYCLES_UNTIL_REFRESH=5000
---
> ENERGY_MAX_CYCLES_UNTIL_REFRESH="500"
OAR_PATCH

## end of server's side
else
    echo "Error: please run this on oardocker's frontend or server!"
    exit 1
fi
