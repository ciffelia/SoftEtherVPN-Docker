FROM buildpack-deps:buster AS builder

ADD https://jp.softether-download.com/files/softether/v4.34-9745-rtm-2020.04.05-tree/Linux/SoftEther_VPN_Server/64bit_-_Intel_x64_or_AMD64/softether-vpnserver-v4.34-9745-rtm-2020.04.05-linux-x64-64bit.tar.gz /root

WORKDIR /root
RUN tar xf softether-vpnserver-v4.34-9745-rtm-2020.04.05-linux-x64-64bit.tar.gz

WORKDIR /root/vpnserver
RUN make i_read_and_agree_the_license_agreement

#*#*#*#*#*#*#*#*#*#*#*#

FROM debian:buster

RUN apt-get update && \
    apt-get install -y --no-install-recommends iptables && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /root/vpnserver /usr/local/vpnserver

ENTRYPOINT ["/usr/local/vpnserver/vpnserver", "execsvc"]
