# this docker image defined new alpine, by replacing musl libc library
# with another one, which included the code fix to remove the DNS AAAA
# query by default.
#
# alpine basic docker definition, build instructions is following:
# ver="3.10"
# pack="alpine-a"
# docker build --rm -f $pack.$ver.dockerfile -t $pack:$ver .
# 
# to push it onto public repo in 'hub.docker.com', run the cmds:
# docker tag $pack:$ver geekidea/$pack:$ver
# docker push geekidea/$pack:$ver
# 
# NOTE
# the patched musl library 'ld-musl-x86_64.so.1' was based on the musl
# package of version '1.1.22-r2' dedicated for Alpine Linux 3.10.

FROM alpine:3.10
MAINTAINER harper.wang <geekidea@gmail.com>

COPY lib/ld-musl-x86_64.so.1 /lib/ld-musl-x86_64.so.1
CMD ["/bin/sh"]
