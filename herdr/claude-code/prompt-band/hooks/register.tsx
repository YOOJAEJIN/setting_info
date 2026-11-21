import type { Register } from 'claude-code'

// 추천 팔레트 (Ghostty Rose Pine Dawn 베이지 배경 기준). BAND 한 줄만 바꾸면 됩니다.
const PALETTES = {
  gold: { bg: '#fcebcc', fg: '#2a2832' }, // 기본: 따뜻한 골드 + 진한 글씨
  teal: { bg: '#286983', fg: '#ffffff' }, // 가장 강한 대비: 진청록 + 흰 글씨
  rose: { bg: '#eb6f92', fg: '#ffffff' }, // 로즈 핑크 + 흰 글씨
  iris: { bg: '#c4a7e7', fg: '#2a2832' }, // 라벤더 + 진한 글씨
} as const

const BAND = PALETTES.gold

// 질문-답변 쌍 구분선: 각 질문 띠 위에 가로줄을 긋는다.
const RULE = { char: '⎽', color: '#6b6670' }

export const register: Register = on => {
  on('ui.render', { component: 'UserMessage' }, async ($, e, next) => {
    // 터미널에서 내가 직접 입력한 프롬프트만 칠한다. 알림/다른 에이전트 메시지는 그대로.
    if (e.surface !== 'terminal' || e.props.origin.kind !== 'composer') {
      return next(e)
    }
    const { Box, Text } = $.ui.resolve(e)

    const columns = Math.max(10, (e.viewport?.columns ?? 80) - 1)

    return (
      // marginBottom -1: 다음 행(도구 줄·답변)이 앞에 두는 빈 줄 1개를 띠 아래 1/8 여백 줄과 겹쳐 간격을 줄인다
      <Box flexDirection="column" width="100%" marginTop={1} marginBottom={-1}>
        {/* 구분선: 가는 선을 줄 아래쪽(스캔라인 9)에 그어 띠와의 틈을 줄인다 */}
        <Text color={RULE.color} wrap="truncate">
          {RULE.char.repeat(columns + 1)}
        </Text>
        {/* 띠 위 여백 1/8줄 */}
        <Text color={BAND.bg} wrap="truncate">
          {'▁'.repeat(columns + 1)}
        </Text>
        <Box width="100%" backgroundColor={BAND.bg} paddingX={1}>
          <Text color={BAND.fg} backgroundColor={BAND.bg} bold>
            {'❯ '}
            {e.props.text}
          </Text>
        </Box>
        {/* 띠 아래 여백 1/8줄 */}
        <Text color={BAND.bg} wrap="truncate">
          {'▔'.repeat(columns + 1)}
        </Text>
      </Box>
    )
  })
}
