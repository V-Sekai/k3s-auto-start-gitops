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
        path: '/usr/local/bin/run-coreos-installer',
        mode: 493,
        contents: {
          inline: "#!/usr/bin/bash\nset -x\nmain() {\n    ignition_file='/home/core/k3s-autoinstall.ign'\n    image_url='https://builds.coreos.fedoraproject.org/prod/streams/stable/builds/32.20201004.3.0/x86_64/fedora-coreos-32.20201004.3.0-metal.x86_64.raw.xz'\n    firstboot_args='console=tty0'\n    if [ -b /dev/sda ]; then\n        install_device='/dev/sda'\n    elif [ -b /dev/nvme0 ]; then\n        install_device='/dev/nvme0'\n    else\n        echo \"Can't find appropriate device to install to\" 1>&2\n        poststatus 'failure'\n        return 1\n    fi\n    cmd=\"coreos-installer install --firstboot-args=${firstboot_args}\"\n    cmd+=\" --image-url ${image_url} --ignition=${ignition_file}\"\n    cmd+=\" ${install_device}\"\n    if $cmd; then\n        echo \"Install Succeeded!\"\n        return 0\n    else\n        echo \"Install Failed!\"\n        return 1\n    fi\n}\nmain\n",
        },
      },
      {
        path: '/home/core/k3s-autoinstall.ign',
        contents: {
          inline: importstr 'k3s-autoinstall.ign',
        },
      },
    ],
  },
}
