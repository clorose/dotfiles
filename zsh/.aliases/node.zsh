# ============================================
# 🚀 Node.js / PNPM 전용 Alias & Functions
# ============================================

# --------------------------------------------
# 📦 PNPM 기본 명령어
# --------------------------------------------
alias pn="pnpm"                       # pnpm 단축
alias pni="pnpm install"              # 의존성 설치
alias pna="pnpm add"                  # 패키지 추가
alias pnad="pnpm add -D"              # 개발 의존성 추가
alias pnr="pnpm remove"               # 패키지 제거

# --------------------------------------------
# 🏃 PNPM 스크립트 실행
# --------------------------------------------
alias pndev="pnpm dev"                # 개발 서버 실행
alias pnb="pnpm build"                # 프로덕션 빌드
alias pnpr="pnpm preview"             # Vite/SvelteKit 미리보기

# --------------------------------------------
# 🔍 포트 점유 프로세스 확인 (Safety)
# --------------------------------------------
# @desc: 특정 포트를 점유한 프로세스 정보 표시
# @usage: portinfo <port>
# @example: portinfo 5173
portinfo() {
    local port="$1"
    if [ -z "$port" ]; then
        echo "❗ Usage: portinfo <port>"
        return 1
    fi

    local pid=$(lsof -ti tcp:"$port")

    if [ -z "$pid" ]; then
        echo "⚪ Port $port is free."
        return 0
    fi

    echo "🔍 Port $port is used by PID: $pid"
    ps -p $pid -o pid,ppid,command
}

# --------------------------------------------
# 🔪 포트 강제 종료
# --------------------------------------------
# @desc: 포트 번호를 받아서 해당 포트 사용 프로세스 종료
# @usage: killport <port>
# @example: killport 3000
killport() {
    local port="$1"
    if [ -z "$port" ]; then
        echo "❗ Usage: killport <port>"
        return 1
    fi

    local pid=$(lsof -ti tcp:"$port")
    
    if [ -z "$pid" ]; then
        echo "✨ Port $port is already free."
        return 0
    fi

    echo "$pid" | xargs kill -9 2>/dev/null
    echo "🔪 Port $port (PID: $pid) cleared."
}

# @desc: 자주 쓰는 개발 포트 일괄 종료 (사용 중인 것만 처리)
# @usage: killports
killports() {
    # 5173(Vite), 4173(Preview) 포함
    for p in 3000 5000 8000 5173 4173; do
        local pid=$(lsof -ti tcp:"$p")
        if [ -n "$pid" ]; then
            kill -9 $pid 2>/dev/null
            echo "🔪 Port $p (PID: $pid) killed."
        fi
    done
}