# More Openjdk Debugging Functionalities on Alpine Linux

geekidea@gmail.com

---

### Issues & Solutions
The debugging tools (e.g. jmap) ported by openjdk package on Alpine Linux just 
had poor functionalities, due to the lack of thread_db API's on Alpine Linux.
such API's were *NOT* implemented in musl (the libc library on Alpine Linux).

The related bug was filed as [#286](https://github.com/docker-library/openjdk/issues/286),
commonly you can't fetch the heap info for specified java process by jmap, and
only had less functionalities, as below:
```
$ /usr/lib/jvm/default-jvm/bin/jmap -h
Usage:
    jmap -histo <pid>
      (to connect to running process and print histogram of java object heap
    jmap -dump:<dump-options> <pid>
      (to connect to running process and dump java heap)

    dump-options:
      format=b     binary default
      file=<file>  dump heap to <file>

    Example:       jmap -dump:format=b,file=heap.bin <pid>
```

There was an openjdk project named [Portola](https://openjdk.java.net/projects/portola/),
and the goal is to provide a port of the JDK to the Alpine Linux, also the 
developers had coded the [fixes](http://cr.openjdk.java.net/~jgeorge/8178784/webrev.01/hotspot.patch) 
by iterating '/proc/<pid>/task' instead of thread_db API's to fetch jvm threads' id,
and such issues & fixes had been discussed by openjdk dev team ([for more](https://bugs.openjdk.java.net/issues/?jql=project+%3D+JDK+AND+fixVersion+%3D+repo-portola)).

We should follow the process of building alpine apk to build the new openjdk 
with the code fixes on Alpine Linux, further more, convert the code fixes into
apk patch, and did a few codes fixes as the compile error about the definition 
of 'lwpid_t'.

---

### Results

After building the apk the jmap's dependencies were gererated as sa-jdi.jar and
libsaproc.so, put them onto jvm /jdk relative directory, then you can get more
functionalities, as below:
```
$ /usr/lib/jvm/default-jvm/bin/jmap -h
Usage:
    jmap [option] <pid>
        (to connect to running process)
    jmap [option] <executable <core>
        (to connect to a core file)
    jmap [option] [server_id@]<remote server IP or hostname>
        (to connect to remote debug server)

where <option> is one of:
    <none>               to print same info as Solaris pmap
    -heap                to print java heap summary
    -histo[:live]        to print histogram of java object heap; if the "live"
                         suboption is specified, only count live objects
    -clstats             to print class loader statistics
    -finalizerinfo       to print information on objects awaiting finalization
    -dump:<dump-options> to dump java heap in hprof binary format
                         dump-options:
                           live         dump only live objects; if not specified,
                                        all objects in the heap are dumped.
                           format=b     binary format
                           file=<file>  dump heap to <file>
                         Example: jmap -dump:live,format=b,file=heap.bin <pid>
    -F                   force. Use with -dump:<dump-options> <pid> or -histo
                         to force a heap dump or histogram when <pid> does not
                         respond. The "live" suboption is not supported
                         in this mode.
    -h | -help           to print this help message
    -J<flag>             to pass <flag> directly to the runtime system
```

---

### Note

Alpine Linux would shift the openjdk packages occasionally, so we should build 
the openjdk by using the corresponding aport code base, ([for more](https://pkgs.alpinelinux.org/package/v3.8/community/x86_64/openjdk8)).

In addition, you should install the openjdk-dbg package (apk add --no-cache openjdk8-dbg).
