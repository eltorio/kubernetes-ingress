#!/bin/bash
# encycrypted with  
# ENCRYPTED_MEMBERS=$(echo "host1 host2 host3" | openssl enc -aes-256-cbc -a -salt)
ENCRYPTED_MEMBERS="U2FsdGVkX1/8dPunstohWk4KVr8jmZuyo3xfdMxCSKfF7TAJIZUYiajhuGoTXHFA /1vQdXew+hHRqkcrU66RdflwZQUgWuZUqpDPSs9ZVSzM7GENTqv5XoqCc2A0hl5N bMGq0NVteIQYVsDlO1WgeIC3Kzu+3+Kj1aen9+0ovTYp/3oJyC79KzSwOo2o8yz+ ZRODVwekvqUWZbM/BIAVQKTi6jd4wls1LZKYxfOOkBKvpNYgs33pXJwe8IJdzp06 jsFHdmpg/mS2wkWymOpDfbnDtLryzTHy9sp2bJsjwK6wEsYBKzBgwkI2fW5+VRvE yzlcPpYAYuDIdWeOQLeHFA=="
MEMBERS=$(echo $ENCRYPTED_MEMBERS | openssl enc -aes-256-cbc -a -d -salt)
function get_install_haproxy_ingress_controller() {
  MEMBERS="azute-gypaete.oci.lesmuids.windows oci-autour.oci.lesmuids.windows oci-chocard.oci.lesmuids.windows oci-choucas.oci.lesmuids.windows oci-circaete.oci.lesmuids.windows oci-tetraslyre.oci.lesmuids.windows mikado.lesmuids.windows"
  go mod tidy -v &&
    BUILD_FOR_ARCHS="amd64 arm64"
  for ARCH in $BUILD_FOR_ARCHS; do
    echo "Building for $ARCH"
    GOOS=linux GOARCH=$ARCH CGO_ENABLED=0 go build -v -o kubernetes-ingress-$ARCH .
  done
  for MEMBER in $MEMBERS; do
    echo "Updating $MEMBER"
    MEMBER_ARCH=$(ssh root@$MEMBER "dpkg --print-architecture")
    ssh root@$MEMBER "systemctl stop haproxy-ingress"
    scp kubernetes-ingress-$MEMBER_ARCH root@$MEMBER:/usr/local/bin/haproxy-ingress-controller
    ssh root@$MEMBER "systemctl start haproxy-ingress"
  done
}