#!/bin/bash

CFG_PATH="$HOME/.config/waybar"

monitors_json=$(hyprctl monitors -j 2>/dev/null)
if ! echo "$monitors_json" | jq empty >/dev/null 2>&1; then
    echo "❌ 無效的 JSON，Hyprland 尚未就緒"
    exit 1
fi

echo "$monitors_json" | jq -r '.[].name' | while read -r name; do
    config="$CFG_PATH/config-${name}.jsonc"
    if [[ -f "$config" ]]; then
        echo "🖥️  啟動 Waybar on $name 使用 $config"
        WAYBAR_OUTPUT="$name" waybar -c "$config" -l info &
    else
        echo "⚠️  找不到設定檔 $config，跳過 $name"
    fi
done

