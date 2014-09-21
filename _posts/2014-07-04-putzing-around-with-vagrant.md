---
layout: post
category: blog
"current-tab": blog
author: Erik Schwartz
published: false
permalink: ""
---

Following along to [getting started with Vagrant](https://docs.vagrantup.com/v2/getting-started/index.html).

### Create a VM

upgrade virtualbox to `VirtualBox-4.3.12-93733-OSX`

install standard Ubuntu 12.04 LTS 32-bit box.

```
$ vagrant init hashicorp/precise32
...

$ vagrant up
Bringing machine 'default' up with 'virtualbox' provider...
==> default: Box 'hashicorp/precise32' could not be found. Attempting to find and install...
    default: Box Provider: virtualbox
    default: Box Version: >= 0
==> default: Loading metadata for box 'hashicorp/precise32'
    default: URL: https://vagrantcloud.com/hashicorp/precise32
==> default: Adding box 'hashicorp/precise32' (v1.0.0) for provider: virtualbox
...
```

Add a box locally to refer to in the Vagrantfile

```
$ vagrant box add hashicorp/precise32
```

Use the downloaded box in the Vagrantfile

```
Vagrant.configure("2") do |config|
  config.vm.box = "hashicorp/precise32"
end
```


wipe all traces of VM

```
$ vagrant destroy
```

### Sharing directories

* Vagrant shares a directory at `/vagrant` with the directory on the host containing your Vagrantfile
* With synced folders, you can continue to use your own editor on your host machine and have the files sync into the guest machine.


### Provisioning


add bootsrap.sh 

```
#!/usr/bin/env bash

apt-get update
apt-get install -y apache2
rm -rf /var/www
ln -fs /vagrant /var/www
```

Add to Vagrantfile

```
Vagrant.configure("2") do |config|
  config.vm.box = "hashicorp/precise32"
  config.vm.provision :shell, path: "bootstrap.sh"
end
```

```
$ vagrant ssh
...
vagrant@precise32:~$ wget -qO- 127.0.0.1
... html listing of /vagrant since we linked to DocumentRoot
```


### Port forwarding

Add to Vagrantfile 

```
  config.vm.network :forwarded_port, host: 4567, guest: 80
```

Run a `vagrant reload` or `vagrant up` (depending on if the machine is already running) 


### Teardown

```
vagrant halt|suspend|destroy
```



```
```