## 个人备忘，顺便分享

### 本配置作用为将openwrt插件的mosdns迁移到Liunx中运行，提供相同功能。

- 默认工作目录为`/opt/mosdns`
- https://github.com/IrineSistiana/mosdns 下载mosdns v5并替换mosdns文件

### 定时更新国内ip

- `v2dat`文件放到`/usr/bin`中并赋予执行权限
- `update_mosdns_data.sh`为定时执行脚本
- 用命令`crontab -e`定时执行更新规则
- 定时更新每日凌晨4点 脚本中设置了openclash的代理 需要修改或者删除
``` 
0 4 * * * /opt/mosdns/update_mosdns_data.sh
```


### 安装为服务
``` shell
cd /opt/mosdns
./mosdns service install -d /opt/mosdns/ -c /opt/mosdns/config.yaml
```

### 等价配置插件配置

并发线程部分针对国内外有不同配置，另外附加了匹配域名走指定dns的功能
![alt text](img/image.png)
![alt text](img/image-2.png)
![alt text](img/image-1.png)