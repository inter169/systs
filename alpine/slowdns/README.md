# DNS Reslove Slowly on Alpine Linux

geekidea@gmail.com

### Issues & Solutions
On Alpine Linux 3.7/3.8 there were some issues about slow DNS query, due to
the timed out for additional AAAA query along with A query by default.

In our use cases this slow DNS query caused our docker apps responded to 
clients slowly (around 5+ secs). e.g. the apps requested URI's from 
following hosts:
```
wx.qlogo.cn
thirdwx.qlogo.cn
thirdapp0.qlogo.cn
thirdapp1.qlogo.cn
thirdapp2.qlogo.cn
thirdapp3.qlogo.cn
```
Similar issues like:

http://www.openwall.com/lists/musl/2017/09/28/1

This [kubernetes issue](https://github.com/kubernetes/kubernetes/issues/56903) 
describe a lot more details, the root cause was the conntrack racy kernel 
[bug](https://www.weave.works/blog/racy-conntrack-and-dns-lookup-timeouts) 
which was fixed in latest kernel.

Currently in our user cases *no* need to query AAAA records by default, so 
the workaround is removing AAAA resolution from the implements 
(musl/src/network/lookup_name.c, function 'name_from_dns', the [commit](https://github.com/inter169/musl/commit/b6aa74a1cb1b802879ee34c01de1ca7c24f302e2)).

### Building the packages
For Alpine Linux 3.7 we should patch the fixes in this git repo directory 
to the musl [1.1.18-r3](https://pkgs.alpinelinux.org/package/v3.7/main/x86_64/musl) codes,
and the aports for building apk package can be found [here](https://git.alpinelinux.org/cgit/aports/snapshot/aports-944a45f26d02bb803737af70cf5f012194796146.tar.bz2).

on Alpine Linux 3.8 the dedicated version of musl is [1.1.19-r10](https://pkgs.alpinelinux.org/package/v3.8/main/x86_64/musl), and the [aports](https://git.alpinelinux.org/cgit/aports/snapshot/aports-ed42835662421a72dbc1c47397a2805306203860.tar.bz2).

on Alpine Linux 3.9 the dedicated version of musl is [1.1.20-r3](https://pkgs.alpinelinux.org/package/v3.9/main/x86_64/musl), and the [aports](https://git.alpinelinux.org/aports/snapshot/aports-7b32fee49798e36cb5a7dfde30183f9717472cf6.tar.bz2).

The so binarires compiled with the fix were also placed in the sub-directories
for different versions of Alpine Linux.

### Public repo
I pushed the docker image onto the public [site](https://hub.docker.com/r/geekidea/alpine-a/),
and you can use the following docker versions tags:
```
docker pull geekidea/alpine-a:3.7
docker pull geekidea/alpine-a:3.8
docker pull geekidea/alpine-a:3.9
```
### Note
I coded the fix based on musl 1.1.18-r3 for Alpine Linux 3.7, and musl 1.1.19-r10 
for Alpine Linux 3.8, once new official version released by Alpine we should 
patch and build a new one (so library) via that released versoin of musl.

The guidance of building the musl package is below:
```
1. install the sdk (apk add alpine-sdk) on some version of alpine linux docker.
2. create the non-root user, and add it into /etc/sudoers.
3. add the non-root user into group abuild (sudo addgroup <yourusername> abuild).
4. extract the aport archive file, and change your working directory into musl.
5. modify 'APKBUILD' to include the fix, by using patch or URI of the fixed musl source archive.
6. build the package including the libraries (abuild -r -K).
```

### References
* [Creating an Alpine package](https://wiki.alpinelinux.org/wiki/Creating_an_Alpine_package)

