#!/usr/bin/env bash
# =============================================================
# workspace-assign.sh — 根據 docked/undocked 自動分配 workspace
#                       並重啟 waybar（動態產生 per-monitor 設定）
# 由 kanshi exec 呼叫，不需手動執行
# =============================================================
set -euo pipefail

MODE="${1:-undocked}"
LAPTOP="eDP-1"
WAYBAR_CFG_DIR="$HOME/.config/waybar"
WAYBAR_DYNAMIC_DIR="$WAYBAR_CFG_DIR/dynamic"

# 等待 Hyprland 完成 output 切換（避免 race condition）
sleep 1.5

# 動態取得外接螢幕名稱（因為 Thunderbolt 端口名會變）
# 排除 eDP-1，剩下的就是外接螢幕
get_external_monitors() {
    hyprctl monitors -j | python3 -c "
import json, sys
monitors = json.load(sys.stdin)
for m in monitors:
    if m['name'] != 'eDP-1' and not m.get('disabled', False):
        # 輸出: name width height x transform
        print(f\"{m['name']} {m['width']} {m['height']} {m['x']} {m.get('transform', 0)}\")
" 2>/dev/null
}

# ---- Waybar 重啟邏輯 ----
# 產生完整 bar 設定（主螢幕用）
gen_full_bar() {
    local output="$1"
    cat <<EOBAR
{
  "output": "$output",
  "height": 30,
  "spacing": 4,
  "modules-left": ["hyprland/workspaces"],
  "modules-center": ["hyprland/window"],
  "modules-right": [
    "idle_inhibitor",
    "pulseaudio",
    "network",
    "power-profiles-daemon",
    "cpu",
    "memory",
    "temperature",
    "backlight",
    "battery",
    "clock",
    "tray",
    "custom/power"
  ],
  "idle_inhibitor": { "format": "{icon}", "format-icons": { "activated": "", "deactivated": "" } },
  "tray": { "spacing": 10 },
  "clock": { "tooltip-format": "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>", "format-alt": "{:%Y-%m-%d}" },
  "cpu": { "format": "{usage}% ", "tooltip": false },
  "memory": { "format": "{}% " },
  "temperature": { "critical-threshold": 80, "format": "{temperatureC}°C {icon}", "format-icons": ["", "", ""] },
  "backlight": { "format": "{percent}% {icon}", "format-icons": ["", "", "", "", "", "", "", "", ""] },
  "battery": { "states": { "warning": 30, "critical": 15 }, "format": "{capacity}% {icon}", "format-full": "{capacity}% {icon}", "format-charging": "{capacity}% ", "format-plugged": "{capacity}% ", "format-alt": "{time} {icon}", "format-icons": ["", "", "", "", ""] },
  "power-profiles-daemon": { "format": "{icon}", "tooltip-format": "Power profile: {profile}\nDriver: {driver}", "tooltip": true, "format-icons": { "default": "", "performance": "", "balanced": "", "power-saver": "" } },
  "network": { "format-wifi": "{essid} ({signalStrength}%) ", "format-ethernet": "{ipaddr}/{cidr} ", "tooltip-format": "{ifname} via {gwaddr} ", "format-linked": "{ifname} (No IP) ", "format-disconnected": "Disconnected ⚠", "format-alt": "{ifname}: {ipaddr}/{cidr}" },
  "pulseaudio": { "format": "{volume}% {icon} {format_source}", "format-bluetooth": "{volume}% {icon} {format_source}", "format-bluetooth-muted": " {icon} {format_source}", "format-muted": " {format_source}", "format-source": "{volume}% ", "format-source-muted": "", "format-icons": { "headphone": "", "hands-free": "", "headset": "", "phone": "", "portable": "", "car": "", "default": ["", "", ""] }, "on-click": "pavucontrol" },
  "custom/power": { "format": "⏻ ", "tooltip": false, "menu": "on-click", "menu-file": "$HOME/.config/waybar/power_menu.xml", "menu-actions": { "shutdown": "shutdown", "reboot": "reboot", "suspend": "systemctl suspend", "hibernate": "systemctl hibernate" } }
}
EOBAR
}

# 產生精簡 bar 設定（副螢幕用，只有 workspaces）
gen_minimal_bar() {
    local output="$1"
    cat <<EOBAR
{
  "output": "$output",
  "height": 30,
  "spacing": 4,
  "modules-left": ["hyprland/workspaces"],
  "modules-center": [],
  "modules-right": []
}
EOBAR
}

restart_waybar() {
    # 殺掉所有 waybar 並等待
    killall waybar 2>/dev/null || true
    sleep 0.5

    mkdir -p "$WAYBAR_DYNAMIC_DIR"
    # 清除舊的動態設定
    rm -f "$WAYBAR_DYNAMIC_DIR"/*.jsonc

    # 根據傳入的參數產生設定並啟動 waybar
    # 用法: restart_waybar <primary_monitor> [secondary_monitor ...]
    local primary="$1"; shift
    local cfg="$WAYBAR_DYNAMIC_DIR/config-${primary}.jsonc"
    gen_full_bar "$primary" > "$cfg"
    waybar -c "$cfg" &

    for mon in "$@"; do
        cfg="$WAYBAR_DYNAMIC_DIR/config-${mon}.jsonc"
        gen_minimal_bar "$mon" > "$cfg"
        waybar -c "$cfg" &
    done
}

assign_workspace() {
    local ws="$1" monitor="$2"
    hyprctl dispatch moveworkspacetomonitor "$ws" "$monitor" 2>/dev/null || true
}

if [[ "$MODE" == "docked" ]]; then
    # 解析外接螢幕，按 x position 排序（左到右）
    LEFT=""
    CENTER=""
    RIGHT=""

    while IFS=' ' read -r name width height xpos transform; do
        # 用 transform 判斷直立螢幕（transform=1 為 90°）
        if [[ "$transform" == "1" || "$transform" == "3" ]]; then
            LEFT="$name"
        elif [[ "$width" -ge 3000 ]]; then
            # 高解析度 = 主螢幕
            CENTER="$name"
        else
            RIGHT="$name"
        fi
    done < <(get_external_monitors)

    # Fallback: 如果上面的啟發式判斷失敗，用 x position 排序
    if [[ -z "$LEFT" || -z "$CENTER" || -z "$RIGHT" ]]; then
        mapfile -t SORTED < <(get_external_monitors | sort -t' ' -k4 -n)
        [[ -z "$LEFT" ]] && LEFT=$(echo "${SORTED[0]:-}" | cut -d' ' -f1)
        [[ -z "$CENTER" ]] && CENTER=$(echo "${SORTED[1]:-}" | cut -d' ' -f1)
        [[ -z "$RIGHT" ]] && RIGHT=$(echo "${SORTED[2]:-}" | cut -d' ' -f1)
    fi

    if [[ -n "$LEFT" && -n "$CENTER" && -n "$RIGHT" ]]; then
        # 中螢幕（主）: workspace 1-6
        assign_workspace 1 "$CENTER"
        assign_workspace 2 "$CENTER"
        assign_workspace 3 "$CENTER"
        assign_workspace 4 "$CENTER"
        assign_workspace 5 "$CENTER"
        assign_workspace 6 "$CENTER"

        # 左螢幕（直立）: workspace 7-8
        assign_workspace 7 "$LEFT"
        assign_workspace 8 "$LEFT"

        # 右螢幕: workspace 9-10
        assign_workspace 9 "$RIGHT"
        assign_workspace 10 "$RIGHT"

        # 聚焦到主螢幕 workspace 1
        hyprctl dispatch workspace 1

        # 重啟 waybar：主螢幕完整 bar，左右螢幕精簡 bar
        restart_waybar "$CENTER" "$LEFT" "$RIGHT"

        notify-send -t 3000 "Docked Mode" \
            "LEFT=$LEFT  CENTER=$CENTER  RIGHT=$RIGHT"
    else
        notify-send -u critical -t 5000 "Docked Mode Error" \
            "無法辨識所有螢幕: L=$LEFT C=$CENTER R=$RIGHT"
    fi

elif [[ "$MODE" == "docked-single-4k" ]]; then
    # Docked-single-4k: 取得外接螢幕名稱
    EXT_MON=""
    while IFS=' ' read -r name width height xpos transform; do
        EXT_MON="$name"
    done < <(get_external_monitors)

    if [[ -n "$EXT_MON" ]]; then
        # 外接螢幕: workspace 1-8
        for ws in $(seq 1 8); do
            assign_workspace "$ws" "$EXT_MON"
        done
        # 筆電螢幕: workspace 9-10
        assign_workspace 9 "$LAPTOP"
        assign_workspace 10 "$LAPTOP"

        hyprctl dispatch workspace 1

        # 重啟 waybar：外接螢幕完整 bar，筆電精簡 bar
        restart_waybar "$EXT_MON" "$LAPTOP"

        notify-send -t 3000 "Docked Single 4K" \
            "EXT=$EXT_MON  LAPTOP=$LAPTOP"
    else
        notify-send -u critical -t 5000 "Docked Single 4K Error" \
            "找不到外接螢幕"
    fi

else
    # Undocked: 所有 workspace 回到筆電螢幕
    for ws in $(seq 1 10); do
        assign_workspace "$ws" "$LAPTOP"
    done

    hyprctl dispatch workspace 1

    # 重啟 waybar：筆電螢幕完整 bar
    restart_waybar "$LAPTOP"

    notify-send -t 3000 "Undocked Mode" "筆電螢幕模式"
fi
