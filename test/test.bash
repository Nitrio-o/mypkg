#!/bin/bash
# SPDX-FileCopyrightText: 2026 Ryusei Abe
# SPDX-License-Identifier: BSD-3-Clause

set -e

dir=~
[ "${1:-}" != "" ] && dir="$1"

cd "$dir/ros2_ws"
colcon build --symlink-install --packages-select sysinfo_pub
source "$dir/ros2_ws/install/setup.bash"

# 10秒動かしてログを採取（講義と同じ）
timeout 10 ros2 run sysinfo_pub sysinfo_pub > /tmp/sysinfo_pub.log 2>&1 &
PUB_PID=$!

# sub を起動して受信ログを採取
timeout 10 ros2 run sysinfo_pub sysinfo_sub > /tmp/sysinfo_sub.log 2>&1 || true

# 「受信できた」ことの証明：cpu= と mem= が含まれる行が1つ以上ある
grep -E "cpu=.*mem=.*disk=" /tmp/sysinfo_sub.log > /dev/null

# 後片付け
kill "$PUB_PID" 2>/dev/null || true

