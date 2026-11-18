# ============================
# 🍎 macOS 전용 (darwin에서만 로드됨 - .zshrc의 OS 분기 참고)
# ============================

# ============================
# 🔍 Finder
# ============================
alias o="open ."               # Finder로 열기
# @desc: Finder에서 숨김 파일 표시/숨김
# @usage: show / hide
alias show="defaults write com.apple.finder AppleShowAllFiles YES && killall Finder"
alias hide="defaults write com.apple.finder AppleShowAllFiles NO && killall Finder"

# ============================
# 🌐 네트워크 (macOS 전용 명령)
# ============================
alias localip="ipconfig getifaddr en0 || ipconfig getifaddr en1" # 로컬 IP
alias flush="sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder" # DNS 캐시 비우기

# ============================
# 💽 Volumes / DMG (Eject)
# ============================
# @desc: Finder의 "추출"(Eject)과 동일 - 마운트된 볼륨(/Volumes/...)을 안전하게 꺼냄
# @usage: ejectvol <VolumeName>
# @example: ejectvol "Cursor Installer"
ejectvol() {
    local name="$1"
    [[ -z "$name" ]] && { echo "usage: ejectvol <VolumeName>"; return 1; }

    local vol="/Volumes/$name"
    if [[ ! -d "$vol" ]]; then
        echo "not mounted: $vol"
        echo "mounted volumes:"
        ls /Volumes
        return 1
    fi

    diskutil eject "$vol"
}

# @desc: ejectvol 인자(볼륨명) 탭 자동완성
# @usage: ejectvol <TAB>
_ejectvol() {
    local -a vols
    vols=(${(f)"$(ls -1 /Volumes 2>/dev/null)"})
    _describe 'volumes' vols
}
compdef _ejectvol ejectvol

# ============================
# 🔄 업데이트
# ============================
# @desc: brew(cask 포함) + App Store + mise + omz 일괄 업데이트
# omz update는 끝나면 셸을 재시작하므로 맨 마지막에 둠
update() {
    brew update && brew upgrade
    mas upgrade
    mise upgrade
    omz update
}

# ============================
# 🎸 Guitar (기타)
# ============================
# 하드웨어(손가락) 결함으로 발생하는 Human Error 방지용 Error Boundary
alias "open ,"="open ."
