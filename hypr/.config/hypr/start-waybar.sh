#!/bin/bash
# 初始啟動 waybar — 委託給 workspace-assign.sh
# kanshi 會在偵測到正確 profile 後自動切換並重啟 waybar
# 這裡先用 undocked 模式啟動，確保至少有 bar 可用
~/.config/kanshi/workspace-assign.sh undocked
