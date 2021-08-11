{
  variant: 'fcos',
  version: '1.0.0',
  systemd: {
    units: [
      {
        name: 'run-coreos-installer.service',
        enabled: true,
        contents: '[Unit]
After=network-online.target
Wants=network-online.target
Before=systemd-user-sessions.service
OnFailure=emergency.target
OnFailureJobMode=replace-irreversibly
[Service]
RemainAfterExit=yes
Type=oneshot
ExecStart=/usr/local/bin/run-coreos-installer
ExecStartPost=/usr/bin/systemctl --no-block poweroff
StandardOutput=kmsg+console
StandardError=kmsg+console
[Install]
WantedBy=multi-user.target
',
      },
    ],
  },
  storage: {
    files: [
      {
        path: '/usr/local/bin/run-coreos-installer',
        mode: 493,
        contents: {
          inline: "#!/usr/bin/bash
set -x
main() {
    ignition_file='/home/core/config.ign'
    image_url='https://builds.coreos.fedoraproject.org/prod/streams/stable/builds/32.20201004.3.0/x86_64/fedora-coreos-34.20210725.3.0-metal.x86_64.raw.xz'
    firstboot_args='console=tty0'
    if [ -b /dev/vda ]; then
        install_device='/dev/vda'
    elif [ -b /dev/sda ]; then
        install_device='/dev/sda'
    elif [ -b /dev/nvme0 ]; then
        install_device='/dev/nvme0'
    else
        echo \"Can't find appropriate device to install to\" 1>&2
        poststatus 'failure'
        return 1
    fi
    cmd=\"coreos-installer install --firstboot-args=${firstboot_args}\"
    cmd+=\" --image-url ${image_url} --ignition=${ignition_file}\"
    cmd+=\" ${install_device}\"
    if $cmd; then
        echo \"Install Succeeded!\"
        return 0
    else
        echo \"Install Failed!\"
        return 1
    fi
}
main
",
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
