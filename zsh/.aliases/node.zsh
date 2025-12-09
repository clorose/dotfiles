# ============================================
# 🚀 Node.js / PNPM 전용 Alias & Functions
# ============================================

# --------------------------------------------
# 📦 PNPM 기본 명령어
# --------------------------------------------
alias pn="pnpm"                       # pnpm 짧게 쓰기
alias pni="pnpm install"              # 의존성 설치
alias pna="pnpm add"                  # 패키지 추가
alias pnad="pnpm add -D"              # 개발 의존성 추가
alias pnr="pnpm remove"               # 패키지 제거

# --------------------------------------------
# 🏃 PNPM 스크립트 실행
# --------------------------------------------
alias pndev="pnpm dev"                # 개발 서버 실행
alias pnb="pnpm build"                # 프로덕션 빌드

# --------------------------------------------
# 🔪 포트 강제 종료
# --------------------------------------------
# @desc: 포트 번호를 받아서 해당 포트 사용 프로세스 종료
# @usage: killport <port>
# @example: killport 3000
killport() {
    if [ -z "$1" ]; then
        echo "❗ Usage: killport <port>"
        return 1
    fi
    lsof -ti tcp:$1 | xargs kill -9 2>/dev/null
    echo "🔪 Port $1 cleared."
}

# @desc: 자주 쓰는 포트(3000/5000/8000) 일괄 종료
# @usage: killports
killports() {
    echo "🔪 Killing commonly used dev ports..."
    killport 3000
    killport 5000
    killport 8000
    echo "✅ Ports cleared."
}