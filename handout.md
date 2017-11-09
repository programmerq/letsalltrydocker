#Let’s All Check out Docker

##Installation

Lots of combinations to get docker running from your laptops!

Docker has a host and a client. The host runs on linux x86\_64 on any 3.8 or newer kernel. (the centos7.4/rhel7.4 kernel does work though).

The docker binary is both the host and client.

[http://docs.docker.com/installation/](http://docs.docker.com/installation/) - official installation docs (the sparse info here isn't enough on its own)

If you are running Windows 10 Pro, I recommend installing [Docker for Windows](https://www.docker.com/docker-windows). If you are running MacOS, I recommend [Docker for Mac](https://www.docker.com/docker-mac).

If you are on Windows 10 Home, or previous versions of Windows, then [Docker Toolbox](https://www.docker.com/products/docker-toolbox) is a quick way to get Virtualbox, the `docker` CLI, `docker-machine`, and a running VM with Docker installed and running.

###virtualbox

[https://www.virtualbox.org/wiki/Downloads](https://www.virtualbox.org/wiki/Downloads) - Yes it is slow, but it is free. I use it and can help with it better than any other virtualization solution. use with boot2docker, docker-machine, or bring your own VM.

<small>\begin{note}{gets you: a quick [enough] way to run docker}\end{note}</small>

###docker-machine (windows, linux, osx)

This will succeed boot2docker (cli portion) - gets you a docker host and helps you interact with it. works with amazonec2, azure, digitalocean, google, none, openstack, rackspace, softlayer, virtualbox, vmwarefusion, vmwarevcloudair, vmwarevsphere.

Download the binary and put it in your `PATH`:

[https://github.com/docker/machine/releases](https://github.com/docker/machine/releases)

1. install virtualbox
2. put docker-machine in your `PATH`
3. run `docker-machine create -d virtualbox dev`
4. run `docker $(docker-machine config dev) ps`
5. run `docker-machine env dev` to get shell exports (if you want)

<small>\begin{note}{gets you: a docker daemon/host running in a local VM or a cloud provider. You will need to install the docker binary for use on the CLI separately/manually.}\end{note}</small>

###bare docker binaries

handy if you don’t want to use an installer to get the docker command: [https://github.com/docker/docker/releases](https://github.com/docker/docker/releases)

gets you: the docker command in your `PATH`. If on a linux machine, can launch the daemon as well. For non-linux machines, you get a binary that works as the client only.

\vfill
\vbox{}
\columnbreak

###Linux Native

Follow normal docker installation instructions (same for a real server and for your linux laptop)

 * [http://docs.docker.com/installation/ubuntulinux/](http://docs.docker.com/installation/ubuntulinux/)
 * [http://docs.docker.com/installation/centos/](http://docs.docker.com/installation/centos/)
 * [http://docs.docker.com/installation/debian/](http://docs.docker.com/installation/debian/)

<small>\begin{note}{gets you: a docker daemon/host running locally, and the docker command in your `PATH`}\end{note}</small>

\vfill
\vbox{}
\pagebreak

##Docker Basics
###Verify your setup
You should be able to run the following commands and get similar output:

    $ docker
    <a bunch of usage info>
    $ docker ps

(permission denied on `/var/run/docker.sock` means you have to add your user to the docker group, or run docker as sudo).
`docker ps` communicates with the docker daemon and returns a list of running containers. We have none on an empty docker host

###Docker daemon info

    $ docker info
    # gives output about the docker host
    $ docker version
    # gives version info about the client and server
    $ docker events
    # streams events that happen in the docker host.

(see also /var/log/docker on the host)

###Running a Container

    $ docker run busybox /bin/echo Hello World
    Unable to find image 'busybox:latest' locally
    busybox:latest: The image you are pulling has been verified
    511136ea3c5a: Pull complete
    df7546f9f060: Pull complete
    ea13149945cb: Pull complete
    4986bf8c1536: Pull complete
    Status: Downloaded newer image for busybox:latest
    Hello World

This downloaded an image called busybox, launched a new process (/bin/echo) in a container in the foreground, and ran until that process exited.

Run it again:

    $  docker run busybox /bin/echo Hello World
    Hello World

note it does not redownload the image.

###Image Basics

    # list images found locally
    $ docker images
    # find images on the docker hub
    $ docker search debian
    # pull down an image from the docker hub
    $ docker pull debian
    # yes run it again to see what happens.
    $ docker pull debian

Also, try doing `search` and `pull` on debian.

###Interactive Processes in a Container (like a shell)

    $ docker run -i -t ubuntu /bin/bash -l
    root@bd84701e04a3:/#

The `-i` attaches standard input, and `-t` allocates a pseudo-tty, which the `bash` process expects for interactive sessions.

You can do stuff. Try some different commands:

    # ps faux
    # cat /etc/*release
    # apt-get update
    # ifconfig

(we will talk more about networking later)

`ctrl+d` or exit to quit the shell (which also stops the container)

Hint: you can try running bash inside a few different image types: `debian`, `busybox`, `ubuntu`, `centos`, etc.

###Interacting with containers

    $ docker run -d ubuntu /bin/bash \
    -c ‘while true; do date; sleep 5; done’
    f8d9b1774e59c052c37ddadde82b344967b538b38158f82c2aa
    effb9439ae4f5
    $

now we can see a real running container:

    $ docker ps

Notice the funny name-- I got `drunk_goldstine`. What did you get? The long ID spit out after the `docker run` is listed in the ps, along with the image name, command, created timestamp, and status.

###Naming a container

you can specify a name with `--name`

    $ docker run --name datesleep -d ubuntu /bin/bash \
    -c 'while true; do date; sleep 5; done'
    200620b0b60e66054a785bef53af964c1754793ef823b1033cd
    3d71bee2ecabe
    $ docker ps

###Getting Help

Every `docker` command has a very helpful --help section. Try it out:

    docker --help
    docker run --help
    docker ps --help

The answer to many common questions is found in the corresponding --help output!

###Commands you can run against containers

I use the previously created `datesleep` container for most of these examples. Use that one, or run your own.

####logs

    $ docker logs <container_name|container_id>
    $ docker logs datesleep

* `docker logs -f` acts like `tail -f`
* `docker logs -t` shows timestamps

####stop

    $ docker stop datesleep
    #no more datesleep listed after stop, but it isn’t gone
    $ docker ps
    #show all containers, including stopped 
    $ docker ps -a

####start

    $ docker start datesleep

####create

`docker create` is like `docker run` but doesn't start the container for you.

####exec

Attach a new command to an existing container.

    $ docker exec [-i] [-t] [-d] \
    <container_name|container_id> <command>
    $ docker exec -it datesleep /bin/bash
    $ docker exec datesleep env
    $ docker exec datesleep ps faux

####rm

    $ docker rm datesleep
    datesleep
    $ docker ps -a | grep datesleep # no results

rm fails on a running container unless you specify `-f`

    $ docker rm -f drunk_goldstine
    drunk_goldstine

####kill

    $ docker kill datesleep
    
This is like stop, but jumps straight to `SIGKILL` or whatever signal you specify with `-s`

####removing all containers

    $ docker ps -aq | xargs docker rm
    # what output does this give?

####removing a container automatically on exit

    # handy for scripting
    $ docker run --rm ubuntu echo Hello World
    Hello World

####pause/unpause

    $ docker pause datesleep # this uses lxc-freeze
    $ docker ps # what does a paused container look like in ps?
    $ docker unpause datesleep

####attach

    $ docker attach datesleep
    # remember we started datesleep in detached mode

(depending how a container was started, try `ctrl+p` `ctrl+q`, `ctrl+c`, or simply kill your window where you ran `docker attach` to detach again)

####rename

    $ docker rename datesleep endlessloop

####cp

    $ docker cp datesleep:/etc/passwd .

Is the destination a file? directory? on the box running the cli? on the host?

####inspect

    $ docker inspect datesleep
    # return a bunch of information about the given container

####wait

    $ docker wait datesleep
    # blocks until container stops, then prints its exit code

####Environment variables

    $ docker run --rm -i -t -e MY_VAR=foobar ubuntu /bin/bash
    root@97ed3f770889:/# env

###More stuff about images (layers and commits)
Images are a filesystem snapshot with layers (up to 128)

base_layer + layer_1 + … + layer_n

Each layer has an id. there is an image name and a tag name.

`image:tag`

`docker pull ubuntu` is implicitly `docker pull ubuntu:latest`

####diff

    $ docker run -i -t --name step1 ubuntu /bin/bash -l
    root@a5376bc49d09:/# date > /timestamp
    root@a5376bc49d09:/# exit
    logout
    $ docker diff step1
    C /root
    A /root/.bash_history
    A /timestamp

####commit

> As a side note, using `docker commit` isn't a common workflow and is usually only something I recommend for times like now when you want to learn about how the image layers are created. The normal process for creating images and new image layers will be using `docker build` which is discussed later.

    $ docker commit step1 ts
    11d4b36a6d721a0e63666843a1aaa0db08c04c2864432a0e131
    2ca666ea4be65
    $ docker images # ts is listed with its id.

####tag

    # want to give an image another name or tag?
    $ docker tag ts ts:thursday
    $ docker tag ts timestamp
    $ docker tag ts programmerq/timestamp

####inspect

    # yes, this works with a container or an image
    $ docker inspect ts
    # bunch of output

####running the new image

    $ docker run --rm ts cat /timestamp
    Fri Jan 30 07:19:54 UTC 2015

####deleting the image

remove the image called 'ts'

    $ docker rmi ts

equivalent to 'docker rmi ts'

    $ docker rmi ts:latest

`-f` forces image deletion, similar to `docker rm -f` container

    $ docker rmi -f ts

###Even more stuff about images (Dockerfiles!)

Manually running and committing isn’t the best interface to creating images.

####build / Dockerfile

Create a file called `Dockerfile` in its own directory. Make the following be its contents:

    FROM debian
    RUN date > /timestamp

Now, run the following commands from the same directory where you put your `Dockerfile`.

    $ docker build -t ts .
    $ docker images
    $ docker run --rm ts cat /timestamp

A more complex Dockerfile:

    FROM debian:jessie
    RUN apt-get update
    RUN apt-get -y install apache2
    
    ENV APACHE_RUN_USER www-data
    ENV APACHE_RUN_GROUP www-data
    ENV APACHE_LOG_DIR /var/log/apache2
    
    EXPOSE 80
    
    CMD ["/usr/sbin/apache2", "-D", "FOREGROUND"]

Now, run the following:

    $ docker build -t apache .
    # watch it take its time
    $ docker build -t apache .
    # watch it finish very quickly

### More on Dockerfile syntax

Full docs here: [http://docs.docker.com/engine/reference/builder/](http://docs.docker.com/engine/reference/builder/)

####Dockerfile ADD

Copies stuff into the container

    ADD src /home/code/src
    ADD http://example.com/stuff.txt /home/code/stuff
    ADD src.tgz /home/code/stuff

####Dockerfile COPY

Similar to add, but doesn’t take a URL nor will it handle untarring/uncompressing stuff

    COPY src /home/code/src

####Dockerfile EXPOSE

Explicitly specify ports that the container listens on. This sets metadata in the image about what the containerized application is expected to listen on, but doesn't do any enforcement and doesn't provide any sort of guarantee.

    EXPOSE 80

####Dockerfile ENV

set an environment variable (takes place for subsequent build steps, *and* the final running container

    ENV MY_AWESOME_VAR "foobar"

\vfill
\vbox{}
\newpage

## Moving images around

###Image namespacing and the docker hub

Create an account at [https://hub.docker.com/](https://hub.docker.com/). Now, build an image with your username namespaced:

    $ docker build -t <username>/my_first_image .

Log in to the hub with your docker cli (credentials stored in base64(clear) on your filesystem, only transmitted over https to the hub)

    $ docker login

push the image:

    $ docker push <username>/my_first_image

It is now publically online for anyone to see/download: [https://registry.hub.docker.com/u/<username>/my_first_image/](https://registry.hub.docker.com/u/<username>/my_first_image/)

###Private Registry

You can run your own registry server ([https://github.com/docker/distribution](https://github.com/docker/distribution)).

    $ docker build -t registry.mycompany.com/apache
    $ docker login registry.mycompany.com 
    $ docker push registry.mycompany.com/apache

##Networking!

We like to containerize things that tend to be network services.
Many examples show docker containers being accessed on `127.0.0.1`. That does not always work. With boot2docker, you can find the ip by running `boot2docker ip`. With docker machine, you can find it by running `docker-machine ip`

<!--This section uses docker images: `nginx`, `wordpress`, and `mysql`-->

###Exposing vs Publishing ports

Telling docker to expose a port on a container makes that port accessible to any containers linked to the one with the exposed port. Publishing a port makes the service on that port accessible from the outside network.

####Exposing

In a Dockerfile, `EXPOSE 80` will tell docker that the container is running a service on port 80. You can do this from the command line as well with the `--expose` switch to create/run, but it is far better practice to expose ports in the image.

####Publishing all exposed ports

    $ docker run --name my_nginx -d -P nginx
    $ docker run --name my_second_nginx -d -P nginx
    $ docker ps

All exposed ports are published and assigned a random port on the docker host's IP. Note how both nginx containers *think* they are running on 80.

    # We can grab that random port number programatically too.
    $ docker port my_nginx 80

####Publishing ports manually

    $ docker pull nginx

run nginx, exposing a port:

    $ docker run --name my_nginx -d -p 80 nginx
    $ docker ps

Open your browser to <docker_ip>:<port> and you should see the nginx default page.

####Exposing ports explicitly

Random ports can suck sometimes. Force port 80 on the container to be mapped to 8080.

    $ docker run --name my_nginx -d -p 8080:80 nginx


###Networks and Service Discovery!

First, create a custom network:

    $ docker network create -d bridge mynet 

Fire up a MySQL server for wordpress

    $ docker run --net mynet \
    --name mysql -e \
    MYSQL_ROOT_PASSWORD=secret -d mysql

(Normally we don't run this image quite like this with the root password out in the clear. Just stay with me for the example)

Fire up wordpress

    $ docker run --net mynet \
    --name example_wordpress \
    --env WORDPRESS_DB_HOST=mysql \
    --env WORDPRESS_DB_PASSWORD=secret \
    -p 8080:80 -d wordpress

Now you can visit [http://docker_host_ip:8080/](http://docker_host_ip:8080/) in your browser and complete the wordpress setup.

How did wordpress find the 'mysql' host?

    $ docker exec example_wordpress cat /etc/resolv.conf

When using a network created by the `docker network create` interface, all containers get configured to use the 127.0.0.11 internal DNS resolver. This DNS server is run by docker, and will resolve any container connected on that network if you look it up by its `--name`.

    $ docker exec example_wordpress ping -c 1 mysql

\vfill
\vbox{}
\pagebreak

##Volumes

When a container is removed, its data goes away with it.

Simplest use of a volume:

    docker run -v /myvolume <image> <cmd>

`/myvolume` will persist until it is used by no containers.

You can also specify a `VOLUME` inside a `Dockerfile`

###Volume sharing

Run these in two separate terminals

    $ docker run --name one -it -v /myvolume \
    debian /bin/bash

    $ docker run --name two -it --volumes-from one \
    debian /bin/bash

Write a file in `one`, it will be visible in `two`

###Data container pattern

Note I don't actually start the container named `data`. It only needs to exist:

    $ docker create --name data -v /var/lib/mysql busybox
    $ docker run -d --name my_mysql -e \
    MYSQL_ROOT_PASSWORD=pass --volumes-from data -P mysql
    # now we can insert stuff into the db
    $ docker rm -f my_mysql # remove the container
    $ docker run -d --name second_mysql -e \
    MYSQL_ROOT_PASSWORD=pass --volumes-from data -P mysql
    # and access the same data again.

###Host directory as a volume

    $ docker run --name some-nginx -v \
    /some/content:/usr/share/nginx/html:ro -P -d nginx
    # note that /some/content is read from the docker host
    # and not from where you run the docker command.
    $ echo "hello" > /some/content/foo.txt
    $ curl <docker_host>:<nginx_port>/foo.txt

##Docker-swarm

Runs the docker API in front of several real docker hosts. You interact with it normally, and it deals with scheduling containers across all the docker hosts in the cluster. In alpha and active development. [https://github.com/docker/swarm/](https://github.com/docker/swarm/)

\vfill
\vbox{}
\columnbreak

##Docker-compose

An orchestration tool to start all our containers! Currently being renamed from fig.

[http://www.fig.sh/](http://www.fig.sh/)

To install, follow instructions at [https://github.com/docker/fig/releases](https://github.com/docker/fig/releases).


###Wordpress example, but with docker-compose

Create a file in an empty directory called `docker-compose.yml`:

    wordpress:
      image: wordpress
      links:
        - mysql
    mysql:
      image: mysql
      environment:
        - MYSQL_ROOT_PASSWORD=password

Now run:

    $ docker-compose up

##Security
###Privileged mode

    $docker run --privileged xxx

Effectively gives the container real root. 

###Owning a Docker Host

The docker daemon is root, and we can get to just about anything we want:

    $ docker run --privileged -v /:/hostroot \
    -i -t ubuntu /bin/bash

##Resource Management

###Weighted CPU shares

    $ docker run -c X

###Memory limits

    docker run -m 2g
    docker run --memory-swap=2g

\vfill
\vbox{}
