# Docker - Atlassian FishEye

This is a Docker-Image for Atlassian FishEye / Crucible based on Debian 9.

## Getting started
Run Atlassian FishEye standalone and navigate to `http://[dockerhost]:8060` to finish configuration:

```bash
docker run -ti -p 8060:8060 streacs/atlassian-fisheye:x.x.x
```

## Environment Variables
* (O) JVM_ARGUMENTS =
* (I) SYSTEM_USER = fisheye
* (I) SYSTEM_GROUP = fisheye
* (I) SYSTEM_HOME = /home/fisheye
* (I) APPLICATION_INST = /opt/atlassian/fisheye
* (I) APPLICATION_HOME = /var/opt/atlassian/application-data/fisheye
* (O) JVM_MEMORY_MIN = 1024m
* (O) JVM_MEMORY_MAX = 2048m

(M) = Mandatory / (O) = Optional / (I) Information

## Ports
* 8060 = Default HTTP Connector

## Volumes
* /var/opt/atlassian/application-data/fisheye

## Examples

Modify JVM memory
```bash
docker run -ti -p 8060:8060 -e JVM_MEMORY_MIN=1024m -e JVM_MEMORY_MAX=2048m streacs/atlassian-fisheye:x.x.x
```

Persist application data
```bash
docker run -ti -p 8060:8060 -v FISHEYE-DATA:/var/opt/atlassian/application-data/fisheye streacs/atlassian-fisheye:x.x.x
```

## Databases

This image doesn't include the MySQL JDBC driver.
Please use PostgreSQL.

## Source Code
[Github](https://github.com/streacs/docker_atlassian_fisheye)

## License
This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details