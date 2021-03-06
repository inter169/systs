# this docker image defined new alpine, by replacing crond (busybox),
# which included the code fix to allow non-root user to run crond
#
# alpine basic docker definition, build instructions is following:
# ver="3.8"
# pack="alpine-cron"
# docker build --rm -f $pack.$ver.dockerfile -t $pack:$ver .
# 
# to push it onto public repo in 'hub.docker.com', run the cmds:
# docker tag $pack:$ver geekidea/$pack:$ver
# docker push geekidea/$pack:$ver
# 
# NOTE
# the patched busybox was based on the package of version '1.28.4-r3' 
# dedicated for Alpine Linux 3.8.

FROM alpine:3.8
MAINTAINER harper.wang <geekidea@gmail.com>

COPY bin/busybox /bin/busybox
CMD ["/bin/sh"]
