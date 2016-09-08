# oar-docker-g5k
Custom script to configure oar-docker with g5k configuration

# Installation
* Clone OAR repository (https://github.com/oar-team/oar) in your workspace
  * and checkout to version 2.5.7 (current version on Grid'5000)
```
user@laptop:/path/to/your/workspace/oar$ git checkout 2.5.7
```
* Clone this repository in your worspace
* See **oar-docker** (https://github.com/oar-team/oar-docker) and follow instructions to install the tool
  * at this step, make sure to init and install oardocker directly in OAR sources' directory:
```
user@laptop:/path/to/your/workspace/oar$ oardocker init
user@laptop:/path/to/your/workspace/oar$ oardocker install .
```
* Start oar-docker and share some directories:
  * OAR source code in /mnt (needed)
  * - this repository in docker's ~/oar-docker-g5k/ directory for exemple.
```
user@laptop:/path/to/your/worspace/oar$ oardocker start -v /path/to/your/workspace/oar-docker-g5k:/home/docker/oar-docker-g5k -v $PWD:/mnt -n 3
```
* Connect on frontend
```
user@laptop:/path/to/your/workspace/oar$ oardocker connect
```
* Run the setup scripts
```
docker@frontend ~
$ cd oar-docker-g5k/ ; sudo ./fake_standby_and_deploy.sh ; ssh server
docker@server ~
$ cd oar-docker-g5k/ ; sudo ./setup.sh ; sudo ./fake_standby_and_deploy.sh ;
```
* Then, go back to the frontend and try to reserve a node
```
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
