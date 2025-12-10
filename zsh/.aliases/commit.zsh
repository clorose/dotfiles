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

# --------------------------------------------
# 🎭 Git Commit Mood Aliases (Silly / Optional)
# --------------------------------------------
# Usage examples:
#   gczzz README 한 줄 손봄
#   gcfun 버튼 색깔만 바꿔봄
# --------------------------------------------

gczzz()      { git commit -m "🥱 Zzz: $*"; }
gcwaste()    { git commit -m "🕰️ Waste: $*"; }
gcfun()      { git commit -m "🎮 Fun: $*"; }
gclook()     { git commit -m "👁️‍🗨️ Looking: $*"; }
gcideas()    { git commit -m "🧠 Ideas: $*"; }
gcclean()    { git commit -m "🧹 Clean: $*"; }
gcsettings() { git commit -m "🛠️ Settings: $*"; }
gctiny()     { git commit -m "🐾 Tiny: $*"; }
gchappy()    { git commit -m "🤗 Happy: $*"; }
gcturtle()   { git commit -m "🐢 Turtle: $*"; }
gcsleep()    { git commit -m "🛏 Sleep: $*"; }
gcaltf4()    { git commit -m "😡 AltF4: $*"; }