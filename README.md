# Dotfiles (macOS + WSL)

zsh 기반 개발 환경을 **macOS와 WSL(Ubuntu) 양쪽에 동일하게 재현**하기 위한 저장소입니다.
repo는 하나, branch도 하나 — OS 차이는 설치 스크립트와 셸 설정이 실행 시점에 알아서 분기합니다.

- Shell: **zsh + Oh My Zsh + Powerlevel10k**
- 패키지: **Homebrew** (macOS `/opt/homebrew`, Linux `/home/linuxbrew/.linuxbrew`)
- 런타임: **mise** (node / pnpm / python / rust / dotnet)
- 설정 연결: **GNU stow** (symlink)
- 설치: `./install.sh` 한 번 (단계마다 y/n 확인)

---

## 무엇이 관리되나

| stow 패키지 | 연결되는 파일 | OS |
|---|---|---|
| `zsh` | `~/.zshrc`, `~/.zprofile`, `~/.p10k.zsh`, `~/.aliases/*.zsh` | 공통 |
| `git` | `~/.gitconfig`, `~/.config/git/commit-template.txt`, `~/.config/git/ignore` | 공통 |
| `mise` | `~/.config/mise/config.toml` | 공통 |
| `bat` | `~/.config/bat/config` | 공통 |
| `ghostty` | `~/.config/ghostty/config` | macOS만 |

stow 없이 관리되는 것:

| 경로 | 내용 | 방식 |
|---|---|---|
| `Brewfile` | OS 공통 CLI 패키지 | `brew bundle` |
| `Brewfile.darwin` | cask 전부 + `mas` (macOS 전용) | macOS에서만 `brew bundle` |
| `karabiner/` | 키 리맵 설정 스냅샷 | Karabiner 앱이 폴더를 직접 관리해서 symlink 불가. 변경 시 수동 복사 |
| `Fonts/` | Jetendard (ghostty 폰트, OFL) | `~/Library/Fonts`에 수동 복사 |
| `alfred/` | Alfred 워크플로우 2개 | Alfred에서 수동 Import |

`zsh/.aliases/local.zsh`는 gitignore 대상 — 머신에만 두는 개인 스크립트 자리입니다.

---

## OS 분기 구조

**원칙: 코드 90%는 공통, OS 전용은 "파일"로 분리하고 로드만 분기.**

- `zsh/.aliases/darwin.zsh` — `open`, `diskutil`, `defaults` 등 macOS 명령을 쓰는 alias 모음.
  `.zshrc`가 macOS에서만 로드 (linux 전용이 필요해지면 `linux.zsh`를 만들면 같은 방식으로 동작)
- `Brewfile.darwin` — Linux brew는 cask를 지원하지 않으므로 cask는 전부 여기로
- `zsh/.zprofile` — brew 위치를 자동 감지해서 `shellenv` 실행 (하드코딩 없음)
- `install.sh` — 시작 시 `uname`으로 판별해 macOS 전용 단계(cask, Apple Keychain, Alfred 안내)를 Linux에서 건너뜀

---

## 설치

### macOS

```bash
git clone git@github.com:clorose/dotfiles.git ~/dotfiles
cd ~/dotfiles && chmod +x install.sh && ./install.sh
exec zsh
```

### WSL (Ubuntu)

```bash
# 사전 준비: git, curl, build-essential
sudo apt update && sudo apt install -y git curl build-essential

git clone git@github.com:clorose/dotfiles.git ~/dotfiles
cd ~/dotfiles && chmod +x install.sh && ./install.sh
exec zsh
```

> WSL 참고
> - Homebrew가 없으면 스크립트가 설치를 제안합니다 (`/home/linuxbrew/.linuxbrew`)
> - brew의 zsh를 기본 셸로 쓰려면 `/etc/shells` 등록이 필요한데, 스크립트가 처리합니다 (sudo 필요)
> - 터미널 폰트는 Windows 터미널 쪽 설정이므로 이 repo와 무관

---

## install.sh가 하는 일

각 단계는 실행 전에 y/n으로 물어봅니다. 이미 되어 있는 단계는 감지하고 넘어갑니다.

1. **Homebrew 설치 + Brewfile 적용** (macOS는 `Brewfile.darwin`까지)
2. **Oh My Zsh + Powerlevel10k + zsh-autosuggestions**
3. **stow로 설정 연결** — 기존 파일과 충돌하면 `~/.dotfiles_backup_날짜/`로 백업 후 진행
4. **mise trust + install** — config.toml에 정의된 런타임 설치
5. **FZF 키바인딩** (Ctrl+R 히스토리, Ctrl+T 파일 검색)
6. **Git 사용자 설정 확인**
7. **SSH Key 확인/생성** (`~/.ssh/id_ed25519_github`, macOS는 Keychain 등록까지)
8. **기본 셸을 zsh로 변경**
9. **Alfred 워크플로우 안내** (macOS만)

---

## 설치 후 확인

```bash
echo $SHELL          # zsh인지
mise doctor          # 문제 없는지
node -v && python -V # config.toml 버전과 일치하는지
git config user.name # git 설정 살아있는지
ssh -T git@github.com
```

프롬프트(Powerlevel10k)가 이상하면 터미널 폰트가 Nerd Font인지 확인.

---

## 커스터마이징

| 바꾸고 싶은 것 | 파일 |
|---|---|
| alias 추가/수정 | `zsh/.aliases/` 아래 역할별 파일 (git, docker, system, search, node, python, etc) |
| macOS 전용 alias | `zsh/.aliases/darwin.zsh` |
| 이 머신에서만 쓸 것 | `~/.aliases/local.zsh` (git 추적 안 됨) |
| 런타임 버전 | `mise/.config/mise/config.toml` 수정 후 `mise install` |
| 프롬프트 | `zsh/.p10k.zsh` 또는 `p10k configure` |
| git 설정 | `git/.gitconfig` |

---

## 롤백

```bash
cd ~/dotfiles
stow -D zsh git mise bat            # macOS는 ghostty도
# 백업본 복구: ~/.dotfiles_backup_날짜/ 에서 원위치로
```

---

## 상태 / TODO

- [x] macOS에서 전체 동작 검증
- [ ] WSL에서 install.sh 실제 실행 검증 (분기 코드는 작성됨, 실행 테스트 전)
- [ ] Alfred / Fonts stow 편입 검토
