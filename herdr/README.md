# Herdr + Claude Code 화면 세팅

다른 PC에서도 같은 Herdr 화면(폰트, 배경색, 패널)과 Claude Code 질문 띠를 쓰기 위한 설정 모음입니다.

## 설치

```bash
git clone https://github.com/YOOJAEJIN/setting_info.git
cd setting_info/herdr
# Herdr를 종료한 뒤
bash install.sh
```

기존 파일은 덮어쓰기 전에 `*.bak-<시각>` 으로 백업됩니다. 끝나면 Herdr와 Claude Code를 다시 시작하세요.

## 들어 있는 것

| 파일 | 설치 위치 | 내용 |
|---|---|---|
| `herdr-app/settings.json` | `~/.config/herdr-app/` | 폰트 `Ubuntu Sans Mono` 14, 굵기 400, 칸 폭 0.94, 줄 높이 1.15, 줌 1.2, 테마 `vscode-light` |
| `herdr-app/themes/vscode-light.json` | `~/.config/herdr-app/themes/` | 터미널 배경·사이드바(`chrome`) `#f9f7ee` (연한 누런빛), 바탕(`canvas`) `#f3f3f3` |
| `herdr-app/layouts/my-main.json` | `~/.config/herdr-app/layouts/` | 기본 main 레이아웃 + 오른쪽 Files 패널을 `material-files`로 |
| `herdr-app/mods/material-files/` | `~/.config/herdr-app/mods/` | Material 아이콘 Files 패널. 배경은 사이드바와 같은 `chrome` 색 |
| `claude-code/prompt-band/` | `~/.claude/mods/prompt-band` | Claude Code 질문 띠 모드 (아래) |

`install.sh`는 `~/.config/herdr-app/shared.json`의 레이아웃을 `my-main`으로 지정하고, `~/.claude/settings.json`의 `env.CLAUDE_CODE_PLUGIN_DIRS`에 모드 경로를 추가합니다.

## Claude Code 질문 띠 (prompt-band)

터미널에서 내가 입력한 질문을 눈에 띄게 그려 질문/답변 쌍을 구분합니다.

- 질문 위에 가는 회색 구분선(`#6b6670`)
- 질문 배경 띠 `#fcebcc` + 진한 굵은 글씨, 띠 위아래 1/8줄 여백
- 다른 색으로 바꾸려면 `hooks/register.tsx`의 `PALETTES` 값이나 `const BAND = PALETTES.gold` 를 수정

수동으로 한 세션만 써 보려면: `claude --plugin-dir ~/.claude/mods/prompt-band`

## 참고

- 한글은 Herdr가 시스템 폰트(Noto Sans CJK)로 대신 그립니다. 없으면 `sudo apt install fonts-noto-cjk`.
- 테마 파일을 바꾼 뒤 색이 그대로면 Herdr 설정에서 테마를 다른 것으로 바꿨다가 `vscode-light`로 다시 고르면 적용됩니다.
