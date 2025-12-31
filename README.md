# sysinfo_pub（ROS 2 パッケージ）

![test](https://github.com/Nitrio-o/sysinfo_pub/actions/workflows/test.yml/badge.svg)

## 概要

sysinfo_pub は、ROS 2 上で動作するシステム情報配信ノードを提供するパッケージです。  
ノードは ROS 2 のトピック通信を用いて、取得したシステム情報を定期的に publish します。

本パッケージは、講義「ロボットシステム学」における  
ROS 2 のトピック通信（Publisher / Subscriber）の理解を目的として作成しました。

---

## 提供するノード

### sysinfo_pub ノード

- 機能  
  実行環境のシステム情報を取得し、ROS 2 のトピックとして定期的に publish します。

- 使用する通信方式  
  - トピック通信（Publisher）

- トピック名  
  - `/sysinfo`

- メッセージ型  
  - `std_msgs/msg/String`

- publish 内容（例）  
  - OS 情報  
  - CPU 情報  
  - メモリ使用状況  

---

## 実行方法

### ノードの起動

```bash
ros2 run sysinfo_pub sysinfo_pub

## 動作環境

- Ubuntu 24.04 LTS
- ROS 2
- Python 3.7〜3.10（GitHub Actions でテスト済）

---

## テスト

GitHub Actions により以下のテストを自動実行しています。

- 正常入力時に正しい平均値が出力されること
- 異常入力時に終了ステータスが 1 になること

---

## ライセンスおよび著作権表示

- 本ソフトウェアパッケージは 3 条項 BSD ライセンスの下で、
  再頒布および使用が許可されています。
- 本パッケージのコードは、ロボットシステム学の講義資料を参考にして作成されています。
- 講義資料は Creative Commons Attribution-ShareAlike 4.0
  (CC-BY-SA 4.0) に基づいて公開されています。

参考資料:
- https://github.com/ryuichiueda/my_slides/tree/master/robosys_2025

---

© 2025 Ryusei Abe
