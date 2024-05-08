#!/bin/bash

# 更新系统包索引
sudo yum update -y && sudo yum install -y curl tar

# 创建文件夹
DIR="/aanode"
if [ ! -d "$DIR" ]; then
    mkdir $DIR
    echo "Directory $DIR created."
else
    echo "Directory $DIR already exists."
fi
sleep 2
cd /aanode
touch 123.txt
sudo curl -o /aanode/apphub-linux-amd64.tar.gz https://assets.coreservice.io/public/package/60/app-market-gaga-pro/1.0.4/app-market-gaga-pro-1_0_4.tar.gz
tar -zxf /aanode/apphub-linux-amd64.tar.gz
rm -f /aanode/apphub-linux-amd64.tar.gz

# 下载校验脚本
cd /aanode
sudo curl -o check_apphub.sh "http://note.youdao.com/yws/api/personal/file/WEB56b7ba0db76e723b07bb147ed1852933?method=download&inline=true&shareKey=40d46d68205caee9a411dc1f3fd847fc"

# 赋予文件夹恰当的权限
sudo chmod -R 755 /aanode
sudo chmod +x /aanode/check_apphub.sh
sleep 3
echo "Files have been downloaded successfully."
# 修正脚本中的换行符
sed -i 's/\r$//' /aanode/check_apphub.sh
echo "check_apphub.sh format has been fixed."

sudo /aanode/apphub-linux-amd64/apphub service remove
sudo /aanode/apphub-linux-amd64/apphub service install
sudo /aanode/apphub-linux-amd64/apphub service start
sudo /aanode/apphub-linux-amd64/apphub status

# 更新系统上所有已安装的包
sudo yum update -y

# 配置应用程序
cd /aanode/apphub-linux-amd64
sudo ./apps/gaganode/gaganode config set --token=gdfopujqbeyorvcn36fc158217cf675f
sudo /aanode/apphub-linux-amd64/apphub restart
sudo /aanode/apphub-linux-amd64/apps/gaganode/gaganode config set --token=gdfopujqbeyorvcn36fc158217cf675f
sudo /aanode/apphub-linux-amd64/apphub service start
sudo /aanode/apphub-linux-amd64/apphub status

echo "MSN installation has been completed."

# 添加定时任务检查服务运行状态
cron_job="0 */2 * * * /aanode/check_apphub.sh"
(crontab -l 2>/dev/null; echo "$cron_job") | crontab -

echo "Cron job has been added successfully."

# 注册系统服务
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

# 重新加载 systemd 配置
sudo systemctl daemon-reload
# 启用服务开机自启
sudo systemctl enable apphub.service
# 启动服务
sudo systemctl start apphub.service
# 查看服务状态
sudo systemctl status apphub.service --no-pager

echo "Apphub service has been added to system startup."
sudo /aanode/apphub-linux-amd64/apphub status
