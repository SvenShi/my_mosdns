## 本配置用于Linux中运行mosdns配置来源于OpenWrt插件luci-app-mosdns提供相同功能，不过需要自己编辑config文件。

- 工作目录为`/opt/mosdns`
- `v2dat`文件需要放到`/usr/bin`中并赋予执行权限
- `update_mosdns_data.sh`为定时执行脚本，可用命令`crontab -e`定时执行更新规则
