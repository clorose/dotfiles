# ✔️ Dotfiles

개인 개발 환경(Zsh 기반)을 위한 dotfiles 저장소입니다.
Powerlevel10k, fzf, ripgrep, alias 모듈 구조 등을 포함하며 설치 스크립트로 빠르게 적용할 수 있습니다.

---

## 📦 Features

* Zsh + Powerlevel10k 기본 구성
* fzf / ripgrep / bat / eza 등 CLI 유틸리티 사용 환경
* alias 모듈 구조(필요한 기능만 자동 로딩)
* gitconfig + commit-template 포함
* Brewfile을 통한 패키지 일괄 설치
* Nerd Font 제공

---

## 📂 Repository Structure

```zsh
dotfiles/
├── Fonts/
├── git/
├── sh/               # 설치 스크립트
├── zsh/
│   ├── .zshrc
│   ├── .p10k.zsh
│   └── aliases/      # 기능별 alias 모듈
├── Brewfile
└── README.md
```

---

## 🚀 Installation

```bash
git clone https://github.com/<username>/dotfiles.git ~/dotfiles
cd ~/dotfiles/sh
./install.sh
```

설치 스크립트는 다음을 수행합니다:

* dotfiles 심볼릭 링크 생성
* Brewfile 패키지 설치
* zsh 관련 설정 적용
* Nerd Font 설치

---

## ⚙️ Alias Modules

alias는 기능별로 분리되어 있고, `.zshrc`에서 자동으로 조건부 로딩됩니다.

예: docker가 설치된 경우에만 docker.zsh 로딩

```zsh
if command -v docker >/dev/null 2>&1; then
    source "$DOTFILES/zsh/aliases/docker.zsh"
fi
```

### 제공 모듈

| 모듈       | 설명                              |
| ---------- | --------------------------------- |
| docker.zsh | docker / docker-compose 단축 명령 |
| git.zsh    | git 관련 alias                    |
| node.zsh   | node / npm / pnpm 유틸리티        |
| python.zsh | python / pip 관련 명령            |
| system.zsh | 시스템 관리(alias / 유틸)         |
| search.zsh | fd / rg / fzf 관련                |
| help.zsh   | 헬프 함수 + 정리 기능             |
| etc.zsh    | 기타 공용 alias                   |

필요 없는 모듈은 설치하지 않으면 자동으로 로딩되지 않습니다.

---

## 🧩 Zsh Customization

### Powerlevel10k

설정 파일은 다음 경로에 있습니다:

```
zsh/.p10k.zsh
```

테마 설정은 필요하면 자유롭게 수정하면 됩니다.

---

## 🛠 Requirements

* macOS 또는 Linux
* Homebrew(없으면 install.sh에서 자동 설치)
* Zsh 5.8+

---

## 📌 Notes

* dotfiles는 symlink 기반으로 설치됩니다.
* 설치 과정에서 기존 설정 파일이 백업되거나 덮어씌워질 수 있으므로 주의하세요.
* 모든 alias 모듈은 독립적으로 동작하도록 구성했습니다.

---

## 📜 License

MIT

---
