#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2026 Ryusei Abe
# SPDX-License-Identifier: BSD-3-Clause

from __future__ import annotations

import shutil
import time

import rclpy
from rclpy.node import Node
from rclpy.parameter import Parameter
from std_msgs.msg import String
from std_srvs.srv import Trigger


def _read_cpu_usage_percent() -> float:
    """Return CPU usage percentage using /proc/stat (Linux)."""
    def read():
        with open("/proc/stat", "r", encoding="utf-8") as f:
            line = f.readline()
        fields = line.split()
        # fields[0] == "cpu"
        nums = list(map(int, fields[1:]))
        total = sum(nums)
        idle = nums[3] + (nums[4] if len(nums) > 4 else 0)  # idle + iowait
        return total, idle

    t1, i1 = read()
    time.sleep(0.1)
    t2, i2 = read()
    dt = t2 - t1
    di = i2 - i1
    if dt <= 0:
        return 0.0
    return max(0.0, min(100.0, (1.0 - di / dt) * 100.0))


def _read_mem_usage_percent() -> float:
    """Return memory usage percentage using /proc/meminfo (Linux)."""
    mem_total = None
    mem_available = None
    with open("/proc/meminfo", "r", encoding="utf-8") as f:
        for line in f:
            if line.startswith("MemTotal:"):
                mem_total = int(line.split()[1])  # kB
            elif line.startswith("MemAvailable:"):
                mem_available = int(line.split()[1])  # kB
            if mem_total is not None and mem_available is not None:
                break
    if not mem_total:
        return 0.0
    used = mem_total - (mem_available or 0)
    return max(0.0, min(100.0, used / mem_total * 100.0))


def _read_disk_usage_percent(path: str) -> float:
    """Return disk usage percentage using shutil.disk_usage()."""
    usage = shutil.disk_usage(path)
    if usage.total <= 0:
        return 0.0
    return max(0.0, min(100.0, usage.used / usage.total * 100.0))


class SysinfoPublisher(Node):
    def __init__(self) -> None:
        super().__init__("sysinfo_pub")

        self.declare_parameter("publish_hz", 1.0)
        self.declare_parameter("disk_path", "/")

        self.pub = self.create_publisher(String, "sysinfo", 10)
        self.srv = self.create_service(Trigger, "sysinfo_snapshot", self._on_snapshot)

        hz = float(self.get_parameter("publish_hz").value)
        period = 1.0 / hz if hz > 0.0 else 1.0
        self.timer = self.create_timer(period, self._on_timer)

        self.get_logger().info("sysinfo_pub started")

    def _make_message(self) -> str:
        disk_path = str(self.get_parameter("disk_path").value)

        cpu = _read_cpu_usage_percent()
        mem = _read_mem_usage_percent()
        disk = _read_disk_usage_percent(disk_path)

        return f"cpu={cpu:.1f} mem={mem:.1f} disk={disk:.1f} disk_path={disk_path}"

    def _publish_once(self) -> str:
        text = self._make_message()
        msg = String()
        msg.data = text
        self.pub.publish(msg)
        return text

    def _on_timer(self) -> None:
        self._publish_once()

    def _on_snapshot(self, request: Trigger.Request, response: Trigger.Response) -> Trigger.Response:
        _ = request
        text = self._publish_once()
        response.success = True
        response.message = text
        return response


def main() -> None:
    rclpy.init()
    node = SysinfoPublisher()
    try:
        rclpy.spin(node)
    finally:
        node.destroy_node()
        rclpy.shutdown()

