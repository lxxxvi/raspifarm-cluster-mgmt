# README

For an easy access to the cluster manager, `export` the cluster shell wrapper into your $PATH variable:


```shell
export PATH=$PATH:/home/farmer/cluster/bin
```

It's recommended that you put this into your `~/.profile` or `~/.bash_profile` file.

### Configuration

Configure your nodes in `etc/nodes.yml`

## Status

```shell
farmer@raspifarm-master:~ $ cluster status
Status of configured nodes (see /home/farmer/cluster/etc/nodes.yml)
192.168.17.15 is alive, login possible
192.168.17.16 is alive, login possible
192.168.17.17 is alive, login possible
192.168.17.18 is alive, login possible
```


## Runner

```shell
farmer@raspifarm-master:~ $ cluster run all 'hostname'
raspifarm-slave-15
raspifarm-slave-16
raspifarm-slave-17
raspifarm-slave-18
```
