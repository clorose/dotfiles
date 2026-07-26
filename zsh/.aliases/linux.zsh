# ============================
# 🐧 Linux 전용
# ============================

# ============================
# 📂 파일 관리자
# ============================
# macOS의 open 명령과 같은 사용법 제공
if command -v xdg-open >/dev/null 2>&1; then
    alias open="xdg-open"
elif command -v explorer.exe >/dev/null 2>&1; then
    alias open="explorer.exe"
elif command -v gio >/dev/null 2>&1; then
    alias open="gio open"
fi

alias o="open ."

# 하드웨어(손가락) 결함으로 발생하는 Human Error 방지용 Error Boundary
alias "open ,"="open ."
