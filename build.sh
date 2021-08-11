podman run --privileged --pull=always --rm -v .:/data -w /data quay.io/coreos/coreos-installer:release download -f iso \
&& jsonnet k3s-autoinstall.jsonnet | yq --yaml-roundtrip > k3s-autoinstall.fcc \
&& podman run -i --rm quay.io/coreos/fcct:release --pretty --strict < k3s-autoinstall.fcc > k3s-autoinstall.ign \
&& jsonnet coreos-autoinstall.jsonnet | yq --yaml-roundtrip > coreos-autoinstall.fcc \
&& podman run -i --rm quay.io/coreos/fcct:release --pretty --strict < coreos-autoinstall.fcc > coreos-autoinstall.ign \
&& podman run --privileged --pull=always --rm -v .:/data -w /data quay.io/coreos/coreos-installer:release iso ignition embed -i coreos-autoinstall.ign ./fedora-coreos-*-live.x86_64.iso
rm *.sig