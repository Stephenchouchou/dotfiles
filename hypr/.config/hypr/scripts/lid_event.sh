#!/bin/bash

LAPTOP_MONITOR="eDP-1"  # 替換成您的筆電螢幕名稱
EXTERNAL_MONITOR="HDMI-A-2" # 替換成您的 HDMI 螢幕名稱

if [ "$1" == "closed" ]; then
    # 關閉筆電螢幕時
    # 停用筆電螢幕
    hyprctl keyword monitor "$LAPTOP_MONITOR, disable"
    # 將所有工作區移動到外接螢幕 (這一步通常會自動發生，但可以強制執行)
    # 這裡的命令是將目前工作區移到指定螢幕
    hyprctl dispatch movecurrentworkspacetomonitor "$EXTERNAL_MONITOR"

elif [ "$1" == "open" ]; then
    # 打開筆電螢幕時
    # 重新啟用筆電螢幕
    hyprctl keyword monitor "$LAPTOP_MONITOR, preferred, auto, 1"
    # 您可能需要設定工作區的擺放位置，例如將某個工作區綁定回筆電螢幕
    # hyprctl dispatch workspace 1
fi

