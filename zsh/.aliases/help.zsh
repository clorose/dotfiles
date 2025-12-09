help_list() {
    local selection

    selection=$(
        fd --follow --hidden --max-depth 1 -e zsh . ~/.aliases \
            | xargs rg --no-heading --line-number -e '^[a-zA-Z0-9_-]+\(\)' -e '^alias ' \
            | fzf --delimiter=':' --with-nth=3.. \
                  --preview='bat --style=numbers --color=always {1} --line-range {2}:+10'
    ) || return

    local file=$(echo "$selection" | cut -d: -f1)
    local line=$(echo "$selection" | cut -d: -f2)
    local code=$(echo "$selection" | cut -d: -f3-)

    if [[ "$code" == alias\ * ]]; then
        # ----------------------------
        # alias → 딱 1줄만 출력
        # ----------------------------
        bat --style=numbers --color=always --line-range "$line":"$line" "$file"
    else
        # ----------------------------
        # 함수 → 10줄 출력
        # ----------------------------
        bat --style=numbers --color=always --line-range "$line":"+10" "$file"
    fi
}

help_search() {
    local keyword="$1"
    [[ -z "$keyword" ]] && echo "Usage: help_search <keyword>" && return 1
    
    local file
    file=$(
        fd --follow --hidden --max-depth 1 -e zsh "$keyword" ~/.aliases \
            | fzf --prompt="$keyword (select file) > "
    ) || return
    
    local selection
    selection=$(
        rg --with-filename --no-heading --line-number \
            -e '^[[:space:]]*[a-zA-Z0-9_-]+\(\)' \
            -e '^alias[[:space:]]+[a-zA-Z0-9_-]+=' \
            "$file" \
        | fzf --delimiter=':' --with-nth=3.. \
              --prompt="$keyword (select entry) > " \
              --preview='bat --style=numbers --color=always {1} --line-range {2}:+10'
    ) || return
    
    local target_file=$(echo "$selection" | cut -d: -f1)
    local line=$(echo "$selection" | cut -d: -f2)
    local code=$(echo "$selection" | cut -d: -f3-)
    
    if [[ "$code" == alias\ * ]]; then
        bat --style=numbers --color=always --line-range "$line":"$line" "$target_file"
    else
        # 함수 위 주석 3줄 + 함수 시작부터 10줄
        local start_line=$((line - 3 > 0 ? line - 3 : 1))
        bat --style=numbers --color=always --line-range "$start_line":"$((line + 10))" "$target_file"
    fi
}