#!/bin/sh

client=${1-koizumi}
set -- $SSH_CONNECTION
server=${3-`curl ipv4.icanhazip.com`}

docker pull kylemanna/openvpn
docker run --name=ovpn_data -d --restart=always -v /root/openvpn:/etc/openvpn vaca/s6
docker run --volumes-from=ovpn_data --rm kylemanna/openvpn ovpn_genconfig -u "$server"
docker run --volumes-from=ovpn_data --rm -it kylemanna/openvpn ovpn_initpki
docker run --volumes-from=ovpn_data --rm -it kylemanna/openvpn easyrsa build-client-full "$client"
docker run --name=ovpn_run -d --volumes-from=ovpn_data --restart=always -p 1194:1194/udp --cap-add=NET_ADMIN kylemanna/openvpn
