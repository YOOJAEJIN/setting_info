#!/usr/bin/env bash
# Herdr + Claude Code 화면 세팅 복원 스크립트
# 사용법: Herdr를 종료한 상태에서  bash install.sh
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HERDR="${HERDR_APP_HOME:-$HOME/.config/herdr-app}"
CLAUDE_DIR="$HOME/.claude"
MOD_DST="$CLAUDE_DIR/mods/prompt-band"
STAMP="$(date +%Y%m%d-%H%M%S)"

backup() { # 기존 파일/폴더가 있으면 .bak-<시각> 으로 보관
  if [ -e "$1" ]; then cp -a "$1" "$1.bak-$STAMP"; echo "  백업: $1.bak-$STAMP"; fi
}

if pgrep -f herdr-app >/dev/null 2>&1; then
  echo "! Herdr가 실행 중입니다. 종료 후 다시 실행하면 레이아웃 선택(shared.json)이 덮어써지지 않습니다."
fi

echo "[1/4] Herdr 설정 복사 → $HERDR"
mkdir -p "$HERDR/themes" "$HERDR/layouts" "$HERDR/mods"
for f in settings.json themes/vscode-light.json layouts/my-main.json; do
  backup "$HERDR/$f"
  cp "$SRC/herdr-app/$f" "$HERDR/$f"
done
backup "$HERDR/mods/material-files"
rm -rf "$HERDR/mods/material-files"
cp -a "$SRC/herdr-app/mods/material-files" "$HERDR/mods/material-files"

echo "[2/4] 레이아웃을 my-main 으로 지정"
python3 - "$HERDR/shared.json" <<'EOF'
import json, os, sys
p = sys.argv[1]
d = {}
if os.path.exists(p):
    try:
        d = json.load(open(p))
    except Exception:
        d = {}
d["layout"] = "my-main"
d.setdefault("workspace.panels", ["files"])
json.dump(d, open(p, "w"), ensure_ascii=False)
EOF

echo "[3/4] Claude Code 질문 띠 모드(prompt-band) 설치 → $MOD_DST"
mkdir -p "$(dirname "$MOD_DST")"
backup "$MOD_DST"
rm -rf "$MOD_DST"
cp -a "$SRC/claude-code/prompt-band" "$MOD_DST"
mkdir -p "$CLAUDE_DIR"
[ -f "$CLAUDE_DIR/settings.json" ] && backup "$CLAUDE_DIR/settings.json"
python3 - "$CLAUDE_DIR/settings.json" "$MOD_DST" <<'EOF'
import json, os, sys
p, mod = sys.argv[1], sys.argv[2]
d = json.load(open(p)) if os.path.exists(p) else {}
env = d.setdefault("env", {})
dirs = [x for x in env.get("CLAUDE_CODE_PLUGIN_DIRS", "").split(":") if x]
if mod not in dirs:
    dirs.append(mod)
env["CLAUDE_CODE_PLUGIN_DIRS"] = ":".join(dirs)
json.dump(d, open(p, "w"), indent=2, ensure_ascii=False)
EOF

echo "[4/4] 폰트 확인"
if fc-list : family | grep -qx "Ubuntu Sans Mono"; then
  echo "  Ubuntu Sans Mono: 설치됨"
else
  echo "  ! Ubuntu Sans Mono 없음 → sudo apt install fonts-ubuntu  (Ubuntu 24.04+)"
fi

echo
echo "완료. Herdr와 Claude Code를 다시 시작하세요."
