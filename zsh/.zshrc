##############################################
# 🧹 PATH 중복 자동 제거 (셸 중첩 시 누적 방지)
##############################################
typeset -U path PATH

##############################################
# 🔐 SSH Key (GitHub)
# macOS는 Apple Keychain 연동, Linux는 일반 ssh-add
##############################################
if [[ "$OSTYPE" == darwin* ]]; then
    _ssh_add_opts=(--apple-use-keychain)
else
    _ssh_add_opts=()
    # Linux/WSL: ssh-agent가 없으면 기동하고 소켓을 env 파일로 재사용
    _ssh_env="$HOME/.ssh/agent-env"
    [[ -f "$_ssh_env" ]] && source "$_ssh_env" > /dev/null
    ssh-add -l > /dev/null 2>&1
    if [[ $? -eq 2 ]]; then
        ssh-agent -s > "$_ssh_env" 2>/dev/null
        chmod 600 "$_ssh_env"
        source "$_ssh_env" > /dev/null
    fi
    unset _ssh_env
fi
if [[ -f ~/.ssh/id_ed25519_github ]]; then
    if ssh-add "${_ssh_add_opts[@]}" ~/.ssh/id_ed25519_github > /dev/null 2>&1; then
        echo "Welcome, ${USER}"
    else
        echo "SSH key loading failed"
    fi
fi
unset _ssh_add_opts

##############################################
# ⚡ Powerlevel10k Instant Prompt
##############################################
# mise 등 초기화 중 출력이 있어도 p10k 경고 배너를 띄우지 않음 (출력 자체는 보임)
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

##############################################
# 🛠 Oh My Zsh + Plugins
##############################################
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
    git
    extract
    colored-man-pages
)

[[ -r "$ZSH/oh-my-zsh.sh" ]] && source "$ZSH/oh-my-zsh.sh"

# Homebrew 직접 설치와 Linux 배포판 패키지 경로 모두 지원
if [[ -r "$ZSH_CUSTOM/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
    source "$ZSH_CUSTOM/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
elif [[ -r /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

##############################################
# 🌍 Locale & Editor
##############################################
export LANG="en_US.UTF-8"
if command -v code >/dev/null 2>&1; then
    export EDITOR="code --wait"
    export VISUAL="code --wait"
else
    export EDITOR="nano"
    export VISUAL="nano"
fi

##############################################
# 🍺 Homebrew
# 경로 등록은 .zprofile의 shellenv가 담당 (macOS/Linux 자동 감지)
# 비로그인 셸 대비 안전장치만 여기 둠
##############################################
if [[ -z "$HOMEBREW_PREFIX" ]]; then
    for _brew in /opt/homebrew/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
        [[ -x "$_brew" ]] && eval "$("$_brew" shellenv)" && break
    done
    unset _brew
fi
[[ -d "$HOMEBREW_PREFIX/opt/postgresql@17/bin" ]] && export PATH="$HOMEBREW_PREFIX/opt/postgresql@17/bin:$PATH"

##############################################
# 🟦 mise
##############################################
command -v mise >/dev/null 2>&1 && eval "$(mise activate zsh)"

##############################################
# 🔎 fzf
##############################################
if [[ -r "$HOME/.fzf.zsh" ]]; then
    source "$HOME/.fzf.zsh"
else
    [[ -r /usr/share/doc/fzf/examples/completion.zsh ]] \
        && source /usr/share/doc/fzf/examples/completion.zsh
    [[ -r /usr/share/doc/fzf/examples/key-bindings.zsh ]] \
        && source /usr/share/doc/fzf/examples/key-bindings.zsh
fi
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"

##############################################
# 🚀 zoxide (smart cd)
##############################################
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"

##############################################
# 🎨 vivid LS_COLORS (for eza color theme)
##############################################
command -v vivid >/dev/null 2>&1 && export LS_COLORS="$(vivid generate nord)"

##############################################
# ✨ Autosuggestion Highlight Color
##############################################
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=60"

##############################################
# 🔧 Custom Aliases (분리된 alias 파일들)
# darwin.zsh / linux.zsh는 해당 OS에서만 로드
##############################################
for alias_file in ~/.aliases/*.zsh; do
    case "${alias_file:t}" in
        darwin.zsh) [[ "$OSTYPE" == darwin* ]] || continue ;;
        linux.zsh)  [[ "$OSTYPE" == linux*  ]] || continue ;;
    esac
    source "$alias_file"
done

##############################################
# 🎨 Powerlevel10k Config
##############################################
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

##############################################
# ✨ zsh-syntax-highlighting (마지막에!)
##############################################
if [[ -r "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
    source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
elif [[ -r /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
