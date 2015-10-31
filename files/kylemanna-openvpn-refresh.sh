#!/bin/sh

docker pull vaca/s6
docker pull kylemanna/openvpn

docker rm -f ovpn_data
docker run --name=ovpn_data --volumes-from=ovpn_run -d --restart=always vaca/s6

docker rm -f ovpn_run
docker run --name=ovpn_run --volumes-from=ovpn_data -d --restart=always -p 1194:1194/udp --cap-add=NET_ADMIN kylemanna/openvpn
