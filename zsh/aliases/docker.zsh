############################################################
# 🐳 Docker 기본 명령어
############################################################
alias dk="docker"                      # docker 단축
alias dkp="docker ps"                  # 실행 중인 컨테이너 목록
alias dki="docker images"              # 이미지 목록

############################################################
# 🐳 Docker Compose (docker compose = 최신 문법)
############################################################
alias dc="docker compose"
alias dcu="docker compose up"
alias dcd="docker compose down"
alias dcl="docker compose logs -f"

############################################################
# 🐳 컨테이너 내부 쉘 접속 (zsh → bash → sh 순서 fallback)
############################################################
# @desc: 컨테이너 내부로 쉘 접속 (zsh/bash/sh 자동 fallback)
# @usage: dex <container_name>
# @example: dex backend
dex() {
    local name=$1
    if [ -z "$name" ]; then
        echo "❌ 컨테이너 이름을 입력하세요. 예: dex backend"
        return 1
    fi

    docker exec -it "$name" zsh 2>/dev/null \
    || docker exec -it "$name" bash 2>/dev/null \
    || docker exec -it "$name" sh
}

# 자동완성 (docker ps 이름 자동완성)
_dex_completion() {
    compadd $(docker ps --format '{{.Names}}')
}
compdef _dex_completion dex

############################################################
# 🧹 system prune (1회 확인)
############################################################
# @desc: 사용하지 않는 Docker 리소스 정리 (확인 후 실행)
# @usage: dkprune
dkprune() {
    read "ans?⚠️ docker system prune 실행할까요? (y/N): "
    [[ "$ans" == "y" ]] && docker system prune
}

############################################################
# 🧹 특정 패턴 컨테이너 일괄 삭제 (안전 버전)
############################################################
# @desc: 이름 패턴에 매칭되는 컨테이너 일괄 삭제 (확인 후 실행)
# @usage: dkclean <pattern>
# @example: dkclean test_
dkclean() {
    if [ -z "$1" ]; then
        echo "사용법: dkclean <pattern>"
        return 1
    fi

    echo "🛑 삭제될 컨테이너:"
    docker ps -a --format "{{.Names}}" | grep "$1"

    read "ans?⚠️ 해당 컨테이너들을 삭제할까요? (y/N): "
    [[ "$ans" == "y" ]] || return

    docker ps -a --format "{{.Names}}" \
        | grep "$1" \
        | xargs -I {} docker rm -f {}
}


############################################################
# 📜 도커 로그 tail (기본 100줄)
############################################################
# @desc: 컨테이너 로그를 실시간으로 출력 (기본 최근 100줄부터)
# @usage: dklog <container_name> [lines]
# @example: dklog backend 200
dklog() {
    docker logs -f --tail="${2:-100}" "$1"
}

############################################################
# 🗑 모든 컨테이너 삭제 (1회 확인)
############################################################
# @desc: 모든 컨테이너 삭제 (확인 후 실행)
# @usage: dkrm-all
dkrm-all() {
    local list=$(docker ps -aq)
    [ -z "$list" ] && echo "컨테이너 없음" && return

    echo "🛑 삭제될 컨테이너:"
    docker ps -a --format " - {{.ID}} {{.Names}}"

    read "ans?⚠️ 모든 컨테이너 삭제? (y/N): "
    [[ "$ans" == "y" ]] && docker rm -f $list
}

############################################################
# 🧨 모든 이미지 삭제 (1회 확인)
############################################################
# @desc: 모든 Docker 이미지 삭제 (확인 후 실행)
# @usage: dkrmi-all
dkrmi-all() {
    local list=$(docker images -q)
    [ -z "$list" ] && echo "이미지 없음" && return

    echo "🛑 삭제될 이미지:"
    docker images --format " - {{.Repository}}:{{.Tag}} ({{.ID}})"

    read "ans?⚠️ 모든 이미지 삭제? (y/N): "
    [[ "$ans" == "y" ]] && docker rmi -f $list
}