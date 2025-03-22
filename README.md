# Kubernetes Cluster Bare Metal Setup Ansible Playbooks

This repo contains playbooks which can be used to provision aa fully fledged kubernetes cluster
on bare-metal or vms.
> The playbooks are organised in such a way that it can be used in Sempahore-ui

# IMPORTANT
> For metrics collection manually update `metricsBindAddress` of `kube-proxy` config map to `metricsBindAddress: "0.0.0.0:10249"` 
> so that prometheus can collect metrics
 

### Steps

1. Create a VM / use one server to install ansible and semaphore. You may use
   the [install_ansible.sh](scripts%2Finstall_ansible.sh) script to install it.
   > Note that the script assumes you have a MySQL or MariDB instance already available.
2. Setup Semaphore Keystore with an SSH key based login.
   If you don't have ssh key based auth, then use the [server_init.yml](misc%2Fserver_init.yml) playbook to setup it up.
3. Create your inventory file similar to the provided sample.
   > control_plane: This is the master node / node from which cluster will be initialized
   >  workers: These are the worker nodes which will join the cluster
   >  new_master: These are the extra control_plane nodes that'll join the cluster
   >  jump_server: This is the server in which you can use to mange your kubernetes cluster. Cli tools such as helm,
   linkerd etc will be installed here.
4. Create Task templates in the semaphore for each of the playbooks.

#### Playbooks

1. [01-prerequisites.yml](kubernetes%2F01-prerequisites.yml) **[New Cluster, New Node]**: This playbook will prepare the
   environment for kubernetes install.
2. [02-networking.yml](kubernetes%2F02-networking.yml) **[New Cluster, New Node]**: Playbook to setup all the networking
   related rules in the servers for kubernetes.
3. [03-binaries.yml](kubernetes%2F03-binaries.yml) **[New Cluster, New Node]**: Playbook will install all the binaries
   and tools required for kubernetes.
4. [04-control-plane.yml](kubernetes%2F04-control-plane.yml) **[New Cluster]**: Playbook will bootstrap a new kubernetes
   cluster from the control_plane node. This needs to be done only once for a cluster.
5. [05-workers.yml](kubernetes%2F05-workers.yml) **[New Node]**: This playbook will join new worker nodes to the
   existing kubernetes cluster.
6. [06-new-master.yml](kubernetes%2F06-new-master.yml) **[New Node]**: This playbook will add a new master node to the
   existing kubernetes control plane.
7. [07-jump-server.yml](kubernetes%2F07-jump-server.yml) **[One Time]**: Script to properly setup the jump server to
   access kubernetes.
8. [destroy-cluster.yml](kubernetes%2Fdestroy-cluster.yml) **[Teardown]**: Playbook will destroy the existing kubernetes
   cluster. It'll only destroy the cluster. All the tools and pre-requisites installed won't be remobed.
9. [remove-kubernetes.yml](kubernetes%2Fremove-kubernetes.yml) **[Teardown]**: Completely remove all the tools and
   packages installed by the playbooks in this repo.

### Appendix
- https://blog.codefarm.me/2019/01/28/bootstrapping-kubernetes-clusters-with-kubeadm/