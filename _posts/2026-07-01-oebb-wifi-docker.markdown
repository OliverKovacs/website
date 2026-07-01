---
author:     Oliver Kovacs
category:   blog
date:       2026-07-01T00:00:00+02:00
icon:       ./assets/img/technologies/nix.svg
layout:     post
tags:       linux, nix, docker
title:      Fixing ÖBB WiFi conflict with Docker on NixOS
---

## Problem

As explained in [this](https://unterwaditzer.net/2024/oebb-docker.html) great blogpost by Markus Unterwaditzer Docker sometimes adds routes to the routing table that make it impossible to connect to the WiFi on ÖBB trains.
As a quick fix they may manually be removed with

```sh
sudo ip route del 172.19.0.0/16 
```

However they will be recreated eventually.

## Solution

Delete the `br-*` devices and associated routes.
Put the following in your `configuration.nix`:

```nix
virtualisation.docker = {
  extraOptions = ''\'''\'
    --default-address-pool base=172.44.0.0/16,size=24
  ''\'''\';
};
```

This will make Docker give out `/24` networks from the `172.44.0.0/16` range.
You may tweak this according to your needs.
