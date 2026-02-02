#!/bin/bash

# 啟動 awww-daemon（若尚未啟動）
pgrep awww-daemon > /dev/null || awww-daemon &

# 暫存資料夾
tmp_base="/tmp/awww-per-monitor"
rm -rf "$tmp_base"
mkdir -p "$tmp_base"

# 用來避免重複圖片
declare -A used_images

# 取得所有啟用中的螢幕名稱
monitors=$(hyprctl monitors -j | jq -r '.[].name')

for monitor in $monitors; do
    echo "🖥️ 正在處理螢幕：$monitor"

    # 取得螢幕寬高
    transform=$(hyprctl monitors -j | jq -r ".[] | select(.name==\"$monitor\") | .transform")

if [ "$transform" -eq 1 ] || [ "$transform" -eq 3 ]; then
    folder="$HOME/Wallpaper/vertical"
else
    folder="$HOME/Wallpaper/horizontal"
fi

    echo "📂 使用資料夾：$folder"

    # 檢查資料夾是否存在
    if [ ! -d "$folder" ]; then
        echo "[❌] 資料夾不存在：$folder"
        continue
    fi

    # 安全抓圖片清單（處理空格、特殊字元）
    mapfile -d '' -t available_images < <(find "$folder" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) -print0)

    # 沒圖片就跳過
    if [ "${#available_images[@]}" -eq 0 ]; then
        echo "[⚠️] 資料夾內找不到圖片：$folder"
        continue
    fi

    # 洗牌並選一張未用過的圖片
    shuffled=($(printf '%s\0' "${available_images[@]}" | shuf -z | xargs -0 -n1))
    selected=""

    for img in "${shuffled[@]}"; do
        if [[ -z "${used_images[$img]}" && -f "$img" ]]; then
            used_images["$img"]=1
            selected="$img"
            break
        fi
    done

    # 確認選到圖片
    if [ -z "$selected" ]; then
        echo "[⚠️] 沒有選到圖片，跳過 $monitor"
        continue
    fi

    echo "✅ 選到圖片：$selected"

    # 建立 temp 資料夾並複製
    tmp_dir="$tmp_base/$monitor"
    mkdir -p "$tmp_dir"

    # 執行 awww-random 套用
    awww img --outputs "$monitor" "$selected"
done

