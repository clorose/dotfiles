##############################################
# 🧩 Etc Settings (aliases / helper commands)
#    - 카테고리 분류 애매한 잡다한 alias 모음
#    - 규모 커지면 별도 모듈로 분리 예정
##############################################

# -------------------------
# 🟦 mise: version manager
# -------------------------

# 설치된 버전 목록
alias ml="mise ls"

# 업데이트 확인 (현재 설정 범위 내)
alias mo="mise outdated"

# 모든 버전 범위 포함해서 확인
alias mob="mise outdated --bump"

# -------------------------
# 🟩 Homebrew utilities
# -------------------------
# Brewfile 재생성
alias brewdump='brew bundle dump --describe --force --file="$HOME/dotfiles/Brewfile"'

# --------------------------------------------
# 📦 고압축 7z 아카이브 생성 (folder → folder.7z)
# --------------------------------------------
# @desc: 지정한 폴더를 .7z 고압축 파일로 생성합니다 (7z -mx=9)
# @usage: 7zz <folder>
7zz() {
    local name="${1%/}"
    echo "📦 Creating $name.7z ..."
    7z a -mx=9 "$name.7z" "$name/" > /dev/null
    echo "✨ Done: $name.7z"
}

# --------------------------------------------
# 📦 초고압축 tar.xz 생성 (folder → folder.tar.xz)
# --------------------------------------------
# @desc: 지정한 폴더를 .tar.xz로 초고압축합니다 (tar -cJf)
# @usage: txz <folder>
txz() {
    local name="${1%/}"
    echo "📦 Creating $name.tar.xz ..."
    tar -cJf "$name.tar.xz" "$name/"
    echo "✨ Done: $name.tar.xz"
}

# -------------------------
# 🎸 Guitar (기타)
# -------------------------
# 하드웨어(내 손) 결함으로 발생하는 'open ,' 보정
alias "open ,"="open ."
