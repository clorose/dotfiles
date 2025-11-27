##############################################
# 🧩 Etc Settings (aliases / helper commands)
#    - mise 관련 자주 쓰는 명령만 추림
#    - 나머지는 전부 자동이라 alias 필요 없음
##############################################

# -------------------------
# 🟦 mise: version manager
# -------------------------

# 설치된 버전 목록
alias ml="mise ls"                             # list

# 업데이트 확인 (현재 설정 범위 내)
alias mo="mise outdated"                       # outdated

# 모든 버전 범위 포함해서 확인
alias mob="mise outdated --bump"               # outdated with bump
