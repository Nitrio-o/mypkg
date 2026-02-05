#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2026 Ryusei Abe
# SPDX-License-Identifier: BSD-3-Clause

from __future__ import annotations

import rclpy
from rclpy.node import Node
from std_msgs.msg import String


class SysinfoSubscriber(Node):
    def __init__(self) -> None:
        super().__init__("sysinfo_sub")
        self.sub = self.create_subscription(String, "sysinfo", self._cb, 10)

    def _cb(self, msg: String) -> None:
        # ログとして出す（標準出力に人間向け文を出すのを避ける）
        self.get_logger().info(msg.data)


def main() -> None:
    rclpy.init()
    node = SysinfoSubscriber()
    try:
        rclpy.spin(node)
    finally:
        node.destroy_node()
        rclpy.shutdown()

