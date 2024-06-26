#!/bin/bash
sudo -i
sudo apt-get update -y && sudo apt-get -y install curl tar ca-certificates
DIR="/aanode"
# 创建文件夹
if [ ! -d "$DIR" ]; then
    mkdir $DIR
    echo "Directory $DIR created."
else
    echo "文件夹 $DIR already exists."
fi
sleep 2
cd /aanode
touch 123.txt
sudo curl -o /aanode/apphub-linux-amd64.tar.gz https://assets.coreservice.io/public/package/60/app-market-gaga-pro/1.0.4/app-market-gaga-pro-1_0_4.tar.gz



# 设定文件路径
FILE_PATH="/aanode/apphub-linux-amd64.tar.gz"

# 检查文件是否存在
while [ ! -f "$FILE_PATH" ]; do
  echo "Waiting for file to download..."
  sleep 5 # 等待2秒
done

echo "文件存在.."

# 文件存在，执行解压
tar -zxvf "$FILE_PATH"
tar -zxvf "$FILE_PATH" -C /aanode



# tar -zxf /aanode/apphub-linux-amd64.tar.gz
rm -f /aanode/apphub-linux-amd64.tar.gz

#接下来的命令 tar -zxf apphub-linux-amd64.tar.gz 会解压该文件，解压后的文件或目录也会在当前工作目录中创建
cd /aanode
sudo curl -o check_apphub.sh "http://note.youdao.com/yws/api/personal/file/WEB56b7ba0db76e723b07bb147ed1852933?method=download&inline=true&shareKey=40d46d68205caee9a411dc1f3fd847fc"

# 赋予文件夹读写权限
# 对所有用户赋予读写执行权限
sudo chmod -R 777 /aanode
sudo chmod +x /aanode/check_apphub.sh
sleep 3
echo "文件都已下载完成.=================================================================================================================="
#对脚本的空格格式加以修改
sed -i 's/\r$//' /aanode/check_apphub.sh
echo "check_apphub.sh空格格式修改完成.=================================================================================================================="

sudo /aanode/apphub-linux-amd64/apphub service remove
sudo /aanode/apphub-linux-amd64/apphub service install
sudo /aanode/apphub-linux-amd64/apphub service start
sudo /aanode/apphub-linux-amd64/apphub status
#刷新本地应用列表，必要操作
sudo apt-get upgrade -y
cd /aanode/apphub-linux-amd64
sudo ./apps/gaganode/gaganode config set --token=gdfopujqbeyorvcn36fc158217cf675f
sudo /aanode/apphub-linux-amd64/apphub restart
sudo /aanode/apphub-linux-amd64/apps/gaganode/gaganode config set --token=gdfopujqbeyorvcn36fc158217cf675f
sudo /aanode/apphub-linux-amd64/apphub service start
sudo /aanode/apphub-linux-amd64/apphub status

echo "MSN都已安装完成.========================================================================================================================="

#并添加任务定时检查服务运行，每两个小时一次

# Cron job规则，每两个小时执行一次
cron_job="0 */2 * * * /aanode/check_apphub.sh"

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

echo "MSN添加每小时保持运行成功.========================================================================================================================="

#执行系统开机自启，注册为系统服务
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
sudo systemctl enable apphub.service
# 启动apphub服务，测试是否正常工作
sudo systemctl start apphub.service
# 查看apphub服务状态
sudo systemctl status apphub.service --no-pager
# no-pager不中断命令
echo "MSN添加开机运行成功.========================================================================================================================="
sudo /aanode/apphub-linux-amd64/apphub status
