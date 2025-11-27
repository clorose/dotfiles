# ============================
# 📁 기본 파일/디렉토리 명령어
# ============================

alias ls="eza --icons"
alias l="eza -lah --icons --group-directories-first"
alias ll="eza -lh --icons --group-directories-first"
alias la="eza -a --icons --group-directories-first"
alias lt="eza -l --sort=modified --reverse --icons --group-directories-first"

alias tree="eza -T --icons --group-directories-first"

alias ..="cd .."               # 위 1단계
alias ...="cd ../.."           # 위 2단계
alias ....="cd ../../.."       # 위 3단계

alias ~="cd ~"                 # 홈 디렉토리 이동

alias cl="clear"               # 화면 지우기
alias re="reset"               # 터미널 리셋
alias ㄱㄷ="reset"             # 한글 타이핑 실수용
alias reload="source ~/.zshrc" # zsh 재로드

# ============================
# 🗂 디렉토리/파일 관리
# ============================

alias md="mkdir -p"            # 디렉토리 생성
alias rd="rmdir"               # 빈 디렉토리 삭제
alias c="code ."               # VS Code로 현재 폴더 열기
alias o="open ."               # Finder로 현재 폴더 열기

# ============================
# 🌐 네트워크 / 시스템 정보
# ============================

alias ip="curl ifconfig.me"            # 외부 IP
alias localip="ipconfig getifaddr en0" # 로컬 IP
alias ports="lsof -PiTCP -sTCP:LISTEN" # Listening 포트

alias flush="sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder"  # DNS 캐시 초기화
alias cleanup="find . -type f -name '*.DS_Store' -delete"                      # DS_Store 삭제

alias show="defaults write com.apple.finder AppleShowAllFiles YES && killall Finder"  # 숨김파일 표시
alias hide="defaults write com.apple.finder AppleShowAllFiles NO && killall Finder"   # 숨김파일 숨김

# ============================
# 🔍 검색 관련
# ============================

alias h="history | grep"        # 명령어 히스토리 검색
alias rga="rga --rga-pretty-print"  # PDF/DOCX 검색 (ripgrep-all)

# ============================
# 🧩 유용한 함수들
# ============================

# @desc: 폴더 생성 후 바로 이동
# @usage: mkcd <dirname>
# @example: mkcd test
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# @desc: 파일/폴더 이름 검색 (fd 사용)
# @usage: search <keyword>
# @example: search config
search() {
    fd -i "$1"
}

# @desc: 파일 내용 검색 (ripgrep 사용)
# @usage: search-in <keyword>
# @example: search-in TODO
search-in() {
    if [[ -z "$1" ]]; then
        echo "❗ 사용법: search-in <keyword>"
        return 1
    fi
    rg --color=always -i "$1" .
}

# @desc: 프로세스 검색
# @usage: psg <process-name>
# @example: psg node
psg() {
    ps aux | grep -v grep | grep "$1"
}

# @desc: 현재 폴더 내 파일/디렉토리별 용량 확인
# @usage: duf
duf() {
    du -sh *
}