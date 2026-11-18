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

# ============================
# 🔄 업데이트
# ============================
# @desc: apt + brew + mise + omz 일괄 업데이트
# omz update는 끝나면 셸을 재시작하므로 맨 마지막에 둠
update() {
    sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y
    brew update && brew upgrade
    mise upgrade
    omz update
}

# ============================
# 💻 시스템 제어 (WSL -> Windows)
# ============================
# @desc: Windows 화면 끄기
screenoff() {
    powershell.exe -NoProfile -Command "(Add-Type '[DllImport(\"user32.dll\")] public static extern int SendMessage(int h,int m,int w,int l);' -Name a -Pas)::SendMessage(-1,0x0112,0xF170,2)"
}
