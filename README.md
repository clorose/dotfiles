# ✔️ Dotfiles

개인 개발 환경(Zsh 기반)을 위한 dotfiles 저장소입니다.
Powerlevel10k, fzf, ripgrep, alias 모듈 구조 등을 포함하며 설치 스크립트(sh 파일)로 손쉽게 적용할 수 있습니다.


---

## 📦 Repository Structure

```zsh
dotfiles/
├── Fonts/
│   ├── HackNerdFontMono-Bold.ttf
│   ├── HackNerdFontMono-BoldItalic.ttf
│   ├── HackNerdFontMono-Italic.ttf
│   └── HackNerdFontMono-Regular.ttf
│
├── git/
│   ├── commit-template.txt
│   └── gitconfig
│
├── sh/                       # (외부 사용자용 설치 스크립트)
│
├── zsh/
│   ├── .zshrc
│   ├── .p10k.zsh
│   └── aliases/
│       ├── docker.zsh
│       ├── etc.zsh
│       ├── git.zsh
│       ├── help.zsh
│       ├── node.zsh
│       ├── python.zsh
│       ├── search.zsh
│       └── system.zsh
│
├── Brewfile
├── .gitignore
├── .gitattributes
└── README.md
```

---

## 🔧 Requirements (필수 구성 요소)

이 dotfiles가 정상적으로 작동하려면 아래 패키지들이 필요합니다.

### **Homebrew 패키지**

```bash
brew install zsh git fzf fd ripgrep bat eza zoxide vivid zsh-syntax-highlighting
```

### **Framework**

```bash
# Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
  ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
```

---

## 🚀 Installation (sh 파일 설치 방식)

```bash
curl -s https://raw.githubusercontent.com/clorose/dotfiles/main/sh/install.sh | bash
```

또는 직접 clone 후 수동으로 링크할 수도 있습니다:

```bash
git clone https://github.com/clorose/dotfiles ~/dotfiles

ln -sf ~/dotfiles/zsh/.zshrc ~/.zshrc
ln -sf ~/dotfiles/zsh/.p10k.zsh ~/.p10k.zsh

mkdir -p ~/.aliases
ln -sf ~/dotfiles/zsh/aliases/*.zsh ~/.aliases/

mkdir -p ~/.config/git
ln -sf ~/dotfiles/git/commit-template.txt ~/.config/git/commit-template.txt
ln -sf ~/dotfiles/git/gitconfig ~/.gitconfig
```

---

## 🧠 Features

### 🐚 Zsh 환경

* Powerlevel10k 프롬프트
* autosuggestions
* zsh-syntax-highlighting
* locale/editor 설정

### 🔍 검색 & 네비게이션

* **fzf** 기반 help/search UI
* **fd + ripgrep** 기반 빠른 파일/텍스트 검색
* **zoxide** 스마트 cd

### 🎨 색상 테마

* vivid nord 테마로 eza/ls 컬러統一

### 🔧 alias 모듈화

* 시스템/도커/검색/git/node/python 등 기능별 분리된 alias
* 자동 로드됨 (`~/.aliases/*.zsh`)

### 🧩 Git 설정

* 커밋 템플릿 포함
* 개인용 gitconfig 제공

---

## 🎨 Fonts

Powerlevel10k 및 Nerd Font 호환을 위해 Hack Nerd Font Mono 포함.

---
