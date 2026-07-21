##############################################
# 🧩 Etc Settings (aliases / helper commands)
# - 카테고리 분류 애매한 잡다한 alias 모음
# - 규모 커지면 별도 모듈로 분리 예정
##############################################

############################################################
# 🟦 mise: version manager
############################################################
alias ml="mise ls"              # 설치된 버전 목록
alias mo="mise outdated"        # 업데이트 확인
alias mob="mise outdated --bump" # 모든 버전 고려 bump 확인

############################################################
# 🟩 Homebrew utilities
############################################################
# Brewfile 재생성
alias brewdump='brew bundle dump --describe --force --file="$HOME/dotfiles/Brewfile"'

############################################################
# 📦 고압축 7z 아카이브 생성 (folder → folder.7z)
############################################################
# @desc: 지정 폴더를 .7z 고압축 파일로 생성 (-mx=9 최고압축)
# @usage: 7zz <folder>
7zz() {
    local name="${1%/}"
    echo "📦 Creating $name.7z ..."
    7z a -mx=9 "$name.7z" "$name/" > /dev/null
    echo "✨ Done: $name.7z"
}

############################################################
# 📦 초고압축 tar.xz 생성 (folder → folder.tar.xz)
############################################################
# @desc: 지정 폴더를 .tar.xz로 초고압축
# @usage: txz <folder>
txz() {
    local name="${1%/}"
    echo "📦 Creating $name.tar.xz ..."
    tar -cJf "$name.tar.xz" "$name/"
    echo "✨ Done: $name.tar.xz"
}

############################################################
# 📦 ZIP 압축 해제 (file → 같은 이름 폴더)
############################################################
# @desc: ZIP 계열 파일을 같은 이름의 폴더에 압축 해제
# @usage: unzd <file.zip>
unzd() { unzip "$1" -d "${1%.*}"; }

############################################################
# 🔬 .NET 디컴파일 (STS2 모딩)
############################################################
# @desc: dotnet-ildasm이 netcoreapp2.2 대상 화석 툴이라 최신 런타임으로 roll-forward 필요
# @usage: dotnet-ildasm <assembly.dll>
alias dotnet-ildasm='DOTNET_ROLL_FORWARD=LatestMajor ~/.dotnet/tools/dotnet-ildasm'

############################################################
# 🎸 Guitar (기타)
############################################################
# 하드웨어(손가락) 결함으로 발생하는 Human Error 방지용 Error Boundary
alias "open ,"="open ."
