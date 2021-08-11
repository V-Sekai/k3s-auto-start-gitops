local public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDq1hbTO1d7RIKUTV2Yw+thPoh4yw3axCoBblZ/BYVqrfWvSJZZM2RYj8aCKKaIAphS3TYYKr84T7v2b0lv01aT50ckBQDs26Ls9eYH4xg6TVLKe53GQB0O5k5Q9WVzHNmItg0HIRsZVyrXDM8vIceiQNvaqmS0dwU2hxM6TIgkPKPzg7Mp+XYRWA4gsZ07L7owUCO9S0JmXY2hqG2FdbcPaiDz9dLLbR6V2/BhS+fUBxpAskMFuluELkRt9FEc+xvnBikKz49xnyAxWgE32zpOewpq1HhQZArmarbbh4SnP2FkWPblfvxt2Zs3iYgS7nbCn4JE92VwYfz+EAdTB1vj cardno:000611115208";

{
  variant: 'fcos',
  version: '1.0.0',
  systemd: {
    units: [
      {
        name: 'getty@tty1.service',
        dropins: [
          {
            name: 'autologin-core.conf',
            contents: '[Service]\nExecStart=\nExecStart=-/usr/sbin/agetty --autologin core --noclear %I $TERM\n',
          },
        ],
      },
      {
        name: 'run-k3s-prereq-installer.service',
        enabled: true,
        contents: '[Unit]\nAfter=network-online.target\nWants=network-online.target\nBefore=systemd-user-sessions.service\nOnFailure=emergency.target\nOnFailureJobMode=replace-irreversibly\nConditionPathExists=!/var/lib/k3s-prereq-installed\n[Service]\nRemainAfterExit=yes\nType=oneshot\nExecStart=/usr/local/bin/run-k3s-prereq-installer\nExecStartPost=/usr/bin/touch /var/lib/k3s-prereq-installed\nExecStartPost=/usr/bin/systemctl --no-block reboot\nStandardOutput=kmsg+console\nStandardError=kmsg+console\n[Install]\nWantedBy=multi-user.target\n',
      },
      {
        name: 'run-k3s-installer.service',
        enabled: true,
        contents: '[Unit]\nAfter=network-online.target\nWants=network-online.target\nBefore=systemd-user-sessions.service\nOnFailure=emergency.target\nOnFailureJobMode=replace-irreversibly\nConditionPathExists=/var/lib/k3s-prereq-installed\nConditionPathExists=!/var/lib/k3s-installed\n[Service]\nRemainAfterExit=yes\nType=oneshot\nExecStart=/usr/local/bin/run-k3s-installer\nExecStartPost=/usr/bin/touch /var/lib/k3s-installed\nStandardOutput=kmsg+console\nStandardError=kmsg+console\n[Install]\nWantedBy=multi-user.target\n',
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
        path: '/usr/local/bin/run-k3s-installer',
        mode: 493,
        contents: {
          inline: '#!/usr/bin/env sh\nmain() {\n  export K3S_KUBECONFIG_MODE="644"\n  export INSTALL_K3S_EXEC=" --no-deploy servicelb --no-deploy traefik"\n\n  curl -sfL https://get.k3s.io | sh -\n  return 0\n}\nmain\n',
        },
      },
    ],
  },
  passwd: {
    users: [
      {
        name: 'core',
        ssh_authorized_keys: [
          public_key,
        ],
      },
    ],
  },
}