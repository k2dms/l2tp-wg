#!/bin/bash

set -e

echo "🧯 Откат защитных настроек VPN..."

### === Удаление iptables правил === ###
echo "🔓 Удаляем iptables ограничения..."

iptables -D INPUT -p udp --dport 51820 -m limit --limit 20/second --limit-burst 40 -j ACCEPT 2>/dev/null || true
iptables -D INPUT -p udp --dport 51820 -j DROP 2>/dev/null || true

iptables -D INPUT -p udp --dport 500 -m limit --limit 10/second --limit-burst 20 -j ACCEPT 2>/dev/null || true
iptables -D INPUT -p udp --dport 500 -j DROP 2>/dev/null || true

iptables -D INPUT -p udp --dport 4500 -m limit --limit 10/second --limit-burst 20 -j ACCEPT 2>/dev/null || true
iptables -D INPUT -p udp --dport 4500 -j DROP 2>/dev/null || true

echo "✅ iptables ограничения удалены."


### === Удаление sysctl-конфига и восстановление значений по умолчанию === ###
SYSCTL_CONF="/etc/sysctl.d/99-vpn-security.conf"

if [ -f "$SYSCTL_CONF" ]; then
    echo "🔄 Удаляем sysctl hardening..."
    rm -f "$SYSCTL_CONF"
    sysctl --system > /dev/null
    echo "✅ sysctl настройки сброшены."
else
    echo "ℹ️ sysctl конфиг не найден — пропускаем."
fi

echo "🎉 Настройки VPN-сервера возвращены к исходному состоянию."
