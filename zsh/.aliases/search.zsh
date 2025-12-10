##############################################
# 🔍 FZF & macOS Utility Toolkit (FINAL)
##############################################

# --------------------------------------------
# ⚙️ Global Excludes & Project Roots
# --------------------------------------------
export FD_EXCLUDES=(
    --exclude Library
    --exclude .git
    --exclude node_modules
    --exclude .DS_Store
    --exclude dist
    --exclude build
)

export PROJECT_DIRS=(
    ~/Develop
    ~/AI
)

export FZF_PREVIEW="bat --color=always --style=numbers --line-range=:200 {} 2>/dev/null || cat {}"


# --------------------------------------------
# 📂 파일 선택 → VSCode 열기
# --------------------------------------------
# @desc: 파일 선택 후 VSCode로 열기
# @usage: fzf_code
fzf_code() {
    local file
    file=$(fd . --type f "${FD_EXCLUDES[@]}" \
        | fzf --preview "$FZF_PREVIEW") || return
    code "$file"
}

# --------------------------------------------
# 📂 파일 선택 → Finder 열기
# --------------------------------------------
# @desc: 파일 선택 후 Finder로 열기
# @usage: fzf_open
fzf_open() {
    local file
    file=$(fd . --type f "${FD_EXCLUDES[@]}" \
        | fzf --preview "$FZF_PREVIEW") || return
    open "$file"
}


# --------------------------------------------
# 📁 디렉토리 이동 (인자 사용)
# --------------------------------------------
# @desc: 시작 경로에서 디렉토리 선택 후 이동
# @usage: fzfcd [path]
# @example: fzfcd ~/Develop
fzfcd() {
    local start_path="${1:-~}"
    local dir
    dir=$(fd . --type d "${FD_EXCLUDES[@]}" "$start_path" \
        | fzf --preview "eza --tree --level=2 --color=always {} 2>/dev/null") || return
    cd "$dir" || return
}

# --------------------------------------------
# 📁 프로젝트 빠른 이동
# --------------------------------------------
# @desc: PROJECT_DIRS 안에서 프로젝트 선택 후 이동
# @usage: fzf_project
fzf_project() {
    local dir
    dir=$(fd . --type d --max-depth 2 "${FD_EXCLUDES[@]}" "${PROJECT_DIRS[@]}" \
        | fzf --preview "eza --tree --level=2 --color=always {} 2>/dev/null") || return
    cd "$dir" || return
}


# --------------------------------------------
# 🧭 최근 방문 디렉토리 이동
# --------------------------------------------
# @desc: 최근 방문 디렉토리 선택 후 이동 (zoxide)
# @usage: fzf_recent_dir
fzf_recent_dir() {
    local dir
    dir=$(zoxide query -l \
        | fzf --preview "eza --tree --level=2 --color=always {} 2>/dev/null") || return
    cd "$dir" || return
}


# --------------------------------------------
# 🧹 대용량 폴더 확인
# --------------------------------------------
# @desc: Library에서 대용량 폴더 확인
# @usage: findbig
findbig() {
    du -ah ~/Library/Application\ Support ~/Library/Caches 2>/dev/null \
        | sort -hr \
        | head -n 20
}


# --------------------------------------------
# 🗑️ 앱 잔여 파일 검색 (Library 전용)
# --------------------------------------------
# @desc: 앱 이름으로 잔여 파일 검색 (~/Library)
# @usage: findapp <app-name>
# @example: findapp Chrome
findapp() {
    [[ -z "$1" ]] && echo "❗ Usage: findapp <app-name>" && return 1
    local keyword="$1"

    echo "📁 Application Support:"
    fd -i "$keyword" ~/Library/Application\ Support 2>/dev/null || echo "  (없음)"

    echo "\n📁 Caches:"
    fd -i "$keyword" ~/Library/Caches 2>/dev/null || echo "  (없음)"

    echo "\n📁 Preferences:"
    fd -i "$keyword" ~/Library/Preferences 2>/dev/null || echo "  (없음)"

    echo "\n📁 Containers:"
    fd -i "$keyword" ~/Library/Containers 2>/dev/null || echo "  (없음)"

    echo "\n📁 Saved Application State:"
    fd -i "$keyword" ~/Library/Saved\ Application\ State 2>/dev/null || echo "  (없음)"
}