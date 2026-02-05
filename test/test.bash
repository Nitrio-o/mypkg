#!/bin/bash
# SPDX-FileCopyrightText: 2026 Ryusei Abe
# SPDX-License-Identifier: BSD-3-Clause

set -e

dir=~
[ "${1:-}" != "" ] && dir="$1"

cd "$dir/ros2_ws"
colcon build --symlink-install --packages-select sysinfo_pub
source "$dir/ros2_ws/install/setup.bash"

# publisher 起動（バックグラウンド）
timeout 8 ros2 run sysinfo_pub sysinfo_pub > /tmp/sysinfo_pub.log 2>&1 &
PUB_PID=$!

# topic が存在する（通信を使っていることの証拠）
timeout 8 ros2 topic list > /tmp/topic_list.log 2>&1 || true
grep -F "/sysinfo" /tmp/topic_list.log > /dev/null

# subscriber を起動してログが出る（ログ形式には依存しない）
timeout 8 ros2 run sysinfo_pub sysinfo_sub > /tmp/sysinfo_sub.log 2>&1 || true
test -s /tmp/sysinfo_sub.log

# 後片付け
kill "$PUB_PID" 2>/dev/null || true

