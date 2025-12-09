# --------------------------------------------
# 📝 Git Commit Shortcut Aliases
# --------------------------------------------
# Usage:
#   gcfeat "add new feature"
#   gcfix "resolve crash"
#   gcref "clean up utils"
# --------------------------------------------

gcfeat() {
  git commit -m "✨ Feat: $1"
}

gcfix() {
  git commit -m "🐛 Fix: $1"
}

gchot() {
  git commit -m "🚑 Hotfix: $1"
}

gcref() {
  git commit -m "♻️ Refactor: $1"
}

gcperf() {
  git commit -m "⚡️ Perf: $1"
}

gcstyle() {
  git commit -m "🎨 Style: $1"
}

gcdocs() {
  git commit -m "📝 Docs: $1"
}

gctest() {
  git commit -m "✅ Test: $1"
}

gcbuild() {
  git commit -m "📦 Build: $1"
}

gcci() {
  git commit -m "👷 CI: $1"
}

gcconfig() {
  git commit -m "🔧 Config: $1"
}

gcchore() {
  git commit -m "🧹 Chore: $1"
}

gclog() {
  git commit -m "🔊 Log: $1"
}

gcapi() {
  git commit -m "👽 API: $1"
}

gcdb() {
  git commit -m "🗃️ DB: $1"
}

gcrevert() {
  git commit -m "⏪ Revert: $1"
}
