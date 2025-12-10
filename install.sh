#!/usr/bin/env bash

set -e

##############################################
# 색상 정의
##############################################
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

##############################################
# 유틸리티 함수
##############################################
print_step() {
    echo -e "\n${BLUE}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}${BOLD}🔹 Step $1: $2${NC}"
    echo -e "${BLUE}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_info() {
    echo -e "${CYAN}ℹ $1${NC}"
}

ask_yes_no() {
    while true; do
        read -p "$(echo -e $1 [y/N]: )" yn
        case $yn in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            "" ) return 1;;
            * ) echo "y 또는 n을 입력해주세요.";;
        esac
    done
}

##############################################
# Step 1: Homebrew 설치
##############################################
install_homebrew() {
    print_step "1" "Homebrew 설치 및 Brewfile 적용"
    
    if command -v brew &> /dev/null; then
        print_success "Homebrew가 이미 설치되어 있습니다."
        brew --version
    else
        print_warning "Homebrew가 설치되어 있지 않습니다."
        if ask_yes_no "Homebrew를 설치하시겠습니까?"; then
            echo ""
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            
            # Apple Silicon Mac의 경우 PATH 추가
            if [[ $(uname -m) == 'arm64' ]]; then
                echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
                eval "$(/opt/homebrew/bin/brew shellenv)"
            fi
            
            print_success "Homebrew 설치 완료!"
        else
            print_error "Homebrew 설치를 건너뜁니다. 이후 단계를 진행할 수 없습니다."
            exit 1
        fi
    fi
    
    echo ""
    if ask_yes_no "Brewfile의 패키지들을 설치하시겠습니까?"; then
        echo ""
        brew bundle --file=./Brewfile
        print_success "Brewfile 설치 완료!"
    else
        print_warning "Brewfile 설치를 건너뜁니다."
    fi
}

##############################################
# Step 2: Oh My Zsh 설치
##############################################
install_ohmyzsh() {
    print_step "2" "Oh My Zsh 및 플러그인 설치"
    
    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        print_success "Oh My Zsh가 이미 설치되어 있습니다."
    else
        print_warning "Oh My Zsh가 설치되어 있지 않습니다."
        if ask_yes_no "Oh My Zsh를 설치하시겠습니까?"; then
            echo ""
            # unattended 모드로 설치 (기본 .zshrc 생성 안 함)
            RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
            print_success "Oh My Zsh 설치 완료!"
        else
            print_error "Oh My Zsh 설치를 건너뜁니다."
            return 1
        fi
    fi
    
    # Powerlevel10k 테마 설치
    echo ""
    local P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
    if [[ -d "$P10K_DIR" ]]; then
        print_success "Powerlevel10k 테마가 이미 설치되어 있습니다."
    else
        if ask_yes_no "Powerlevel10k 테마를 설치하시겠습니까?"; then
            echo ""
            git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
            print_success "Powerlevel10k 테마 설치 완료!"
        fi
    fi
    
    # zsh-autosuggestions 플러그인 설치
    echo ""
    local AUTOSUGGESTIONS_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
    if [[ -d "$AUTOSUGGESTIONS_DIR" ]]; then
        print_success "zsh-autosuggestions 플러그인이 이미 설치되어 있습니다."
    else
        if ask_yes_no "zsh-autosuggestions 플러그인을 설치하시겠습니까?"; then
            echo ""
            git clone https://github.com/zsh-users/zsh-autosuggestions "$AUTOSUGGESTIONS_DIR"
            print_success "zsh-autosuggestions 플러그인 설치 완료!"
        fi
    fi
}

##############################################
# Step 3: Stow로 dotfiles 연결
##############################################
setup_stow() {
    print_step "3" "Stow로 설정 파일 연결 (zsh, git, mise)"
    
    local BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
    local NEED_BACKUP=false
    
    # 충돌 파일 체크
    local CONFLICT_FILES=(
        "$HOME/.zshrc"
        "$HOME/.p10k.zsh"
        "$HOME/.gitconfig"
        "$HOME/.config/git/commit-template.txt"
        "$HOME/.config/mise/config.toml"
    )
    
    echo "충돌 파일 확인 중..."
    for file in "${CONFLICT_FILES[@]}"; do
        if [[ -f "$file" ]] && [[ ! -L "$file" ]]; then
            NEED_BACKUP=true
            print_warning "충돌: $file"
        fi
    done
    
    if [[ "$NEED_BACKUP" == true ]]; then
        echo ""
        if ask_yes_no "기존 설정 파일을 백업하고 덮어쓰시겠습니까? (백업 위치: $BACKUP_DIR)"; then
            mkdir -p "$BACKUP_DIR"
            for file in "${CONFLICT_FILES[@]}"; do
                if [[ -f "$file" ]] && [[ ! -L "$file" ]]; then
                    local relative_path="${file#$HOME/}"
                    mkdir -p "$BACKUP_DIR/$(dirname "$relative_path")"
                    mv "$file" "$BACKUP_DIR/$relative_path"
                    print_success "백업: $relative_path"
                fi
            done
            echo ""
        else
            print_error "Stow 설정을 건너뜁니다."
            return 1
        fi
    else
        print_success "충돌하는 파일이 없습니다."
    fi
    
    echo ""
    if ask_yes_no "설정 파일들을 연결하시겠습니까? (zsh, git, mise)"; then
        echo ""
        stow -v zsh git mise
        print_success "Stow 설정 완료!"
        echo ""
        print_info "연결된 파일들:"
        echo "  • ~/.zshrc"
        echo "  • ~/.p10k.zsh"
        echo "  • ~/.gitconfig"
        echo "  • ~/.config/git/commit-template.txt"
        echo "  • ~/.config/mise/config.toml"
    else
        print_warning "Stow 설정을 건너뜁니다."
    fi
}

##############################################
# Step 4: mise 설정
##############################################
setup_mise() {
    print_step "4" "mise 설정 및 글로벌 툴 설치"
    
    print_success "mise 버전:"
    mise --version
    
    echo ""
    if ask_yes_no "mise 설정을 신뢰하시겠습니까? (mise trust)"; then
        mise trust
        print_success "mise trust 완료!"
    fi
    
    echo ""
    print_info "config.toml에 정의된 툴들: node, pnpm, python, rust"
    if ask_yes_no "글로벌 툴들을 설치하시겠습니까?"; then
        echo ""
        mise install
        print_success "글로벌 툴 설치 완료!"
        echo ""
        print_info "설치된 툴 목록:"
        mise list
    else
        print_warning "글로벌 툴 설치를 건너뜁니다."
        print_info "나중에 'mise install'로 설치할 수 있습니다."
    fi
}

##############################################
# Step 5: FZF 키바인딩 설정
##############################################
setup_fzf() {
    print_step "5" "FZF 키바인딩 설정"
    
    local FZF_INSTALL_SCRIPT="$(brew --prefix)/opt/fzf/install"
    
    if [[ -f "$FZF_INSTALL_SCRIPT" ]]; then
        if [[ ! -f "$HOME/.fzf.zsh" ]]; then
            print_info "FZF 키바인딩을 설치하면 Ctrl+R(명령어 히스토리), Ctrl+T(파일 검색) 등을 사용할 수 있습니다."
            if ask_yes_no "FZF 키바인딩을 설치하시겠습니까?"; then
                echo ""
                # --all: 키바인딩/완성 모두 활성화, --no-bash/fish: zsh만
                "$FZF_INSTALL_SCRIPT" --all --no-bash --no-fish
                print_success "FZF 키바인딩 설치 완료!"
            else
                print_warning "FZF 키바인딩 설치를 건너뜁니다."
            fi
        else
            print_success "FZF 키바인딩이 이미 설치되어 있습니다."
        fi
    else
        print_warning "FZF가 설치되어 있지 않습니다. Brewfile을 먼저 실행하세요."
    fi
}

##############################################
# Step 6: Git 설정 확인
##############################################
check_git_config() {
    print_step "6" "Git 사용자 설정 확인"
    
    local GIT_NAME=$(git config --global user.name 2>/dev/null || echo "")
    local GIT_EMAIL=$(git config --global user.email 2>/dev/null || echo "")
    
    if [[ -n "$GIT_NAME" ]] && [[ -n "$GIT_EMAIL" ]]; then
        print_success "Git 사용자 설정이 이미 되어 있습니다."
        echo "  • Name: $GIT_NAME"
        echo "  • Email: $GIT_EMAIL"
    else
        print_warning "Git 사용자 설정이 필요합니다."
        echo ""
        echo "다음 명령어로 설정하세요:"
        echo "  ${CYAN}git config --global user.name \"Your Name\"${NC}"
        echo "  ${CYAN}git config --global user.email \"your.email@example.com\"${NC}"
    fi
}

##############################################
# Step 7: SSH Key 설정
##############################################
setup_ssh_key() {
    print_step "7" "SSH Key 설정 (GitHub)"
    
    local SSH_KEY="$HOME/.ssh/id_ed25519_github"
    
    if [[ -f "$SSH_KEY" ]]; then
        print_success "SSH Key가 이미 존재합니다: $SSH_KEY"
        
        echo ""
        if ask_yes_no "SSH Key를 Apple Keychain에 추가하시겠습니까?"; then
            ssh-add --apple-use-keychain "$SSH_KEY" 2>/dev/null || ssh-add -K "$SSH_KEY"
            print_success "SSH Key가 Keychain에 추가되었습니다."
            
            echo ""
            print_info "SSH 연결 테스트:"
            echo "  ${CYAN}ssh -T git@github.com${NC}"
        fi
    else
        print_warning "SSH Key가 없습니다: $SSH_KEY"
        echo ""
        if ask_yes_no "새로운 SSH Key를 생성하시겠습니까?"; then
            read -p "GitHub 이메일을 입력하세요: " github_email
            
            mkdir -p "$HOME/.ssh"
            ssh-keygen -t ed25519 -C "$github_email" -f "$SSH_KEY"
            ssh-add --apple-use-keychain "$SSH_KEY" 2>/dev/null || ssh-add -K "$SSH_KEY"
            
            echo ""
            print_success "SSH Key 생성 완료!"
            echo ""
            print_warning "다음 공개키를 GitHub에 등록하세요:"
            echo "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
            cat "${SSH_KEY}.pub"
            echo "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
            echo ""
            print_info "GitHub 설정: ${CYAN}https://github.com/settings/keys${NC}"
        fi
    fi
}

##############################################
# Step 8: 기본 Shell 변경
##############################################
change_shell() {
    print_step "8" "기본 Shell을 zsh로 변경"
    
    if [[ "$SHELL" == */zsh ]]; then
        print_success "기본 Shell이 이미 zsh입니다."
        echo "  현재 Shell: $SHELL"
    else
        print_warning "기본 Shell이 zsh가 아닙니다: $SHELL"
        echo ""
        if ask_yes_no "기본 Shell을 zsh로 변경하시겠습니까?"; then
            chsh -s "$(which zsh)"
            print_success "기본 Shell을 zsh로 변경했습니다."
            echo ""
            print_warning "변경사항은 로그아웃 후 다시 로그인하면 적용됩니다."
        fi
    fi
}

##############################################
# Step 9: Alfred Workflows 안내
##############################################
setup_alfred() {
    print_step "9" "Alfred Workflows 설치 안내"
    
    local ALFRED_DIR="./alfred"
    
    if [[ -d "$ALFRED_DIR" ]] && [[ -n "$(ls -A $ALFRED_DIR/*.alfredworkflow 2>/dev/null)" ]]; then
        print_info "다음 Alfred Workflows를 수동으로 설치하세요:"
        echo ""
        ls -1 "$ALFRED_DIR"/*.alfredworkflow | while read workflow; do
            echo "  • $(basename "$workflow")"
        done
        echo ""
        print_info "설치 방법: 각 .alfredworkflow 파일을 더블클릭"
    else
        print_warning "Alfred Workflows 파일을 찾을 수 없습니다."
    fi
}

##############################################
# Step 10: 최종 안내
##############################################
final_message() {
    print_step "10" "설치 완료!"
    
    echo -e "${GREEN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}${BOLD}   ✨ Dotfiles 설정이 완료되었습니다! ✨${NC}"
    echo -e "${GREEN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "${CYAN}${BOLD}📋 다음 단계:${NC}"
    echo ""
    echo -e "${YELLOW}1.${NC} 새 터미널을 열거나 다음을 실행:"
    echo -e "   ${CYAN}source ~/.zshrc${NC}"
    echo ""
    echo -e "${YELLOW}2.${NC} mise 설치 확인:"
    echo -e "   ${CYAN}mise list${NC}"
    echo ""
    echo -e "${YELLOW}3.${NC} Git 사용자 설정 (필요시):"
    echo -e "   ${CYAN}git config --global user.name \"Your Name\"${NC}"
    echo -e "   ${CYAN}git config --global user.email \"your@email.com\"${NC}"
    echo ""
    echo -e "${YELLOW}4.${NC} SSH 연결 테스트:"
    echo -e "   ${CYAN}ssh -T git@github.com${NC}"
    echo ""
    echo -e "${YELLOW}5.${NC} Alfred Workflows 설치 (있는 경우)"
    echo ""
    echo -e "${GREEN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}${BOLD}      Happy Coding! 🚀${NC}"
    echo -e "${GREEN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

##############################################
# 메인 함수
##############################################
main() {
    # 스크립트 실행 위치를 dotfiles 디렉토리로 강제 이동
    local SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    cd "$SCRIPT_DIR"
    
    clear
    echo -e "${CYAN}${BOLD}"
    cat << "EOF"
╔═══════════════════════════════════════════╗
║                                           ║
║       🚀 Dotfiles Setup Script 🚀        ║
║                                           ║
╚═══════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    
    print_info "작업 디렉토리: $(pwd)"
    echo ""
    
    echo "이 스크립트는 다음을 설정합니다:"
    echo ""
    echo "  ${CYAN}•${NC} Homebrew 및 필수 패키지"
    echo "  ${CYAN}•${NC} Oh My Zsh, Powerlevel10k, 플러그인"
    echo "  ${CYAN}•${NC} Dotfiles (zsh, git, mise)"
    echo "  ${CYAN}•${NC} mise 글로벌 툴 (node, pnpm, python, rust)"
    echo "  ${CYAN}•${NC} FZF 키바인딩"
    echo "  ${CYAN}•${NC} SSH Key 및 Git 설정"
    echo "  ${CYAN}•${NC} 기본 Shell 변경"
    echo ""
    
    if ! ask_yes_no "${BOLD}계속 진행하시겠습니까?${NC}"; then
        echo ""
        print_warning "설치를 취소했습니다."
        exit 0
    fi
    
    # 각 단계 실행
    install_homebrew
    install_ohmyzsh
    setup_stow
    setup_mise
    setup_fzf
    check_git_config
    setup_ssh_key
    change_shell
    setup_alfred
    final_message
}

# 스크립트 실행
main