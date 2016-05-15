# RaspiFarm Cluster Management CLI

## Installation

Simply clone it onto your RaspiFarm Cluster master node:

```shell
git clone git@github.com:lxxxvi/raspifarm-cluster-mgmt.git
```

---

## Configuration

### Cluster command
For an easy access to the cluster manager, `export` the cluster shell wrapper into your $PATH variable:

```shell
export PATH=$PATH:/home/farmer/cluster/bin
```

It's recommended that you put this into your `~/.profile` or `~/.bash_profile` file.

### Nodes

Configure your nodes in `etc/nodes.yml`

## General synopsis of cluster command

```shell

  cluster <service> <targets> [<arguments>]

  <service>       See available services below
  <targets>       Either 'all' or specific nodes, delimited by ','  e.g.   12,14,16
  [<arguments>]   Depends on the service

```

---

## Services

### Status

##### Description

Checks if the configured nodes/hosts can be pinged and if login with `farmer` user is possible.

##### Usage

`cluster status <targets>`

This service does not take arguments.

##### Example

```shell
farmer@raspifarm-master:~ $ cluster status all
192.168.17.15 is alive, login possible
192.168.17.16 is alive, login possible
192.168.17.17 is alive, login possible
192.168.17.18 is alive, login possible
```

### Installer

##### Description

Installs package(s) on given (`<targets>`) hosts using `apt-get -y install`.

##### Usage

`cluster install <targets> "<package(s)>"`

Make sure you wrap the package(s) in double quotes. Separate packages with spaces (as you would do it for the apt-get install command).
Note, that the installer will always execute `sudo apt-get update` before installing the provided package(s).

##### Example

```shell
farmer@raspifarm-master:~ $ cluster install 12,13,16 "package-one package-two"
# lots of output goes here
```


### Runner

##### Description

Runs a command on given (`<targets>`) hosts.

##### Usage

`cluster run <targets> "<command>"`

Make sure you wrap the command in double quotes.

##### Example

```shell
farmer@raspifarm-master:~ $ cluster run all "hostname"
raspifarm-slave-15
raspifarm-slave-16
raspifarm-slave-17
raspifarm-slave-18
```

### Statistics

##### Description

Displays statistics (CPU and memory usage) of given hosts (`<targets>`).

##### Usage

`cluster stats <targets>`

This service does not take arguments.

##### Example

```shell
farmer@raspifarm-master:~ $ cluster stats all
{ '192.168.17.15':  { 'cpu': 16.7, 'memory': 13.94 }  }
{ '192.168.17.16':  { 'cpu': 16.6, 'memory': 13.67 }  }
{ '192.168.17.17':  { 'cpu': 16.6, 'memory': 21.07 }  }
{ '192.168.17.18':  { 'cpu': 12.5, 'memory': 13.65 }  }
```
