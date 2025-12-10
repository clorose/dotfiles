############################################################
# ⚡ uv (Python Toolchain) - 실사용 중심
############################################################

# --------------------------------------------
# 📦 패키지 관리
# --------------------------------------------
alias uva="uv add"                     # 패키지 추가
alias uvad="uv add --dev"              # 개발 의존성 추가
alias uvr="uv remove"                  # 패키지 제거
alias uvs="uv sync"                    # 의존성 동기화 (install 대용)
alias uvlock="uv lock"                 # lock 파일 갱신
alias uvup="uv lock --upgrade"         # 의존성 전체 최신화
alias uvtree="uv tree"                 # 의존성 트리 그래프

# --------------------------------------------
# 🐍 Python 실행 및 테스트
# --------------------------------------------
alias py="uv run python"               # Python REPL (쉘) 실행
alias pyr="uv run"                     # 스크립트 실행 (예: pyr main.py)
alias ptest="uv run pytest"            # 테스트 실행

# --------------------------------------------
# 🔍 Python 버전 관리
# --------------------------------------------
alias uvl="uv python list"             # 사용 가능한 Python 버전 목록
alias uvi="uv python install"          # Python 버전 다운로드

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
    # exit 대신 return 사용 (터미널 종료 방지)
    uv init "$1" && cd "$1" || return 1
    echo "✅ uv 프로젝트 생성 완료 → $(pwd)"
}

# --------------------------------------------
# 🐍 Python 버전 고정 (Pinning)
# --------------------------------------------
# @desc: 현재 프로젝트의 Python 버전 고정 (자동 다운로드 포함)
# @usage: uvuse <version>
# @example: uvuse 3.12
uvuse() {
    if [ -z "$1" ]; then
        echo "❗ 사용법: uvuse <python-version>"
        echo "예) uvuse 3.12"
        return 1
    fi
    uv python pin "$1"
}

# --------------------------------------------
# 🧹 캐시 정리
# --------------------------------------------
# @desc: uv 캐시 정리
# @usage: uvclean
uvclean() {
    echo "🧹 Clearing uv cache..."
    uv cache clean && echo "🧼 Done!"
}

# --------------------------------------------
# ✨ Ruff (Lint/Format)
# --------------------------------------------
alias ruffc="uvx ruff check ."         # 린트 검사
alias rufffix="uvx ruff check --fix ." # 린트 자동 수정
alias rufffmt="uvx ruff format ."      # 코드 포맷팅