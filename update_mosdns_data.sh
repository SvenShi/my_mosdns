#!/bin/bash

# 设置代理地址、账号和密码
PROXY="http://Clash:ao3GnQ7R@172.31.0.1:7890"

# 临时目录
TMPDIR=$(mktemp -d) || exit 1
TARGET_DIR="/opt/mosdns/dat"

# 下载和校验 geoip.dat
geoip_type=$(uci -q get mosdns.config.geoip_type || echo "geoip-only-cn-private")
echo "Downloading geoip.dat..."
curl -x $PROXY --connect-timeout 5 -m 120 --ipv4 -kfSLo "$TMPDIR/geoip.dat" "https://github.com/Loyalsoldier/geoip/releases/latest/download/$geoip_type.dat" || { rm -rf "$TMPDIR"; exit 1; }

echo "Downloading geoip.dat.sha256sum..."
curl -x $PROXY --connect-timeout 5 -m 20 --ipv4 -kfSLo "$TMPDIR/geoip.dat.sha256sum" "https://github.com/Loyalsoldier/geoip/releases/latest/download/$geoip_type.dat.sha256sum" || { rm -rf "$TMPDIR"; exit 1; }

# 校验文件
if [ "$(sha256sum "$TMPDIR/geoip.dat" | awk '{print $1}')" != "$(cat "$TMPDIR/geoip.dat.sha256sum" | awk '{print $1}')" ]; then
    echo -e "\e[1;31mgeoip.dat checksum error"
    rm -rf "$TMPDIR"
    exit 1
fi

# 下载和校验 geosite.dat
echo "Downloading geosite.dat..."
curl -x $PROXY --connect-timeout 5 -m 120 --ipv4 -kfSLo "$TMPDIR/geosite.dat" "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat" || { rm -rf "$TMPDIR"; exit 1; }

echo "Downloading geosite.dat.sha256sum..."
curl -x $PROXY --connect-timeout 5 -m 20 --ipv4 -kfSLo "$TMPDIR/geosite.dat.sha256sum" "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat.sha256sum" || { rm -rf "$TMPDIR"; exit 1; }

# 校验文件
if [ "$(sha256sum "$TMPDIR/geosite.dat" | awk '{print $1}')" != "$(cat "$TMPDIR/geosite.dat.sha256sum" | awk '{print $1}')" ]; then
    echo -e "\e[1;31mgeosite.dat checksum error"
    rm -rf "$TMPDIR"
    exit 1
fi

# 创建目标目录并解包数据
mkdir -p $TARGET_DIR
echo "Unpacking geoip.dat..."
v2dat unpack geoip -o $TARGET_DIR -f cn "$TMPDIR/geoip.dat"
echo "Unpacking geosite.dat..."
v2dat unpack geosite -o $TARGET_DIR -f cn -f apple -f 'geolocation-!cn' "$TMPDIR/geosite.dat"

# 删除下载的 .dat 和 .sha256sum 文件
rm -f "$TARGET_DIR"/*.dat
rm -f "$TARGET_DIR"/*.sha256sum

# 删除临时目录
rm -rf "$TMPDIR"

# 显示完成信息
echo "Data has been successfully downloaded, unpacked, and moved to $TARGET_DIR"
systemctl restart mosdns
