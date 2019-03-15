# Run Cron as Non-root on Alpine Linux

geekidea@gmail.com

---

### Issues & Solutions
On Alpine Linux (other linux distributions probably) the crond process must be 
running as the root privilege, it's too harmful for security concerns, for 
further the user didn't have the root privileges to run processes on the docker 
commonly.

The related bug was filed as [#381](https://github.com/gliderlabs/docker-alpine/issues/381),
on Alpine Linux the 'crond' daemon service would schedule the jobs for users, 
it was implemented in the ['busybox'](https://github.com/mirror/busybox/blob/master/miscutils/crond.c) code base.
as you can see the crond would switch the job privilege into the normal user 
privilege, same as the job of the user. so crond process must be running as 
root.

I coded the [fix](https://github.com/inter169/busybox/commit/ccfc894f0c9430ab346c07c98e441efb105fbba5)
that allowed you to run crond as the normal user privilege, and it can 
schedule the jobs of the same user **only**, it's very helpful in case of least
permissions, on docker espically, I would discuss the code fix with the alpine 
comminity soon.

currently I pushed the patched alpine docker with the fix onto the public site:
```
geekidea/alpine-cron:3.7
geekidea/alpine-cron:3.8
geekidea/alpine-cron:3.9
```
---

### Results

---

### Note
