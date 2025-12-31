cat << 'EOF' > README.md
# mean コマンド

![test](https://github.com/Nitrio-o/mypkg/actions/workflows/test.yml/badge.svg)

## 概要

mean は、標準入力から読み込んだ数値データの平均値を計算し、
結果を標準出力に出力する ROS 2 向けのフィルタ型コマンドです。

数値は改行区切りで入力することを想定しています。

---

## 使い方

### 基本的な使い方

    seq 5 | mean

### 出力例

    3.0

---

## 仕様

- 入力  
  標準入力（数値、改行区切り）

- 出力  
  標準出力（平均値のみ）

- 異常系  
  数値でない入力、または無入力の場合は  
  標準エラー出力にエラーメッセージを出し、  
  終了ステータス 1 で終了します

---

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
EOF

