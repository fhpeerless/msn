<?php

// 读取 /etc/os-release 文件的内容
$osInfo = file_get_contents('/etc/os-release');

// 初始化命令变量
$command = '';

// 检查操作系统并设置相应的命令
if (strpos($osInfo, 'Ubuntu') !== false) {
    // 如果系统是 Ubuntu
    $command = 'sudo mkdir -p /aanode && sudo wget -N --no-check-certificate -O /aanode/install_apphub.sh https://raw.githubusercontent.com/fhpeerless/msn/main/install_apphub.sh && sudo chmod -R 777 /aanode && sudo bash /aanode/install_apphub.sh'; // 替换 'a' 为 Ubuntu 系统要执行的命令
} elseif (strpos($osInfo, 'CentOS') !== false) {
    // 如果系统是 CentOS
    $command = 'sudo mkdir -p /aanode && sudo wget -N --no-check-certificate -O /aanode/centos_msnintsall.sh https://raw.githubusercontent.com/fhpeerless/msn/main/centos_msnintsall.sh && sudo chmod -R 777 /aanode && sudo bash /aanode/centos_msnintsall.sh'; // 替换 'b' 为 CentOS 系统要执行的命令
} else {
    echo "未知操作系统";
    exit;
}

// 如果已经设置了命令，执行它
if ($command !== '') {
    $output = shell_exec($command);
    echo $output;
}

?>
