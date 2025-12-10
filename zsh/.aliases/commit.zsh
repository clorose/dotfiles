# --------------------------------------------
# 📝 Git Commit Shortcut Aliases
# --------------------------------------------
# Usage examples:
#   gcfeat 로그인 기능 추가   # 따옴표 없어도 OK
# --------------------------------------------

gcfeat()    { git commit -m "✨ Feat: $*"; }
gcfix()     { git commit -m "🐛 Fix: $*"; }
gchot()     { git commit -m "🚑 Hotfix: $*"; }
gcref()     { git commit -m "♻️ Refactor: $*"; }
gcperf()    { git commit -m "⚡️ Perf: $*"; }
gcstyle()   { git commit -m "🎨 Style: $*"; }
gcdocs()    { git commit -m "📝 Docs: $*"; }
gctest()    { git commit -m "✅ Test: $*"; }
gcbuild()   { git commit -m "📦 Build: $*"; }
gcci()      { git commit -m "👷 CI: $*"; }
gcconfig()  { git commit -m "🔧 Config: $*"; }
gcchore()   { git commit -m "🧹 Chore: $*"; }
gcmerge()   { git commit -m "🔀 Merge: $*"; }
gcwip()   { git commit -m "🚧 WIP: $*"; }