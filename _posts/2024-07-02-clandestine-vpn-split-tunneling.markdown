---
author:     Oliver Kovacs
categories: blog
date:       2024-07-05 00:00:00 +0200
icon:       "./assets/img/technologies/openvpn.svg"
layout:     post
text:       networking, linux<br>2024 Jul 5
title:      "Clandestine VPN split tunneling"
---

## Overview

This post details how to use a virtual private network (VPN) running on a separate (virtual) machine.
This allows us to "pre-filter" the network traffic, effectively split tunneling using a full-tunnel VPN connection.

Some possible use cases include:
- You are required to use a full tunnel VPN connection but you don't want to send all of your traffic through the VPN for privacy or performance reasons.
- You want to connect a machine to multiple VPNs simultaneously.
- You want to connect multiple machines to a VPN simultaneously.

## Setup

The simplest setup is to use a virtual machine (VM) to connect to the VPN.
However two different physical computers could also be used.

This post will assume you are running a KVM VM on a Linux host but it should be trivial to adapt it to other situations.

### Create the VM

1. Choose a Linux distribution. You can use a distro optimized for networking like [OpenWRT](https://openwrt.org/) or a general purpose one like [Debian](https://www.debian.org/) or [Arch](https://archlinux.org/).
1. Create a VM with for example `virt-manager`. If you are paranoid you can enable full disk encryption.
1. Install the VPN client you want to use inside the VM.

### Network interfaces

Inspect the network interfaces of the machines using `ip addr` or `ifconfig`.
There are 3 interfaces of interest:
- On the host:
    - interface to the LAN: 
        - `wlp1s0` or similar if connected to wifi
        - `enp1s0`, `eth0` or similar if connected to ethernet
    - interface like `virbr0` to the VM
- On the VM:
    - interface like `enp1s0` to the host

Furthermore if you start the VPN in the VM a new interface like `tun0` should be created.

This is a diagramm of the setup:
```
       +------------------------------------------------------+
       |                                                      |
       |    Host                                              |
       |                                                      |
       |    +--------+    +------------------------------+    |
LAN <-----> | wlp1s0 |    |                              |    |
       |    +--------+    |    VM                        |    |
       |                  |                              |    |
       |    +--------+    |    +--------+  +--------+    |    |
       |    | virbr0 | <-----> | enp1s0 |  |  tun0  |    |    |
       |    +--------+    |    +--------+  +--------+    |    |
       |       ...        +------------------------------+    |
       +------------------------------------------------------+
```

The interfaces might be named a bit differently on your machines, you will have to adapt the following commands accordingly.

### Routing

Linux uses a routing table to determine where to send packets.
The routing table can be consulted using the `route` command.

Therefore:
1. The routing table of the host has to be modified so that it sends packets meant for the VPN to the VM.
1. The VM has to be adjusted so that it forwards these packets received from the host to the VPN.

## VM

Enable IP forwarding:
```bash
echo '1' >> /proc/sys/net/ipv4/ip_forward
```

Adjust the firewall to forward `enp1s0` to `tun0`:
```bash
iptables -t nat -A POSTROUTING -o tun0 -j MASQUERADE

iptables -A FORWARD -i enp1s0 -o tun0 -j ACCEPT
iptables -A FORWARD -o tun0 -j ACCEPT
iptables -A FORWARD -i tun0 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

iptables -A INPUT -i tun0 -j ACCEPT
```

## Host

There are two ways to set up the host:

### Static

This is simpler if you only need to access a few resources.
If there is a website called `site.example` that you need to access:
1. Look up the IP address of `site.example` using `dig` or `nslookup`. Let's assume it is `10.10.10.10`.
1. Add an entry to your `/etc/hosts` file:
```sh
# /etc/hosts
10.10.10.10     site.example
```
1. Find the IP address of the `enp1s0` network interface of the VM.
It must be on the same subnet as the `virbr0` interface of the host.
Let's assume it is `192.168.100.100`.
1. Add an entry to the routing table of the host specifying that packets bound for the IP of the website should use the VM as the gateway.
```bash
route add 10.10.10.10/32 gw 192.168.100.100 metric 200 dev virbr0
```
1. You should be able to access the website.
```bash
curl site.example
```

### DNS

This is more complicated but might be necessary if a static setup would be too tedious.

1. Find the VPN name server using `dig` or `nslookup`.
1. Configure the host to use it for DNS resolution. The concrete steps to do this depend on your setup, but this is tricky:
    - You should restrict usage of the VPN name server to domains that it is actually needed for.
    - You might not know all of the domains this applies to.
    - You cannot use the name server on your router because it doesn't have access to the VPN.
    - Therefore you might have to run a seperate name server on the host and configure the fallback logic between router and VPN name server there.
    - Failing to set this up correctly could leak your DNS queries to the VPN name server and break a DNS sinkholing setup.
1. Expose the VPN name server as well as the VPN subnets using the host routing table as explained in the [static](./clandestine-vpn-split-tunneling.html#static) section.

#### Example

DNS using `systemd-resolved` with `systemd-networkd`

Run on the VM:
```bash
dig site1.example
# ...
# site1.example.	300	IN	A	10.10.10.10
# ...
# ;; SERVER: 10.10.10.53#53(10.10.10.53) (UDP)
# ...
```
Thus the VPN name server is `10.10.10.53`.

Make sure you are actually using resolved for host resolution.
The `/etc/nsswitch.conf` file should contain the following line:
```bash
hosts:  files resolve dns
```
See also `man nss-resolve` and `man nsswitch.conf`.

Set the VPN name server as the network DNS server in `/etc/systemd/network/wlp1s0.network`.
```ini
[Match]
Name=wlp1s0

[Network]
DNS=10.10.10.53
Domains=site1.example site2.example ~example
```
See also `man systemd.network`.

Set your prefered non-VPN name server as your global DNS server in `/etc/systemd/resolved.conf`:
```ini
[Resolve]
DNS=8.8.8.8
```
See also `man systemd-resolved.service`.

Reload:
```bash
systemctl daemon-reload
systemctl restart systemd-networkd
systemctl restart systemd-resolved
```

This has the effect that `host1.site1.example` will be resolved using `10.10.10.53` but `on.the.internet` using `8.8.8.8`.

Add routing information for the VPN name server and other resources you need to access:
```bash
route add 10.10.10.53/32 gw 192.168.100.100 metric 200 dev virbr0
route add 10.10.10.10/32 gw 192.168.100.100 metric 200 dev virbr0
```

You can troubleshoot using:
```bash
resolvectl status
```

The output should look something like this:
```bash
Global
         Protocols: -LLMNR -mDNS -DNSOverTLS DNSSEC=no/unsupported
  resolv.conf mode: foreign
Current DNS Server: 8.8.8.8
       DNS Servers: 8.8.8.8

Link 2 (wlp1s0)
    Current Scopes: DNS
         Protocols: -DefaultRoute +LLMNR -mDNS -DNSOverTLS DNSSEC=no/unsupported
Current DNS Server: 10.10.10.53
       DNS Servers: 10.10.10.53
        DNS Domain: site1.example site2.example ~example

# ...
```

## Persistence

All of the commands are non-persistent.
If you want them to survive a reboot you have to create a startup script running them on boot.

Ideally you want
- a startup script on the host setting up the routing table and starting the VM, and
- a startup script on the VM starting the VPN and adjusting the firewall.

The specifics will highly depend on your setup and use case.

## Conclusion

Notice how you can use these techniques to
- split tunnel before a full tunnel VPN,
- share a VPN connection with multiple computers or
- use multiple VPNs simultaneously

without the arbiters of the VPN being able to do much about it.
