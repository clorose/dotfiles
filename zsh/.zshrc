##############################################
# 🔐 SSH Key (GitHub)
# macOS는 Apple Keychain 연동, Linux는 일반 ssh-add
##############################################
if [[ "$OSTYPE" == darwin* ]]; then
    _ssh_add_opts=(--apple-use-keychain)
else
    _ssh_add_opts=()
fi
if ssh-add "${_ssh_add_opts[@]}" ~/.ssh/id_ed25519_github > /dev/null 2>&1; then
    echo "Welcome, ${USER}"
else
    echo "SSH key loading failed"
fi
unset _ssh_add_opts

##############################################
# ⚡ Powerlevel10k Instant Prompt
##############################################
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
    zsh-autosuggestions
    extract
    colored-man-pages
)

source "$ZSH/oh-my-zsh.sh"

##############################################
# 🌍 Locale & Editor
##############################################
export LANG="en_US.UTF-8"
export EDITOR="code -w"
export VISUAL="code -w"

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
eval "$(mise activate zsh)"

##############################################
# 🔎 fzf
##############################################
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"

##############################################
# 🚀 zoxide (smart cd)
##############################################
eval "$(zoxide init zsh)"

##############################################
# 🎨 vivid LS_COLORS (for eza color theme)
##############################################
export LS_COLORS="$(vivid generate nord)"

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
source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
