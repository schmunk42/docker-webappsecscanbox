# Objective

[Docker](http://docs.docker.com) build file creating a [image](http://docs.docker.com/introduction/understanding-docker/#how-does-a-docker-image-work) of a box containing web application scanners. 

Final goal is to use the docker image in order to integrate security web application scanners into a **C**ontinuous **I**ntegration **P**latform.

> Free and open sources scanners has been used in order to enable possibility to add a first level of security validation (surface) on project that don't have the budget to buy commercial suite. 


# Image location

A automated build has been defined on Docker forge in order to build and push image in Docker Hub repository.

https://registry.hub.docker.com/u/righettod/webappsecscanbox/


# Use image 

> You must [install Docker](https://docs.docker.com/installation/) on your target system (for example on the CIP host).

Web application scanners has been choosen according to their capacity and also possibility on use them entirely from a single command line.

All scanners has been installed in parent folder **/usr/local**.

## Open an interactive shell


```
docker run --rm=true -i -t righettod/webappsecscanbox /bin/bash
```

## Execute a scanner on web application

In command below we mount the path "/tmp/work" of the container to the path "/tmp/scanner/work" of the host (CIP host) in order to write reports on host storage.


### Arachni


```
docker run --rm=true -v /tmp/work:/tmp/scanner/work/arachni -t righettod/webappsecscanbox /usr/local/arachni/bin/arachni [OPTIONS] http://myapp --report-save-path=/tmp/scanner/work/arachni/report.afr
```

Command line options: https://github.com/Arachni/arachni/wiki/Command-line-user-interface

### Wapiti


```
docker run --rm=true -v /tmp/work:/tmp/scanner/work/wapiti -t righettod/webappsecscanbox python2.7 /usr/local/wapiti/bin/wapiti http://myapp [OPTIONS] --output /tmp/scanner/work/wapiti
```

Command line options: http://wapiti.sourceforge.net/

### Skipfish


```
docker run --rm=true -v /tmp/work:/tmp/scanner/work/skipfish -t righettod/webappsecscanbox /usr/local/skipfish/skipfish [OPTIONS] -o /tmp/scanner/work/skipfish http://myapp
```

Command line options: https://code.google.com/p/skipfish/wiki/SkipfishDoc
