#!/bin/bash

# 모든 에이전트 tmux 세션 시작

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
WORKSPACE="$ROOT_DIR/workspace"
AGENTS_DIR="$WORKSPACE/agents"

# 에이전트 목록
AGENTS=(
    "orchestrator"
    "requirement-analyst"
    "ux-designer"
    "tech-architect"
    "planner"
    "test-designer"
    "developer"
    "reviewer"
    "documenter"
)

echo "에이전트 세션 시작 중..."

for agent in "${AGENTS[@]}"; do
    AGENT_DIR="$AGENTS_DIR/$agent"

    # tmux 세션 생성
    tmux new-session -d -s "$agent" -c "$AGENT_DIR"

    # CLAUDE.md 파일을 시스템 프롬프트로 사용하여 claude 실행
    # 파일 내용을 직접 전달하면 길이 제한 문제가 있으므로 --append-system-prompt 사용
    # 메시지와 Enter를 분리하여 전송 (버퍼 문제 방지)
    # 모든 에이전트 Opus 모델 사용
    tmux send-keys -t "$agent:0" "claude --model opus --append-system-prompt \"\$(cat CLAUDE.md)\""
    sleep 0.2
    tmux send-keys -t "$agent:0" C-m

    echo "  ✓ $agent 세션 시작"
    sleep 0.3
done

# orchestrator에게 초기 지시 메시지 전송
echo ""
echo "orchestrator에게 초기 지시 전송 중..."
sleep 2  # claude가 완전히 시작될 때까지 대기

INIT_MESSAGE="당신은 디스패처입니다. 사용자의 프로젝트 요청을 받으면, 절대 직접 코드를 작성하지 말고 반드시 전문 에이전트들(requirement-analyst, ux-designer, tech-architect, planner, test-designer, developer, reviewer, documenter)에게 tmux를 통해 작업을 위임하세요. 각 에이전트에게 작업 지시 시 반드시 status 파일을 working/idle로 업데이트하고, 시그널 대기를 수행하세요."

tmux send-keys -t "orchestrator:0" "$INIT_MESSAGE"
sleep 0.3
tmux send-keys -t "orchestrator:0" C-m

echo "  ✓ orchestrator 초기 지시 완료"

echo ""
echo "모든 에이전트 세션이 시작되었습니다."
echo ""
echo "세션 확인:"
tmux list-sessions 2>/dev/null | grep -E "(orchestrator|requirement-analyst|ux-designer|tech-architect|planner|test-designer|developer|reviewer|documenter)"
