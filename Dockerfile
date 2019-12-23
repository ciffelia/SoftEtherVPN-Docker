FROM buildpack-deps:buster AS builder

ADD https://github.com/SoftEtherVPN/SoftEtherVPN_Stable/releases/download/v4.29-9680-rtm/softether-vpnserver-v4.29-9680-rtm-2019.02.28-linux-x64-64bit.tar.gz /root

WORKDIR /root
RUN tar xf softether-vpnserver-v4.29-9680-rtm-2019.02.28-linux-x64-64bit.tar.gz

WORKDIR /root/vpnserver
RUN make i_read_and_agree_the_license_agreement

#*#*#*#*#*#*#*#*#*#*#*#

FROM debian:buster

RUN apt-get update && \
    apt-get install -y --no-install-recommends iptables && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /root/vpnserver /usr/local/vpnserver

ENTRYPOINT ["/usr/local/vpnserver/vpnserver", "execsvc"]
