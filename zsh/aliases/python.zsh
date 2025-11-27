############################################################
# ⚡ uv (Python Toolchain) - 실사용 중심
############################################################

# --------------------------------------------
# 📦 패키지 관리
# --------------------------------------------
alias uva="uv add"                     # 패키지 추가
alias uvad="uv add --dev"              # 개발 의존성 추가
alias uvr="uv remove"                  # 패키지 제거
alias uvs="uv sync"                    # 의존성/가상환경 동기화
alias uve="uv export"
alias uvx="uvx"                        # ruff/mypy 등 실행

# --------------------------------------------
# 🐍 Python 실행
# --------------------------------------------
alias pyr="uv run"                     # uv run (자동 venv)

# --------------------------------------------
# 🔍 Python 버전 관리
# --------------------------------------------
alias uvl="uv python list"             # Python 버전 리스트
alias uvi="uv python install"          # Python 버전 설치
alias uvpin="uv python pin"            # Python 버전 고정

# --------------------------------------------
# 📦 프로젝트 초기화
# --------------------------------------------
# @desc: uv 프로젝트 생성 후 해당 디렉토리로 이동
# @usage: uvinit <project-name>
# @example: uvinit my-app
uvinit() {
    if [ -z "$1" ]; then
        echo "❗ 사용법: uvinit <project-name>"
        return 1
    fi
    uv init "$1"
    cd "$1" || exit
    echo "✅ uv 프로젝트 생성 완료 → $(pwd)"
}

# --------------------------------------------
# 🐍 Python 버전 설치 + 지정
# --------------------------------------------
# @desc: Python 버전 설치 및 프로젝트에 고정
# @usage: uvuse <version>
# @example: uvuse 3.12
uvuse() {
    if [ -z "$1" ]; then
        echo "❗ 사용법: uvuse <python-version>"
        echo "예) uvuse 3.12"
        return 1
    fi
    uv python install "$1"
    echo "$1" > .python-version
    echo "🐍 Python version set to $1"
}

# --------------------------------------------
# 🧹 캐시 정리
# --------------------------------------------
# @desc: uv 캐시 정리
# @usage: uvclean
uvclean() {
    echo "🧹 Clearing uv cache..."
    uv cache clean
    echo "🧼 Done!"
}

# --------------------------------------------
# ✨ Linting / Formatting
# --------------------------------------------
alias ruffc="uvx ruff check ."         # ruff 린팅
alias rufff="uvx ruff format ."        # ruff 포맷팅