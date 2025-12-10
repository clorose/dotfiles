# Dotfiles (macOS / Zsh)

개인 개발 환경(Zsh 기반)을 위한 dotfiles 저장소입니다.  
**제 맥 환경을 1:1로 재현해서 그대로 쓰는 것**이 기본 전제입니다.

- "이 셋업 괜찮다" 싶으면 **그냥 클론해서 설치 스크립트 돌리고 그대로 쓰면 됩니다.**
- 쓰다 보니 특정 부분이 마음에 안 들면, 그때 **포크해서 자기 입맛대로 수정**하면 됩니다.

- Shell: **zsh + Oh My Zsh + Powerlevel10k**
- Runtime: **mise** (node / pnpm / python / rust)
- Tools: **fzf, ripgrep, zoxide, vivid, git-delta** 등
- Alias: 역할별 모듈 분리 (`git.zsh`, `docker.zsh`, `system.zsh` 등)
- 설치: **레포 루트의 `install` 한 번 실행**으로 대부분 자동 적용

> ⚠️ 이 레포는 "내 환경 그대로"를 통째로 적용하는 **opinionated 세트**입니다.  
> - 기본 사용법: README대로 따라 해서 **그냥 이 셋업을 그대로 쓰는 것**  
> - 커스터마이징: 일부가 마음에 안 들면, 그때 포크하거나 파일만 골라서 바꿔 쓰면 됩니다.

---

## 📁 Repo 구조

```zsh
.
├── alfred
│   ├── Obsidian Vault Changer.alfredworkflow
│   └── VSCode Project Manager.alfredworkflow
├── Fonts
│   ├── HackNerdFontMono-Bold.ttf
│   ├── HackNerdFontMono-BoldItalic.ttf
│   ├── HackNerdFontMono-Italic.ttf
│   └── HackNerdFontMono-Regular.ttf
├── git
│   ├── .config
│   │   └── git
│   │       └── commit-template.txt
│   └── .gitconfig
├── mise
│   └── .config
│       └── mise
│           └── config.toml
├── zsh
│   ├── .aliases
│   │   ├── commit.zsh
│   │   ├── docker.zsh
│   │   ├── etc.zsh
│   │   ├── git.zsh
│   │   ├── help.zsh
│   │   ├── node.zsh
│   │   ├── python.zsh
│   │   ├── search.zsh
│   │   └── system.zsh
│   ├── .p10k.zsh
│   └── .zshrc
├── .gitattributes
├── .gitignore
├── Brewfile
├── install
└── README.md
```

### 주요 디렉토리 역할

* **`zsh/`**
  * `~/.zshrc`, `~/.p10k.zsh`, `~/.aliases/*.zsh` 관리
  * alias를 역할별 파일로 분리 (`git.zsh`, `docker.zsh`, `system.zsh`, `search.zsh` 등)

* **`git/`**
  * 글로벌 Git 설정: `~/.gitconfig`
  * 커밋 템플릿: `~/.config/git/commit-template.txt`

* **`mise/`**
  * `~/.config/mise/config.toml`
  * 전역 기본 런타임 버전(node / pnpm / python / rust) 정의

* **`alfred/`**
  * Alfred 워크플로우 (`.alfredworkflow`)
  * 자동 설치까지는 안 하고, **필요하면 Alfred에서 수동 Import**해서 사용

* **`Fonts/`**
  * Hack Nerd Font 등 폰트 파일
  * 직접 `~/Library/Fonts`로 복사해서 사용 (원하면 나중에 stow로 묶어도 됨)

* **`install`**
  * macOS에서 한 번 실행해서 위 설정들을 순서대로 적용하는 스크립트

---

## ⚙️ 전제 / 제한 사항

* OS: **macOS (Apple Silicon 기준)**
  * Homebrew, `ssh-add --apple-use-keychain`, `chsh` 등 macOS 전제 코드 포함
* 기본 Shell을 **zsh**로 변경합니다.
* 기존 `~/.zshrc`, `~/.p10k.zsh`, `~/.gitconfig` 등과 **충돌하는 경우**:
  * 스크립트가 자동으로 `~/.dotfiles_backup_YYYYMMDD_HHMMSS/` 아래로 백업 후 덮어씁니다.

---

## 🚀 빠른 시작 (Quick Start)

새 맥 세팅할 때 기본 시나리오:

```bash
# 1. 레포 클론
git clone git@github.com:clorose/dotfiles.git ~/dotfiles

# 2. 설치 스크립트 실행
cd ~/dotfiles
chmod +x install
./install

# 3. 터미널 완전히 닫았다가 다시 열기
exec zsh
```

끝!

---

## 🛠 설치 시 스크립트가 하는 일

`./install` 실행 시, 다음 순서로 진행합니다:

1. **충돌 파일 자동 백업**
   * `~/.zshrc`, `~/.p10k.zsh`, `~/.gitconfig`, `~/.config/git/commit-template.txt`, `~/.config/mise/config.toml` 등 기존 파일이 있으면
   * `~/.dotfiles_backup_YYYYMMDD_HHMMSS/` 아래로 자동 백업

2. **Homebrew 설치 + Brewfile 적용**
   * Homebrew 미설치 시 자동 설치
   * `Brewfile` 기반으로 필수 도구 일괄 설치:
     * `zsh`, `git`, `stow`, `mise`, `fzf`, `ripgrep`, `zoxide`, `vivid`, `bat`, `eza`, `git-delta`, `zsh-syntax-highlighting` 등

3. **Oh My Zsh + Powerlevel10k + 플러그인**
   * `~/.oh-my-zsh` 자동 설치
   * 테마: `powerlevel10k/powerlevel10k`
   * 플러그인: `git`, `zsh-autosuggestions`, `colored-man-pages`, `extract`, `zsh-syntax-highlighting`

4. **stow로 dotfiles 심볼릭 링크 생성**
   * `stow zsh git mise` 실행
   * 결과:
     * `zsh/.zshrc` → `~/.zshrc`
     * `zsh/.p10k.zsh` → `~/.p10k.zsh`
     * `zsh/.aliases/*.zsh` → `~/.aliases/*.zsh`
     * `git/.gitconfig` → `~/.gitconfig`
     * `git/.config/git/commit-template.txt` → `~/.config/git/commit-template.txt`
     * `mise/.config/mise/config.toml` → `~/.config/mise/config.toml`

5. **mise 설정 및 글로벌 런타임 설치**
   * `mise trust` 자동 실행
   * `mise install` 자동 실행
     → `config.toml`에 정의된 node / pnpm / python / rust 설치

6. **FZF 키바인딩 설치**
   * Ctrl+R (명령어 히스토리), Ctrl+T (파일 검색) 등 키바인딩 자동 설정

7. **Git 설정 확인**
   * `git config --global user.name/email` 확인
   * 미설정 시 수동 설정 안내 출력

8. **SSH Key 확인**
   * `~/.ssh/id_ed25519_github` 존재 시: Apple Keychain에 자동 추가
   * 없는 경우: SSH Key 생성 방법 안내

9. **기본 Shell을 zsh로 변경**
   * `chsh -s $(which zsh)` 자동 실행

10. **Alfred / Fonts 안내**
    * Alfred 워크플로우: `alfred/*.alfredworkflow`를 수동 Import 안내
    * Fonts: `Fonts/` 폴더의 폰트를 수동 설치 안내

---

## ✅ 설치 후 체크리스트

설치가 끝났으면, 다음 정도만 확인하면 충분합니다:

1. **Shell / 프롬프트**
   * `echo $SHELL` 결과에 `zsh` 포함 여부
   * 새 터미널에서 Powerlevel10k 프롬프트 정상 출력 여부

2. **Alias / 명령어**
   * `ls`, `l`, `ll` 입력 시 `eza` 기반 출력인지
   * `gs`, `gc`, `gca`, `gps` 등 git alias 동작 여부

3. **mise**
   * `mise doctor`
   * `node -v`, `python --version`, `pnpm -v`, `rustc --version` 등이 `config.toml` 의도와 맞는지

4. **Git**
   * `git config --global --list`에서:
     * `user.name`, `user.email`
     * `commit.template` (커밋 템플릿 경로)
   * 커밋 메시지 작성 시 템플릿이 뜨는지

5. **SSH**
   * `ssh -T git@github.com` 테스트
     → GitHub 계정 환영 메시지가 나오면 정상

---

## 🎨 커스터마이징 포인트

* **zsh / 프롬프트 / alias**
  * 프롬프트: `zsh/.p10k.zsh`
  * 기본 설정: `zsh/.zshrc`
  * alias:
    * 공통/잡다: `zsh/.aliases/etc.zsh`
    * git: `zsh/.aliases/git.zsh`
    * docker: `zsh/.aliases/docker.zsh`
    * 시스템: `zsh/.aliases/system.zsh`
    * 검색/grep: `zsh/.aliases/search.zsh`
    * node/python 관련: `zsh/.aliases/node.zsh`, `zsh/.aliases/python.zsh`

* **mise 버전 전략**
  * `mise/.config/mise/config.toml` 수정 후 `mise install` 다시 실행
  * 새 런타임 버전으로 전환 가능

* **Git**
  * `git/.gitconfig`에서 alias, 색상, diff 툴, 템플릿 경로 등 수정

---

## 🧹 되돌리기(롤백)

* 설치할 때 백업된 파일들은 `~/.dotfiles_backup_YYYYMMDD_HHMMSS/` 아래에 있습니다.
* 완전히 되돌리려면:
  1. `stow -D zsh git mise`로 심볼릭 링크 해제
  2. 백업 디렉토리에서 원래 위치로 파일을 복구

---

## 🗺️ TODO

* [ ] 리눅스 / WSL 환경 분기
* [ ] Alfred / Fonts를 stow 타겟으로 완전히 편입

---

## License

* 이 레포는 **"그대로 가져다 써도 되는 개인 셋업"**입니다.
* 마음에 들면 그냥 클론해서 그대로 쓰면 되고, 필요하면 포크해서 자기 환경에 맞게 바꿔 써도 됩니다.