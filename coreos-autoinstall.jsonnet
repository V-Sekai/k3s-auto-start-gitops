{
  variant: 'fcos',
  version: '1.0.0',
  systemd: {
    units: [
      {
        name: 'run-coreos-installer.service',
        enabled: true,
        contents: '[Unit]\nAfter=network-online.target\nWants=network-online.target\nBefore=systemd-user-sessions.service\nOnFailure=emergency.target\nOnFailureJobMode=replace-irreversibly\n[Service]\nRemainAfterExit=yes\nType=oneshot\nExecStart=/usr/local/bin/run-coreos-installer\nExecStartPost=/usr/bin/systemctl --no-block poweroff\nStandardOutput=kmsg+console\nStandardError=kmsg+console\n[Install]\nWantedBy=multi-user.target\n',
      },
    ],
  },
  storage: {
    files: [
      {
        path: '/usr/local/bin/run-k3s-prereq-installer',
        mode: 493,
        contents: {
          inline: '#!/usr/bin/env sh\nmain() {\n  rpm-ostree install https://rpm.rancher.io/k3s-selinux-0.1.1-rc1.el7.noarch.rpm\n  return 0\n}\nmain\n',
        },
      },
      {
        path: '/home/core/config.ign',
        contents: {
          inline: importstr 'k3s-autoinstall.ign',
        },
      },
    ],
  },
}
