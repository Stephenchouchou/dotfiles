#!/usr/bin/env bash
# =============================================================
# workspace-assign.sh — 根據 docked/undocked 自動分配 workspace
# 由 kanshi exec 呼叫，不需手動執行
# =============================================================
set -euo pipefail

MODE="${1:-undocked}"
LAPTOP="eDP-1"

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

        notify-send -t 3000 "Docked Mode" \
            "LEFT=$LEFT  CENTER=$CENTER  RIGHT=$RIGHT"
    else
        notify-send -u critical -t 5000 "Docked Mode Error" \
            "無法辨識所有螢幕: L=$LEFT C=$CENTER R=$RIGHT"
    fi

else
    # Undocked: 所有 workspace 回到筆電螢幕
    for ws in $(seq 1 10); do
        assign_workspace "$ws" "$LAPTOP"
    done

    hyprctl dispatch workspace 1
    notify-send -t 3000 "Undocked Mode" "筆電螢幕模式"
fi
