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
alias gp="git pull"
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
    local current_branch=$(git branch --show-current)
    
    git checkout main && git pull || return 1
    git checkout develop && git pull || return 1
    
    # 원래 브랜치로 복귀 (feature 브랜치 작업 중이었다면)
    if [[ "$current_branch" != "develop" && "$current_branch" != "main" ]]; then
        git checkout "$current_branch"
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