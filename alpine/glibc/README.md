# glibc package for Alpine Linux

geekidea@gmail.com

There's no glibc package ported by alpine linux officially, and for such java
libraries depending on some c/c++ JNI libraries (.so) we should install the 
glibc package on alpine linux beacuse of the dependencies of such JNI libs.

the related issues & prs:
```
https://github.com/wurstmeister/kafka-docker/issues/298
https://github.com/wurstmeister/kafka-docker/pull/306 
```

the local glibc apk was downloaded from sgerrand github:
```
https://github.com/sgerrand/alpine-pkg-glibc
```

you can install this apk by the command on alpine linux:
```
GLIBC_VERSION=2.27-r0
apk add --no-cache --allow-untrusted glibc-${GLIBC_VERSION}.apk \
```
