curl -X POST "https://api.digitalocean.com/v2/droplets" \
     -d'{"names": ["cluster-01.fillip.pro","cluster-02.fillip.pro","cluster-03.fillip.pro"], "region": "ams3", "size": "512mb", "image": "coreos-stable", "private_networking": true, "ipv6": true, "user_data":
"#cloud-config

coreos:
  etcd2:
    # generate a new token for each unique cluster from https://discovery.etcd.io/new:
    discovery: https://discovery.etcd.io/$DISCOVERY_TOKEN
    # multi-region deployments, multi-cloud deployments, and Droplets without
    # private networking need to use $public_ipv4:
    advertise-client-urls: http://$private_ipv4:2379,http://$private_ipv4:4001
    initial-advertise-peer-urls: http://$private_ipv4:2380
    # listen on the official ports 2379, 2380 and one legacy port 4001:
    listen-client-urls: http://0.0.0.0:2379,http://0.0.0.0:4001
    listen-peer-urls: http://$private_ipv4:2380
  fleet:
    public-ip: $private_ipv4   # used for fleetctl ssh command
    metadata: region=europe,public_ip=$public_ipv4
  units:
    - name: etcd2.service
      command: start
    - name: fleet.service
      command: start",
      "ssh_keys":[ "0a:c3:8a:df:75:6a:f0:b7:d3:93:18:7a:1b:cd:f4:89" ], "tags": ["cluster"]}' \
      -H "Authorization: Bearer $DO_TOKEN" \
      -H "Content-Type: application/json"