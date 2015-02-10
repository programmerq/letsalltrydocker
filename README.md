To generate the documentation:

    docker run --rm -v $(pwd):/sources programmerq/makepandoc

To use this handout with a group, you'll need a fast wifi connection that they can all use. If the connection is deficient in any way, that can cause lots if issues. My thoughts for getting around that problem:

1) Use a docker-registry proxy and include instructions to get that set up. (*cons*: Introduces an extra setup step to a group of beginners taking their first docker steps. Folks have to undo that setup when they take their laptop home. *pros*: gives the normal `docker pull` interface once set up.)
2) Serve up `docker save`'d tarballs on a small http server on your laptop. Put up the ip address on the projector along with a list of tarballs that can be used. (*cons*: `docker load` isn't a normal workflow. If the wifi router is your bottleneck, this will not be much help. *pros*: It is much faster than `docker pull` in general.)
3) Use amazon or digital ocean droplets for everyone. (*cons*: have to pass out an API key that is long and difficult to type. Costs money. Some networks may not allow SSH. *pros*: Gives everyone the same setup, and you do not depend on local bandwidth constraints.)

I have a very simple [instructions.md](instructions.md) that I used to throw up common info on the projector (wifi connection info, ip addresses, commands, etc). I will probably switch it so that pandoc outputs beamer slides instead of html. For now, the html works as long as you increase the font.
