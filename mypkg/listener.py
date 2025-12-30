#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2025 Ryusei Abe
# SPDX-License-Identifier: BSD-3-Clause

import rclpy
from rclpy.node import Node
from std_msgs.msg import Int16

rclpy.init()
node = Node("listener")

def cb(msg):
    node.get_logger().info("Listen: %d" % msg.data)

def main():
    node.create_subscription(Int16, "countup", cb, 10)
    rclpy.spin(node)

