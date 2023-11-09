#!/system/bin/sh
if ! applypatch -c EMMC:/dev/block/platform/soc0/soc.2/by-name/recovery:6187008:03b2a33206b07eda7075f9b7d1d66a859681d295; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/platform/soc0/soc.2/by-name/boot:5623808:360168d374fa6466d017cb730a7c0dedaf341c07 EMMC:/dev/block/platform/soc0/soc.2/by-name/recovery 03b2a33206b07eda7075f9b7d1d66a859681d295 6187008 360168d374fa6466d017cb730a7c0dedaf341c07:/system/recovery-from-boot.p && echo "
Installing new recovery image: succeeded
" >> /cache/recovery/log || echo "
Installing new recovery image: failed
" >> /cache/recovery/log
else
  log -t recovery "Recovery image already installed"
fi
