#!/bin/bash
# SPDX-FileCopyrightText: 2026 Ryusei Abe
# SPDX-License-Identifier: BSD-3-Clause

set -euo pipefail

# ホームディレクトリ（CI / ローカル両対応）
dir=~
[ "${1:-}" != "" ] && dir="$1"

cd "$dir/ros2_ws"

# ビルド
colcon build --symlink-install --packages-select sysinfo_pub

# ------------------------------------------------------------
# 環境設定
# colcon の setup.bash / local_setup.bash は
# 未定義変数を参照するため set -u のまま source すると落ちる
# → source の瞬間だけ nounset を無効化する
# ------------------------------------------------------------
set +u
source "$dir/ros2_ws/install/setup.bash"
set -u

# ------------------------------------------------------------
# publisher 起動（ログ保持）
# ------------------------------------------------------------
timeout 60 ros2 run sysinfo_pub sysinfo_pub > /tmp/sysinfo_pub.log 2>&1 &
PUB_PID=$!

cleanup() {
  kill "$PUB_PID" 2>/dev/null || true
}
trap cleanup EXIT

# ------------------------------------------------------------
# topic が見えるまで待つ（最大30秒）
# ------------------------------------------------------------
ok=0
for i in $(seq 1 60); do
  # publisher が落ちていたらログを出して終了
  if ! kill -0 "$PUB_PID" 2>/dev/null; then
    echo "[エラー] sysinfo_pub が起動直後に終了しました"
    echo "===== /tmp/sysinfo_pub.log ====="
    cat /tmp/sysinfo_pub.log || true
    exit 1
  fi

  ros2 topic list 2>/dev/null | grep -F "/sysinfo" >/dev/null && ok=1 && break
  sleep 0.5
done

if [ "$ok" -ne 1 ]; then
  echo "[エラー] /sysinfo トピックが見つかりません"
  echo "===== ros2 node list ====="
  ros2 node list || true
  echo "===== ros2 topic list ====="
  ros2 topic list || true
  echo "===== /tmp/sysinfo_pub.log ====="
  cat /tmp/sysinfo_pub.log || true
  exit 1
fi

# ------------------------------------------------------------
# subscriber 実行（短時間）
# ------------------------------------------------------------
timeout 15 ros2 run sysinfo_pub sysinfo_sub > /tmp/sysinfo_sub.log 2>&1 || true

# ------------------------------------------------------------
# 「受信できた」ことの確認
# ------------------------------------------------------------
test -s /tmp/sysinfo_sub.log
grep -F "cpu=" /tmp/sysinfo_sub.log > /dev/null
