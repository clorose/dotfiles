# ============================================
# 📁 기본 파일/디렉토리 명령어 (Modern: eza)
# ============================================
alias ls="eza --icons"
alias l="eza -lah --icons --group-directories-first"
alias ll="eza -lh --icons --group-directories-first"
alias la="eza -a --icons --group-directories-first"
alias lt="eza -l --sort=modified --reverse --icons --group-directories-first"

# Tree: 기본적으로 깊이를 2로 제한 (터미널 폭주 방지)
alias tree="eza -T --icons --group-directories-first --level=2"
alias trea="eza -Ta --icons --group-directories-first --level=2"
alias treel="eza -T --icons --group-directories-first" # 제한 없는 버전 (Long)
alias treela="eza -Ta --icons --group-directories-first" # 제한 없는 버전

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

alias cl="clear"
alias re="reset"
alias ㄱㄷ="reset"             # 한글 타이핑 실수용
alias reload="source ~/.zshrc" # 설정 재로드

# ============================
# 🗂 디렉토리/파일 관리
# ============================
alias md="mkdir -p"            # 디렉토리 생성
alias rd="rmdir"               # 빈 디렉토리 삭제
alias c="code ."               # VS Code로 열기

# ============================
# 🌐 네트워크 / 시스템 정보
# ============================
alias ip="curl ifconfig.me"            # 외부 IP
alias ports="lsof -PiTCP -sTCP:LISTEN" # 포트 확인

alias cleanup="find . -type f -name '*.DS_Store' -delete"

# ============================
# 🔍 검색 관련
# ============================
alias h="history | grep"
# ripgrep-all이 있으면 사용
alias rga="rga --rga-pretty-print"

# ============================
# 🧩 유용한 함수들
# ============================
# @desc: 폴더 생성 후 바로 이동
# @usage: mkcd <dirname>
# @example: mkcd new_project
mkcd() {
    [[ -z "$1" ]] && echo "❗ Usage: mkcd <dirname>" && return 1
    mkdir -p "$1" && cd "$1" || return 1
}

# @desc: 파일/폴더 이름 검색 (fd)
# @usage: search <keyword>
# @example: search config
search() {
    [[ -z "$1" ]] && echo "❗ Usage: search <keyword>" && return 1
    fd -i "$1"
}

# @desc: 파일 내용 검색 (ripgrep)
# @usage: search-in <keyword>
# @example: search-in "TODO:"
search-in() {
    [[ -z "$1" ]] && echo "❗ Usage: search-in <keyword>" && return 1
    rg --color=always -i "$1" .
}

# @desc: 프로세스 검색
# @usage: psg <process-name>
# @example: psg node
psg() {
    [[ -z "$1" ]] && echo "❗ Usage: psg <process-name>" && return 1
    # grep -v grep : 자기 자신(grep 프로세스)은 제외하고 출력
    ps aux | grep -v grep | grep "$1"
}

# @desc: 현재 폴더 용량 확인 (정렬 포함)
# @usage: dus (Disk Usage Summary)
dus() {
    # 에러(권한 등) 숨기고 용량 순으로 정렬해서 출력
    du -sh * 2>/dev/null | sort -hr
}
