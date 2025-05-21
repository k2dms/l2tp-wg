#!/bin/bash

set -e

echo "🔐 Применяем защиту VPN от DDoS и усиливаем сеть..."

### === IPTABLES RATE-LIMITING === ###
echo "🛡 Настраиваем iptables rate limiting на UDP-порты..."

# WireGuard порт (UDP)
iptables -C INPUT -p udp --dport 51820 -j DROP 2>/dev/null || {
    iptables -A INPUT -p udp --dport 51820 -m limit --limit 20/second --limit-burst 40 -j ACCEPT
    iptables -A INPUT -p udp --dport 51820 -j DROP
}

# IPSec: IKE
iptables -C INPUT -p udp --dport 500 -j DROP 2>/dev/null || {
    iptables -A INPUT -p udp --dport 500 -m limit --limit 10/second --limit-burst 20 -j ACCEPT
    iptables -A INPUT -p udp --dport 500 -j DROP
}

# IPSec: NAT-T
iptables -C INPUT -p udp --dport 4500 -j DROP 2>/dev/null || {
    iptables -A INPUT -p udp --dport 4500 -m limit --limit 10/second --limit-burst 20 -j ACCEPT
    iptables -A INPUT -p udp --dport 4500 -j DROP
}

echo "✅ iptables ограничены — защита активна."


### === SYSCTL HARDENING === ###
echo "🧠 Настраиваем sysctl параметры безопасности..."

SYSCTL_CONF="/etc/sysctl.d/99-vpn-security.conf"

cat <<EOF > "$SYSCTL_CONF"
net.ipv4.conf.all.rp_filter = 1
net.ipv4.icmp_echo_ignore_broadcasts = 1
net.ipv4.icmp_ignore_bogus_error_responses = 1
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.all.accept_source_route = 0
EOF

sysctl -p "$SYSCTL_CONF" > /dev/null

echo "✅ Sysctl настройки применены."

echo "🎯 Готово! Защита VPN-серверов от DDoS и уязвимостей включена."
