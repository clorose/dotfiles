##############################################
# 🌲 Global exclude (macOS Library 전체 제외)
##############################################
export FD_EXCLUDES=(
    --exclude ~/Library
)

##############################################
# 📁 프로젝트 디렉토리 목록
##############################################
export PROJECT_DIRS=(
    ~/Develop
    ~/AI
)

##############################################
# 🔍 FZF TOOLKIT (기능 중심)
##############################################

# 공통 프리뷰 옵션 (bat 없으면 cat)
export FZF_PREVIEW="bat --color=always --style=numbers --line-range=:200 {} || cat {}"

##############################################
# 1) 파일 선택 → VSCode로 열기
##############################################
# @desc: 파일 선택 후 VSCode로 열기
# @usage: fzf_code
fzf_code() {
    local file
    file=$(fd . --type f "${FD_EXCLUDES[@]}" \
        | fzf --preview "$FZF_PREVIEW") || return
    code "$file"
}

##############################################
# 2) 파일 선택 → Finder로 열기
##############################################
# @desc: 파일 선택 후 Finder로 열기
# @usage: fzf_open
fzf_open() {
    local file
    file=$(fd . --type f "${FD_EXCLUDES[@]}" \
        | fzf --preview "$FZF_PREVIEW") || return
    open "$file"
}

##############################################
# 3) 디렉토리 선택 → 이동
##############################################
# @desc: 디렉토리 선택 후 이동 (기본: 홈 디렉토리)
# @usage: fzfcd [시작경로]
# @example: fzfcd ~/Projects
fzfcd() {
    local start_path="${1:-~}"
    local dir
    dir=$(fd . --type d "${FD_EXCLUDES[@]}" "$start_path" \
        | fzf --preview "eza --tree --level=2 --color=always {} 2>/dev/null") || return
    cd "$dir"
}

##############################################
# 4) 프로젝트 디렉토리 빠른 이동
##############################################
# @desc: 주로 사용하는 디렉토리 범위 내에서 프로젝트 선택 후 이동
# @usage: fzf_project
fzf_project() {
    local dir
    dir=$(fd . --type d --max-depth 2 \
        --exclude node_modules \
        --exclude .git \
        --exclude dist \
        --exclude build \
        "${PROJECT_DIRS[@]}" 2>/dev/null \
        | fzf --preview "eza --tree --level=2 --color=always --ignore-glob='node_modules|.git' {} 2>/dev/null") || return
    cd "$dir"
}

##############################################
# 5) 최근 방문한 디렉토리 선택 → 이동 (zsh-z 기반)
##############################################
# @desc: 최근 방문한 디렉토리 선택 후 이동
# @usage: fzf_recent_dir
fzf_recent_dir() {
    local dir
    dir=$(z | awk '{print $2}' \
        | fzf --preview "eza --tree --level=2 --color=always {} 2>/dev/null") || return
    cd "$dir"
}

##############################################
# 6) 대용량 폴더 빠른 확인 (Library 전용)
##############################################
# @desc: 대용량 폴더 확인 (~/Library)
# @usage: findbig
findbig() {
    du -ah ~/Library/Application\ Support ~/Library/Caches 2>/dev/null \
        | sort -hr \
        | head -n 30
}

##############################################
# 7) 앱 잔여 파일 검색 (Library 전용)
##############################################
# @desc: 앱 잔여 파일 검색 (~/Library)
# @usage: findapp <app-name>
# @example: findapp Chrome
findapp() {
    if [[ -z "$1" ]]; then
        echo "❗ 사용법: findapp <app-name>"
        return 1
    fi
    
    local keyword="$1"
    
    echo "📁 Containers:"
    fd -i "$keyword" ~/Library/Containers

    echo "\n📁 Application Support:"
    fd -i "$keyword" ~/Library/Application\ Support --exclude "Google/Chrome"

    echo "\n📁 Preferences:"
    fd -i "$keyword" ~/Library/Preferences

    echo "\n📁 Caches:"
    fd -i "$keyword" ~/Library/Caches
}