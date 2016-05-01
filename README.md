# README

For an easy access to the cluster manager, `export` the cluster shell wrapper into your $PATH variable:


```shell
export PATH=$PATH:/home/farmer/cluster/bin
```

It's recommended that you put this into your `~/.profile` or `~/.bash_profile` file.


## Pinger

Use `cluster ping` to check if configured slave-nodes are up:

```shell

farmer@raspifarm-master:~/cluster $ cluster ping
192.168.17.11 is NOT alive
192.168.17.12 is NOT alive
192.168.17.13 is NOT alive
192.168.17.14 is NOT alive
192.168.17.15 is alive
192.168.17.16 is alive
192.168.17.17 is alive
192.168.17.18 is alive

```

