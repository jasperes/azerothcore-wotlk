
# Updates
apt update
apt upgrade

# Docker
apt install ca-certificates curl
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF

apt update
apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Firewall
apt install iptables netfilter-persistent

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

netfilter-persistent save

# Git Project
apt install git
git clone https://github.com/jasperes/azerothcore-wotlk.git --branch=jaspion /opt/azerothcore-wotlk

# Mise
curl https://mise.run/bash | sh
bash
cd /opt/azerothcore-wotlk
mise trust .

# Environment
read -s -p "Enter MySQL Password: " mysql_password
echo "MYSQL_ROOT_PASSWORD=\"$mysql_password\"" >> .env

# AzerothCore
mise run install:modules
mise run build
sudo chown -R 1000:1000 env/dist/etc/ env/dist/logs/ data/
mise run start
# - build sem modules
# - configurar IP server (UPDATE acore_auth.realmlist r SET r.address = 'SEU_IP_PÚBLICO_OU_LOCAL' WHERE r.id = 1;)
# - criar conta GM
# - mise run loggin:world
# - .account create gm <password>
# - .account set gmlevel gm 3 -1

# Playerbots
# - importar modulo
# - rodar sql: https://github.com/mod-playerbots/mod-playerbots/wiki/Installation-Guide#3-playerbots-database-setup
# - editado configurações do mysql

# AH Bot
# - criar conta ahbot
# - mise run loggin:world
# - .account create ahbot <password>
# - criar 10 personagens nessa conta
# - consultar no banco ID (SELECT * FROM acore_characters.characters c JOIN acore_auth.account a ON c.account = a.id WHERE a.username = 'ahbot';)
# - atualizar no config ID dos bots: 1066,1067,1068,1069,1070,1071,1072,1073,1074,1075
# - ativar mod

# Guild House
# - rodar script sql manualmente
# - .guild create MyCharacter "MyGuild"
# - spawn npcs: .npc add 500030
# - npc edita house: .guildhouse butler

# Starter Guild
# - criar guild
# - consultar ID da guilda no banco: SELECT * FROM guild WHERE name = 'NOME_DA_SUA_GUILD';
# - atualizar no config ID da guilda
# - ativar mod

# Instance Reset
# - rodar script sql manualmente
# - spawn npcs: .npc add 300000

# Ollama Chat
# - entrar no container ollama
# - conectar conta do ollama
# - instalar modelo

##########

### char dump ###
# cd /opt/azerothcore-wotlk
# mkdir -P env/dist/etc/shared
# mise run loggin:world
# .pdump write env/dist/etc/shared/<filename> <character_name>
# docker cp ac-worldserver:/azerothcore/env/dist/etc/shared/<filename> <filename>
#
# mkdir -P env/dist/etc/shared
# mise run loggin:world
# .pdump load env/dist/etc/shared/<filename> <account>

##########

### CLASSIC -> TBC -> WOTLK ###
#
# - configuracoes em config
#
# verificar todas dg
# - SELECT * FROM dungeon_access_template ORDER BY min_level;
#
# rodar script.sql na versao desejada
#

##########

# SETUP MACHINE RESTART AND BACKUP
vim /usr/local/bin/azerothcore_start.sh
vim /usr/local/bin/azerothcore_restart.sh

vim /etc/systemd/system/azerothcore_start.service
vim /etc/systemd/system/azerothcore_restart.service
vim /etc/systemd/system/azerothcore_restart.timer

systemctl daemon-reload
systemctl enable azerothcore_start.service
systemctl enable azerothcore_restart.timer
systemctl start azerothcore_restart.timer
