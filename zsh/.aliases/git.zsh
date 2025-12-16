############################################################
# 🐙 Git 기본 명령어
############################################################
alias gs="git status"
alias gss="git status -s"
alias ga="git add"
alias gaa="git add ."
alias gc="git commit"
alias gcm="git commit -m"
alias gca="git commit --amend"
alias goops="git commit --amend --no-edit"
alias gpl="git pull"
alias gps="git push"

############################################################
# 🌿 브랜치 관련 (Modern Git: switch/restore 기반)
############################################################
alias gsw="git switch"
alias gswc="git switch -c"

############################################################
# 🔍 변경사항 확인
############################################################
alias gd="git diff"
alias gdh="git diff HEAD"
alias gds="git diff --staged"
alias gnew="git ls-files --others --exclude-standard"

############################################################
# 🔍 변경사항 확인
############################################################
alias gd="git diff"
alias gdh="git diff HEAD"
alias gds="git diff --staged"
alias gnew="git ls-files --others --exclude-standard"

# @desc: git diff HEAD 결과를 diff.txt로 저장
# @usage: gdiff
gdiff() {
    git diff HEAD > diff.txt
    echo "✅ diff.txt"
}

# @desc: 새 파일(untracked) 내용을 new.txt로 저장
# @usage: gnewf
gnewf() {
    git ls-files --others --exclude-standard | xargs bat > new.txt
    echo "✅ new.txt"
}

############################################################
# 📜 로그 보기
############################################################
alias glg="git log --graph --oneline"

############################################################
# ♻ 되돌리기 / 리셋
############################################################
# 스테이징된 변경만 취소 (파일 내용은 건드리지 않음 – 안전)
alias grs="git restore --staged"

############################################################
# 📦 Stash
############################################################
alias gst="git stash"
alias gstp="git stash pop"
alias gstl="git stash list"

############################################################
# 🔄 main/master/develop 자동 동기화
############################################################
# @desc: main/master/develop 존재 여부에 따라 자동 pull 후 원래 브랜치 복귀
# @usage: gsync
gsync() {
    local current_branch
    current_branch=$(git branch --show-current)

    # 1. 안전장치: 수정 중이면 중단
    if ! git diff --quiet || ! git diff --cached --quiet; then
        echo "⛔️ 수정사항(Uncommitted changes)이 있어 중단합니다."
        return 1
    fi

    # 2. main 업데이트
    if git show-ref --verify --quiet refs/heads/main; then
        echo "🔄 Syncing main..."
        git switch main && git pull || return 1
    fi

    # 3. master 업데이트
    if git show-ref --verify --quiet refs/heads/master; then
        echo "🔄 Syncing master..."
        git switch master && git pull || return 1
    fi

    # 4. develop 업데이트
    if git show-ref --verify --quiet refs/heads/develop; then
        echo "🔄 Syncing develop..."
        git switch develop && git pull || return 1
    fi

    # 5. 원래 브랜치 복귀
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
# @desc: main/develop/master에 이미 머지된 브랜치를 일괄 삭제
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