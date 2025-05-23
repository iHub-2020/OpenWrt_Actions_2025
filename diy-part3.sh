#!/bin/bash
#=========================================================================
# Description : OpenWrt DIY script part 3 (After Update feeds) 仅适用于R2S
# Lisence     : MIT
# Author      : Reyanmatic
# Website     : https:www.reyanmatic.com
#=========================================================================

set -e  # 有错误立即退出
# set -x  # 显示每条命令（调试用，生产可去掉）

echo "========== 开始执行 diy-part3.sh =========="

# 1. 修改主页Logo
cp -f $GITHUB_WORKSPACE/resources/logo_openwrt.png feeds/luci/themes/luci-theme-bootstrap/htdocs/luci-static/bootstrap/logo_openwrt.png
echo "[INFO] 已拷贝 logo_openwrt.png 到 luci-theme-bootstrap"

# 2. 添加主页广告滚动条
cp -f $GITHUB_WORKSPACE/resources/10_system.js feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/10_system.js
echo "[INFO] 已拷贝 10_system.js 到 luci-mod-status"

# 3. 修改主页部分描述信息（header、footer等）
cp -f $GITHUB_WORKSPACE/resources/header.ut feeds/luci/themes/luci-theme-bootstrap/ucode/template/themes/bootstrap/header.ut
echo "[INFO] 已拷贝 header.ut"
cp -f $GITHUB_WORKSPACE/resources/footer.ut feeds/luci/themes/luci-theme-bootstrap/ucode/template/themes/bootstrap/footer.ut
echo "[INFO] 已拷贝 footer.ut"

# 4. 修改主机名称
sed -i "s/hostname='.*'/hostname='Reyanmatic'/g" package/lean/default-settings/files/zzz-default-settings 2>/dev/null || true
echo "[INFO] 已修改主机名称为 Reyanmatic"

# 5. 修改SSH登录页面logo（banner）
cp -f $GITHUB_WORKSPACE/resources/banner package/base-files/files/etc/banner
echo "[INFO] 已拷贝 banner"

# 6. 追加/覆盖 R2S 专用网络配置到 zzz-default-settings（避免重复）
ZZZ_BASE="package/lean/default-settings/files/zzz-default-settings"
if [ -f "$ZZZ_BASE" ]; then
    cat >> "$ZZZ_BASE" <<'EOF'

# ===== Reyanmatic R2S Default Network Settings =====
uci set network.wan.proto='pppoe'
uci set network.wan.username=''
uci set network.wan.password=''
uci set network.wan.ifname='eth0'
uci set network.wan6.proto='DHCP'
uci set network.wan6.ifname='eth0'
uci set network.lan.ipaddr='192.168.1.198'
uci set network.lan.proto='static'
uci set network.lan.type='bridge'
uci set network.lan.ifname='eth1'
uci commit network
EOF
    echo "[INFO] 已追加R2S默认网络配置到 zzz-default-settings"
else
    echo "[WARN] 未找到 zzz-default-settings，无法追加网络配置"
fi

echo "========== diy-part3.sh 执行完成 =========="
