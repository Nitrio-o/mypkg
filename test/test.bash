#!/bin/bash
# SPDX-FileCopyrightText: 2026 Ryusei Abe
# SPDX-License-Identifier: BSD-3-Clause

set -e

dir=~
[ "${1:-}" != "" ] && dir="$1"

cd "$dir/ros2_ws"
colcon build --symlink-install --packages-select sysinfo_pub
source "$dir/ros2_ws/install/setup.bash"

# publisher 起動
timeout 20 ros2 run sysinfo_pub sysinfo_pub > /tmp/sysinfo_pub.log 2>&1 &
PUB_PID=$!

# topic が見えるまで待つ（最大10秒）
ok=0
for i in $(seq 1 20); do
  ros2 topic list 2>/dev/null | grep -F "/sysinfo" >/dev/null && ok=1 && break
  sleep 0.5
done
test "$ok" -eq 1

# subscriber をバックグラウンドで起動して受信ログを取る
: > /tmp/sysinfo_sub.log
timeout 20 ros2 run sysinfo_pub sysinfo_sub >> /tmp/sysinfo_sub.log 2>&1 &
SUB_PID=$!

# cpu= がログに出るまで待つ（最大10秒）
ok=0
for i in $(seq 1 20); do
  grep -F "cpu=" /tmp/sysinfo_sub.log >/dev/null && ok=1 && break
  sleep 0.5
done
test "$ok" -eq 1

# 後片付け
kill "$SUB_PID" 2>/dev/null || true
kill "$PUB_PID" 2>/dev/null || true
