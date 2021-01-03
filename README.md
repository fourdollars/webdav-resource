 [![GitHub: fourdollars/webdav-resource](https://img.shields.io/badge/GitHub-fourdollars%2Fwebdav%E2%80%90resource-green.svg)](https://github.com/fourdollars/webdav-resource/) [![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT) [![Bash](https://img.shields.io/badge/Language-Bash-red.svg)](https://www.gnu.org/software/bash/) ![Docker](https://github.com/fourdollars/webdav-resource/workflows/Docker/badge.svg) [![Docker Pulls](https://img.shields.io/docker/pulls/fourdollars/webdav-resource.svg)](https://hub.docker.com/r/fourdollars/webdav-resource/)
# webdav-resource
[concourse-ci](https://concourse-ci.org/)'s webdav-resource

It only supports to get/put files under single folder.

## Config

### Resource Type

```yaml
resource_types:
- name: resource-webdav
  type: registry-image
  source:
    repository: fourdollars/webdav-resource
    tag: latest
```

or

```yaml
resource_types:
- name: resource-webdav
  type: registry-image
  source:
    repository: ghcr.io/fourdollars/webdav-resource
    tag: latest
```

### Resource

* domain: **required**
* ssl: true by default
* port: optional
* username: optional
* password: optional
* path: optional
* overwrite: optional, true by default and it can be overriden by params.overwrite of put step below.

```yaml
resources:
- name: storage
  type: resource-webdav
  source:
    domain: domain.name.or.ip
    ssl: false
    port: 8080
    username: YourUserName
    password: YourPassWord
    path: PrimaryFolder
    overwrite: false
```

### get step

* path: optional
* files: optional
* skip: optional, set true if you just want to list files and folders.

```yaml
- get: storage
  params:
    path: SecondaryFolder
    files:
      - file1.txt
      - file2.txt
    skip: false
```
```shell
# It acts like the following commands.
$ cd /tmp/build/get
$ echo "mget file1.txt file2.txt" | cadaver http://domain.name.or.ip:8080/PrimaryFolder/SecondaryFolder
```

### put step

* from: **required**
* files: optional
* overwrite: optional
* path: optional
* skip: optional if you don't want the [implicit get step](https://concourse-ci.org/jobs.html#put-step) after the put step to download the same content again in order to save the execution time.

```yaml
- put: storage
  params:
    from: SomeFolderInTask
    files:
      - file1.txt
      - file2.txt
    overwrite: false
    path: SecondaryDirectory
  get_params:
    skip: true
```
```shell
# It acts like the following commands.
$ cd /tmp/build/put/SomeFolderInTask
$ echo "ls" | cadaver http://domain.name.or.ip:8080/PrimaryFolder/SecondaryFolder | grep -P file1.txt\|file2.txt || \
  echo "mput file1.txt file2.txt" | cadaver http://domain.name.or.ip:8080/PrimaryFolder/SecondaryFolder
```
