# Docker - Atlassian FishEye

This is a Docker-Image for Atlassian FishEye / Crucible based on Debian 9.

## Getting started
Run Atlassian FishEye standalone and navigate to `http://[dockerhost]:8060` to finish configuration:

```bash
docker run -ti -e ORACLE_JAVA_EULA=accepted -p 8060:8060 streacs/atlassian-fisheye:x.x.x
```

## Environment Variables
* ORACLE_JAVA_EULA
* JVM_ARGUMENTS
* SYSTEM_USER = fisheye
* SYSTEM_GROUP = fisheye
* SYSTEM_HOME = /home/fisheye
* APPLICATION_INST = /opt/atlassian/fisheye
* APPLICATION_HOME = /var/opt/atlassian/application-data/fisheye

## Ports
* 8060 = Default HTTP Connector

## Volumes
* /var/opt/atlassian/application-data/fisheye

## Oracle end user license agreement
To run this container you have to accept the terms of the Oracle Java end user license agreement.
http://www.oracle.com/technetwork/java/javase/terms/license/index.html

Add following environment variable to your configuration : 
```bash
-e ORACLE_JAVA_EULA=accepted
```

## Source Code
[Github](https://github.com/streacs/docker_atlassian_fisheye)

## License
This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details