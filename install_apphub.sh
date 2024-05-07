#!/bin/bash


# 定义目录路径
sudo -i
DIR="/aanode"

# 创建文件夹
if [ ! -d "$DIR" ]; then
    mkdir $DIR
    echo "Directory $DIR created."
else
    echo "Directory $DIR already exists."
fi
sleep 3
chmod -R 777 $DIR
chmod -R 777 /aanode


sudo apt-get update -y && sudo apt-get -y install curl tar ca-certificates

sleep 3

cd $DIR
touch 123.txt
sleep 3

sudo curl -o apphub-linux-amd64.tar.gz https://assets.coreservice.io/public/package/60/app-market-gaga-pro/1.0.4/app-market-gaga-pro-1_0_4.tar.gz && tar -zxf apphub-linux-amd64.tar.gz && rm -f apphub-linux-amd64.tar.gz && cd ./apphub-linux-amd64 && sudo ./apphub service install


sleep 3
cd /aanode/apphub-linux-amd64
sudo curl -o check_apphub.sh "http://note.youdao.com/yws/api/personal/file/WEB56b7ba0db76e723b07bb147ed1852933?method=download&inline=true&shareKey=40d46d68205caee9a411dc1f3fd847fc"



# 赋予文件夹读写权限
# 对所有用户赋予读写执行权限
chmod -R 777 $DIR
sudo chmod +x /aanode/apphub-linux-amd64
sudo chmod +x $DIR
sudo chmod +x /aanode/apphub-linux-amd64/apphub
sudo chmod +x /aanode/apphub-linux-amd64/check_apphub.sh
sudo chmod +x /aanode/apphub-linux-amd64/apps/gaganode/gaganode
sudo chmod +x /aanode
chmod -R 777 /aanode

#所有文件下载完成
sed -i 's/\r$//' /aanode/apphub-linux-amd64/check_apphub.sh

sleep 3

sudo /aanode/apphub-linux-amd64/apps/gaganode/gaganode config set --token=gdfopujqbeyorvcn36fc158217cf675f
sudo /aanode/apphub-linux-amd64/apphub service remove
sudo /aanode/apphub-linux-amd64/apphub service install
sudo /aanode/apphub-linux-amd64/apphub service start



#并添加任务定时检查服务运行，每两个小时一次

# Cron job规则，每两个小时执行一次
cron_job="0 */2 * * * /aanode/apphub-linux-amd64/check_apphub.sh"

# 检查cron job是否已存在
cron_exists=$(crontab -l | grep -F "$cron_job" || true)

# 如果不存在，则添加它
if [[ -z "$cron_exists" ]]; then
    # 将现有的crontab加入新的cron job，如果没有crontab则创建新的
    (crontab -l 2>/dev/null; echo "$cron_job") | crontab -
    echo "Cron job added: $cron_job"
else
    echo "Cron job already exists: $cron_job"
fi




sudo /aanode/apphub-linux-amd64/apps/gaganode/gaganode config set --token=gdfopujqbeyorvcn36fc158217cf675f

sudo /aanode/apphub-linux-amd64/apphub restart

sudo /aanode/apphub-linux-amd64/apphub status



sleep 3

#执行系统开机自启
# 创建一个新的systemd服务单元文件apphub.service

cat <<EOF | sudo tee /etc/systemd/system/apphub.service

[Unit]
Description=Start Apphub Service at Boot
After=network.target

[Service]
Type=oneshot
ExecStart=/bin/sh -c 'sudo /aanode/apphub-linux-amd64/apphub service start >> /aanode/123.txt 2>&1'
RemainAfterExit=true

[Install]
WantedBy=multi-user.target
EOF

# 重新加载systemd，使新的服务单元文件生效
sudo systemctl daemon-reload

# 启用apphub服务，以便开机自启
#sudo systemctl enable apphub.service
# 启动apphub服务，测试是否正常工作
#sudo systemctl start apphub.service
# 查看apphub服务状态
# sudo systemctl status apphub.service --no-pager

sudo /aanode/apphub-linux-amd64/apphub status

sleep 3

