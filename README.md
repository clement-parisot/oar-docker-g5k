# oar-docker-g5k
Custom script to configure oar-docker with g5k configuration

# Installation
* See **oar-docker** (https://github.com/oar-team/oar-docker) and follow instruction to install the tool
* Clone the repository on the oar-docker workspace
* Run oar-docker and share this repository in docker /mnt directory for exemple
```
user@laptop: oardocker start -v /path/to/your/workspace/oar-docker-g5k/:/mnt/
```
* Connect on server
```
user@laptop: oardocker connect server
```
* Run the setup script
```
docker@server ~
$ cd /mnt
docker@server /mnt (master|✔)
$ sudo su
root@server /mnt (master|✔)
$ ./setup_oar.sh 
```
* When script ends, connect on frontend and try to reserve a node
```
user@laptop: oardocker connect server
docker@frontend ~
$ oarsub -I 
[ADMISSION RULE] Set default walltime to 3600.
[ADMISSION RULE] Modify resource description with type constraints
OAR_JOB_ID=1
Interactive mode : waiting...
Starting...

Connect to OAR job 1 via the node node1
Warning: Permanently added '[node1]:6667,[172.17.0.101]:6667' (RSA) to the list of known hosts.
docker@node1 ~
$ 
```

# Edit the rules
All the administration rules are under the *rule* directory. Each file is a single rule. Priority of the rule depends on the rule name.
