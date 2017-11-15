#### Demo
```txt
[root@localhost /]# tree /etc/systemd/ -L 2
/etc/systemd/
├── bootchart.conf
├── coredump.conf
├── journald.conf
├── logind.conf
├── system
│   ├── basic.target.wants
│   ├── dbus-org.freedesktop.NetworkManager.service -> /usr/lib/systemd/system/NetworkManager.service
│   ├── dbus-org.freedesktop.nm-dispatcher.service -> /usr/lib/systemd/system/NetworkManager-dispatcher.service
│   ├── default.target -> /lib/systemd/system/multi-user.target
│   ├── default.target.wants
│   ├── getty.target.wants
│   ├── multi-user.target.wants
│   ├── sockets.target.wants
│   ├── sysinit.target.wants
│   └── system-update.target.wants
├── system.conf
├── user
└── user.conf
```
