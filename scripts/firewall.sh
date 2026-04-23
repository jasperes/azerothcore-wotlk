#!/bin/bash

echo "=== Configurando Firewall UFW - Bloqueio Total ==="
echo "SSH (22) e AzerothCore (8085/3724) serão liberados"

# Atualizar sistema e instalar UFW
apt update && apt install ufw -y

# Resetar configurações existentes (IMPORTANTE)
ufw --force reset

# Política padrão: BLOQUEAR TUDO entrada, permitir saída
ufw default deny incoming
ufw default allow outgoing

# Liberar SSH (prioridade máxima)
ufw allow 22/tcp comment 'SSH - CRITICAL'

# Liberar AzerothCore WorldServer (porta padrão)
ufw allow 8085/tcp comment 'AzerothCore WorldServer'
ufw allow 8085/udp comment 'AzerothCore WorldServer UDP'

# Liberar AzerothCore Realm List
ufw allow 3724/tcp comment 'AzerothCore Realmlist'
ufw allow 3724/udp comment 'AzerothCore Realmlist UDP'

# Bloquear MySQL
ufw deny 3306/tcp comment 'MySQL - Bloqueado externo'

# Permitir loopback (essencial)
ufw allow in on lo

# Ativar firewall (vai pedir confirmação)
echo "Ativando UFW... (digite 'y' quando solicitado)"
ufw --force enable

# Status final
echo "=== STATUS FINAL ==="
ufw status verbose

iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

iptables -A INPUT -p tcp --dport 22 --syn -m conntrack --ctstate NEW -j ACCEPT
iptables -A INPUT -p tcp --dport 8085 --syn -m conntrack --ctstate NEW -j ACCEPT
iptables -A INPUT -p tcp --dport 3724 --syn -m conntrack --ctstate NEW -j ACCEPT
iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT

iptables -A INPUT -i docker0 -j ACCEPT
iptables -A FORWARD -i docker0 -o docker0 -j ACCEPT
iptables -A FORWARD -i docker0 -o eth0 -m conntrack --ctstate NEW -j ACCEPT
iptables -I DOCKER-USER 1 -i eth0 -p tcp --dport 3306 -j DROP
iptables -A INPUT -i lo -p tcp --dport 3306 -j ACCEPT
