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
# 🗣️ ai-debate: Claude ↔ Codex 토론 (GLM 등 손님 참여 가능)
############################################################
# 설치 위치 (다른 머신에서 경로가 다르면 덮어쓰기)
: ${AI_DEBATE_HOME:=$HOME/20_Dev/ai-debate}

# @desc: AI 토론방을 만들어 토론 시작, 또는 기존 방에 이어서 말하기 (옵션은 debate --help)
# @usage: debate "메시지" [--cwd 폴더] [--tools] [--first codex] [--max-rounds N] [--lang en] | debate --room <방ID> "메시지"
debate() {
    [[ -f "$AI_DEBATE_HOME/debate.mjs" ]] || { echo "❌ ai-debate 없음: $AI_DEBATE_HOME"; return 1; }
    node "$AI_DEBATE_HOME/debate.mjs" "$@"
}

# @desc: AI 토론 웹 UI 서버를 켜고 브라우저로 연다 (서버 코드가 바뀌면 알아서 재시작, Ctrl-C로 종료)
# @usage: debate-ui [--port 4747]
debate-ui() {
    [[ -f "$AI_DEBATE_HOME/ui/server.mjs" ]] || { echo "❌ ai-debate 없음: $AI_DEBATE_HOME"; return 1; }
    local port=4747
    [[ "$1" == "--port" && -n "$2" ]] && port="$2"
    ( sleep 1 && open "http://localhost:$port" ) &!
    node --watch "$AI_DEBATE_HOME/ui/server.mjs" --port "$port"
}
