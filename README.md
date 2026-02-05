# sysinfo_pub (ROS 2 package)

## 概要

`sysinfo_pub` は、ROS 2 上で動作するシステム情報配信ノードを提供するパッケージです。  
ノードは ROS 2 のトピック通信を用いて、実行環境のシステム情報を定期的に publish します。

ROS 2 における Publisher / Subscriber モデルを用いた通信例として、
システム情報の取得と配信を行います。

---

## 提供するノード

### sysinfo_pub

**機能**

- 実行環境のシステム情報を取得
- 取得した情報を ROS 2 のトピックとして publish

**使用する通信方式**

- トピック通信（Publisher）

**トピック名**

- `/sysinfo`

**publish 内容（例）**

- OS 情報
- CPU 情報
- メモリ使用状況

---

## 実行方法

```bash
$ ros2 run sysinfo_pub sysinfo_pub
