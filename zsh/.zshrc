##############################################
# 🔐 SSH Key (GitHub - Apple Keychain)
##############################################
if ssh-add --apple-use-keychain ~/.ssh/id_ed25519_github > /dev/null 2>&1; then
    echo "Welcome, ${USER}"
else
    echo "SSH key loading failed"
fi

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
##############################################
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"

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
##############################################
for alias_file in ~/.aliases/*.zsh; do
    source "$alias_file"
done

##############################################
# 🎨 Powerlevel10k Config
##############################################
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

##############################################
# ✨ zsh-syntax-highlighting (마지막에!)
##############################################
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh