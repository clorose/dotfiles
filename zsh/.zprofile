##############################################
# 🍺 Homebrew (필수 - brew 명령어 PATH 등록)
# macOS: /opt/homebrew, Linux(WSL): /home/linuxbrew/.linuxbrew
##############################################
for _brew in /opt/homebrew/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
    if [[ -x "$_brew" ]]; then
        eval "$("$_brew" shellenv)"
        break
    fi
done
unset _brew

##############################################
# 📦 사용자 로컬 바이너리 (pipx, agy 등)
##############################################
export PATH="$HOME/.local/bin:$PATH"
