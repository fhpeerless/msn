<?php

// 读取 /etc/os-release 文件的内容
$osReleaseContent = file_get_contents('/etc/os-release');

// 初始化命令变量
$command = '';

// 检查操作系统并设置相应的命令
if (strpos($osReleaseContent, 'Ubuntu') !== false) {
    // 如果系统是 Ubuntu
    $command = 'a'; // 替换 'a' 为 Ubuntu 系统要执行的命令
} elseif (strpos($osReleaseContent, 'CentOS') !== false) {
    // 如果系统是 CentOS
    $command = 'b'; // 替换 'b' 为 CentOS 系统要执行的命令
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
