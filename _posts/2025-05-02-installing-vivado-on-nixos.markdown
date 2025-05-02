---
author:     Oliver Kovacs
categories: blog
date:       2025-05-02 00:00:00 +0200
icon:       "./assets/img/technologies/nix.svg"
layout:     post
text:       linux, nix<br>2025 May 2
title:      "Installing Vivado on NixOS"
---

## Introduction

I hate [Vivado](https://en.wikipedia.org/wiki/Vivado) but I am forced to use
it at university. It is notoriously complicated to set up on Linux and using
NixOS has caused me extra difficulties.

In this post I will detail how to install Vivado 2019.2 on `nixos-unstable`.
Other combinations of versions may or may not work.

## Installing

1. Download `Vivado HLx 2019.2: All OS installer Single-File Download` from the
[Xilinx website](https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/vivado-design-tools/archive.html).

2. Extract it using
```bash
cd ~/Downloads && tar xzvf Xilinx_Vivado_2019.2_1106_2127.tar.gz
```

3. In the extracted directory create a `shell.nix` file with the following content:
```nix
# shell.nix
{ pkgs ? import <nixpkgs> { } }:
(pkgs.buildFHSEnv {
  name = "vivado-env";
  targetPkgs = pkgs: (
    with pkgs; [
      ncurses5
      zlib libuuid
      bash coreutils zlib stdenv.cc.cc
      xorg.libXext xorg.libX11 xorg.libXrender xorg.libXtst
      xorg.libXi xorg.libXft xorg.libxcb xorg.libxcb
      freetype fontconfig glib gtk2 gtk3
      graphviz gcc unzip nettools
    ]
  );
  runScript = ''
    env LIBRARY_PATH=/usr/lib \
      C_INCLUDE_PATH=/usr/include \
      CPLUS_INCLUDE_PATH=/usr/include \
      CMAKE_LIBRARY_PATH=/usr/lib \
      CMAKE_INCLUDE_PATH=/usr/include \
      bash
  '';
}).env
```

4. Run `nix-shell`.

5. Run `./xsetup -b ConfigGen`. Select `Vivado HL WebPACK`.

6. Edit the install config:
```
nvim ~/.Xilinx/install_config.txt
```
It seems advisable to change `Destination` to a path that we have read/write permissions for. <br>
I used `<home directory>/opt/Xilinx`.

7. Install Vivado with
```bash
./xsetup \
-a XilinxEULA,3rdPartyEULA,WebTalkTerms \
-b Install \
-c $HOME/.Xilinx/install_config.txt
```

8. See [Notes on <tt>libtinfo.so.5</tt>](/blog/2025/05/02/installing-vivado-on-nixos.html#notes-on-libtinfoso5).
Run
```bash
ln -s /usr/lib/libtinfo.so.5 ~/opt/Xilinx/Vivado/2019.2/lib/lnx64.o/libtinfo.so.5
```

9. You can now launch Vivado with
```bash
~/opt/Xilinx/Vivado/2019.2/bin/vivado
```

## Desktop Entry

1. Create a `shell.nix` in `~/opt/Xilinx/Vivado/2019.2/bin/` with the following content
```nix
# shell.nix
{ pkgs ? import <nixpkgs> { } }:
(pkgs.buildFHSEnv {
  name = "vivado-env";
  targetPkgs = pkgs: (
    with pkgs; [
      ncurses5
      zlib libuuid
      bash coreutils zlib stdenv.cc.cc
      xorg.libXext xorg.libX11 xorg.libXrender xorg.libXtst
      xorg.libXi xorg.libXft xorg.libxcb xorg.libxcb
      freetype fontconfig glib gtk2 gtk3
      graphviz gcc unzip nettools
    ]
  );
  runScript = ''
    env LIBRARY_PATH=/usr/lib \
      C_INCLUDE_PATH=/usr/include \
      CPLUS_INCLUDE_PATH=/usr/include \
      CMAKE_LIBRARY_PATH=/usr/lib \
      CMAKE_INCLUDE_PATH=/usr/include \
      $HOME/opt/Xilinx/Vivado/2019.2/bin/vivado
  '';
}).env
```

2. Open the desktop entry for Vivado:
```bash
nvim .local/share/applications/Vivado\ 2019.2_*.desktop
```
Change the line starting with `Exec` to
```sh
Exec=nix-shell <home directory>/opt/Xilinx/Vivado/2019.2/bin/shell.nix
```

## Notes on <tt>libtinfo.so.5</tt>

If step 8. is omitted then running Vivado throws the following error:
```
application-specific initialization failed: couldn't load file "librdi_commontasks.so":
libtinfo.so.5: cannot open shared object file: No such file or directory
```
This seems to be a common issue and is usually solved by installing `libtinfo-dev`
or symlinking `/usr/lib/libtinfo.so.6` to `/usr/lib/libtinfo.so.5`.
However this is not the solution in this case because `libtinfo.so.5` is actually
present at the reasonable locations (`/usr/lib`, `/lib`, ...) but Vivado
refuses to find it for some unknown reason.
The only workaround I found is symlinking/copying `libtinfo.so.5`
to `<install dir>/Xilinx/Vivado/2019.2/lib/lnx64.o`

### Solution

```bash
ln -s /usr/lib/libtinfo.so.5 ~/opt/Xilinx/Vivado/2019.2/lib/lnx64.o/libtinfo.so.5
```

### Non-solution 1

I cannot even install `libtinfo`.
```bash
nix-shell -p libtinfo
# ...
ERROR: noBrokenSymlinks: the symlink /nix/store/l3sa8c1f03l84zkz6afbzgya3ad4jcmi-ncurses-6.5-dev/lib/pkgconfig/tic.pc points to a missing target: /nix/store/l3sa8c1f03l84zkz6afbzgya3ad4jcmi-ncurses-6.5-dev/lib/pkgconfig/ncurses.pc
ERROR: noBrokenSymlinks: the symlink /nix/store/l3sa8c1f03l84zkz6afbzgya3ad4jcmi-ncurses-6.5-dev/lib/pkgconfig/tinfo.pc points to a missing target: /nix/store/l3sa8c1f03l84zkz6afbzgya3ad4jcmi-ncurses-6.5-dev/lib/pkgconfig/ncurses.pc
ERROR: noBrokenSymlinks: found 2 dangling symlinks, 0 reflexive symlinks and 0 unreadable symlinks
```

### Non-solution 2

Creating a symlink from `/usr/lib/libtinfo.so.6` to `/usr/lib/libtinfo.so.5`
in an `FHSEnv` is not trivial at all because `/usr` is read-only.
Therefore we have to use a package override so that the symlink is already created in the package.
```nix
# shell.nix
{ pkgs ? import <nixpkgs> { } }:
(
let
  custom-ncurses = pkgs.ncurses.overrideAttrs (finalAttrs: previousAttrs:  {
    postFixup = previousAttrs.postFixup + ''
        ln -svf $out/lib/libtinfo.so.6 $out/lib/libtinfo.so.5
    '';
  });
in
  pkgs.buildFHSEnv {
    name = "vivado-env";
    targetPkgs = pkgs: (
      with pkgs; [
        custom-ncurses
        zlib libuuid
        bash coreutils zlib stdenv.cc.cc
        xorg.libXext xorg.libX11 xorg.libXrender xorg.libXtst
        xorg.libXi xorg.libXft xorg.libxcb xorg.libxcb
        freetype fontconfig glib gtk2 gtk3
        graphviz gcc unzip nettools
      ]
    );
    runScript = ''
      env LIBRARY_PATH=/usr/lib \
        C_INCLUDE_PATH=/usr/include \
        CPLUS_INCLUDE_PATH=/usr/include \
        CMAKE_LIBRARY_PATH=/usr/lib \
        CMAKE_INCLUDE_PATH=/usr/include \
        $HOME/opt/Xilinx/Vivado/2019.2/bin/vivado
    '';
  }
).env
```
However as mentioned this still does not solve the problem.

## Uninstalling

> WARNING: This might be overkill for you. Read it carefully and use common sense!

```
rm -rf \
~/opt/Xilinx \
~/.Xilinx \
~/.config/menus/applications-merged/Xilinx\ Design\ Tools.menu \
~/.local/share/applications/*Vivado* \
~/.local/share/applications/*Xilinx* \
~/.local/share/applications/Uninstall\ 2019.2* \
~/.local/share/applications/Add\ Design\ Tools\ or\ Devices\ 2019.2* \
~/.local/share/applications/Documentation\ Navigator* \
~/.local/share/applications/Uninstall\ DocNav*
```

## Resources

This post is largely based on [kotatsuyaki's excellent article](https://blog.kotatsu.dev/posts/2021-09-14-vivado-on-nixos/)
Xilinx Vivado on NixOS.

Also check out [Bruce Röttgers' post](https://bruceroettgers.eu/install-vivado/)
on installing Vivado on Ubuntu.
