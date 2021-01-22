---
title: Setting up a Docker context
date: 2020-12-24 17:20
description: Docker context how to use-it to avoid `docker-machine` on Mac scilicone.
tags: docker, mac-osx
published: true
---
# Setting up a Docker context

## Introduction

For using `Docker` on Mac m1, i tried to find many startegies to continue using my backend-enviroenemnt like previously with a Mac x86_64.

First i tried to build `docker-machine`, `docker`, `docker-compose` with `brew install --rebuild` but unsuccessfully.

Then i tried to create a vm or use my old machine with ubuntu server with `docker` installed, but i will not put all my backend-end app on the vm because this app is under developpement, so here i replaced just my `docker-machine` with my `virtual-box`.

Still i need to have `docker` and `docker-compose` installed on my Mac m1. 

In this case i used this [step](https://docs.docker.com/engine/install/binaries/) to install docker from scratch and about docker-compose you can use this [step](https://github.com/docker/compose#using-pip) using pip3 instead of pip make sure you have a python3 installed on your Mac silicone.

## Docker Context

The remaining steps are simple. We create a Docker context:

```bash
docker context create my-vm --docker "host=ssh://ubuntu@192.168.1.37"
```

And tell Docker to use it

```bash
docker context use my-vm
```

Now all docker commands are targeting the virtual or physical machine, just like they do in Docker for Mac.


You can try it using:

```bash
docker ps
```

you will see sometings like that

```bash
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
```

You can find out more about docker context in the [online documentation](https://docs.docker.com/engine/context/working-with-contexts/)
