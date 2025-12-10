############################################################
# 🐙 Git 기본 명령어
############################################################

alias gs="git status"
alias gss="git status -s"
alias ga="git add"
alias gaa="git add ."
alias gc="git commit"
alias gca="git commit --amend"
alias goops="git commit --amend --no-edit"
alias gpl="git pull"
alias gps="git push" 

############################################################
# 🌿 브랜치 관련
############################################################
alias gba="git branch -a"
alias gco="git checkout"
alias gcb="git checkout -b"

############################################################
# 🔍 변경사항 확인
############################################################
alias gd="git diff"
alias gdh="git diff HEAD"
alias gds="git diff --staged"

############################################################
# 📜 로그 보기
############################################################
alias glg="git log --graph --oneline"

############################################################
# ♻ 되돌리기 / 리셋
############################################################
alias grs="git restore --staged"

############################################################
# 📦 Stash
############################################################
alias gst="git stash"
alias gstp="git stash pop"
alias gstl="git stash list"

############################################################
# 🔄 main/develop 동기화
############################################################
# @desc: main과 develop 브랜치를 순서대로 최신화
# @usage: gsync
gsync() {
    local current_branch
    current_branch=$(git branch --show-current)

    # 1. 안전장치: 수정 중인 파일이 있으면 중단 (Stash/Commit 유도)
    if ! git diff --quiet || ! git diff --cached --quiet; then
        echo "⛔️ 수정사항(Uncommitted changes)이 있어 중단합니다."
        return 1
    fi

    # 2. Main 브랜치 업데이트
    if git show-ref --verify --quiet refs/heads/main; then
        echo "🔄 Syncing main..."
        git switch main && git pull || return 1
    fi

    # 3. Master 브랜치 업데이트 (Main과 별개로 체크하여 둘 다 있으면 둘 다 함)
    if git show-ref --verify --quiet refs/heads/master; then
        echo "🔄 Syncing master..."
        git switch master && git pull || return 1
    fi

    # 4. Develop 브랜치 업데이트
    if git show-ref --verify --quiet refs/heads/develop; then
        echo "🔄 Syncing develop..."
        git switch develop && git pull || return 1
    fi

    # 5. 원래 브랜치로 복귀 (핵심 수정 사항)
    # 현재 위치가 시작했던 브랜치와 다르다면, 무조건 원래 브랜치로 이동
    if [[ "$(git branch --show-current)" != "$current_branch" ]]; then
        echo "🔙 Returning to $current_branch..."
        git switch "$current_branch"
    else
        echo "✅ Already on $current_branch. Done."
    fi
}

############################################################
# 🧹 merged 브랜치 정리
############################################################
# @desc: 이미 머지된 로컬 브랜치 일괄 삭제 (확인 후 실행)
# @usage: gbclean
gbclean() {
    local branches=$(git branch --merged | grep -v "\*\|main\|develop\|master")
    
    if [[ -z "$branches" ]]; then
        echo "✨ 삭제할 브랜치가 없습니다."
        return 0
    fi
    
    echo "🧹 삭제될 브랜치:"
    echo "$branches"

    read "ans?⚠️ 위 브랜치를 삭제할까요? (y/N): "
    [[ "$ans" == "y" ]] || return

    echo "$branches" | xargs -n 1 git branch -d
}