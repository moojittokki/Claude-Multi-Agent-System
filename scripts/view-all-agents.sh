#!/bin/bash

# 모든 에이전트를 하나의 tmux 윈도우에서 pane으로 표시

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

# 에이전트 목록 (이름과 표시 라벨)
AGENTS=(
    "orchestrator:Orchestrator"
    "requirement-analyst:Requirements"
    "ux-designer:UX Designer"
    "tech-architect:Tech Architect"
    "planner:Planner"
    "test-designer:Test Designer"
    "developer:Developer"
    "reviewer:Reviewer"
    "documenter:Documenter"
)

SESSION_NAME="multi-agent-view"

# 기존 뷰 세션이 있으면 종료
tmux kill-session -t "$SESSION_NAME" 2>/dev/null

echo "모든 에이전트를 한 화면에 표시하는 세션을 생성합니다..."

# 새로운 세션 생성
tmux new-session -d -s "$SESSION_NAME" -n "agents"

# 상태 표시줄에 조작법 힌트 표시
tmux set-option -t "$SESSION_NAME" status on
tmux set-option -t "$SESSION_NAME" status-style "bg=blue,fg=white"
tmux set-option -t "$SESSION_NAME" status-left "[Grid View] "
tmux set-option -t "$SESSION_NAME" status-left-length 15
tmux set-option -t "$SESSION_NAME" status-right " Ctrl+b,d:나가기 | Ctrl+b,z:전체화면 | Ctrl+b,방향키:이동 "
tmux set-option -t "$SESSION_NAME" status-right-length 60

sleep 1

# 먼저 모든 pane 생성
for i in {1..8}; do
    tmux split-window -t "$SESSION_NAME:0"
    tmux select-layout -t "$SESSION_NAME:0" tiled
done

# 레이아웃 정리
tmux select-layout -t "$SESSION_NAME:0" tiled
sleep 1

# 각 pane에 watch 명령어 전송
for i in {0..8}; do
    agent_name=$(echo "${AGENTS[$i]}" | cut -d: -f1)
    agent_label=$(echo "${AGENTS[$i]}" | cut -d: -f2)

    # watch 명령어 전송
    CMD="watch -n 1 -t 'echo \"[$agent_label]\"; echo; tmux capture-pane -t $agent_name -p -S -30 2>/dev/null || echo \"세션 없음\"'"
    tmux send-keys -t "$SESSION_NAME:0.$i" "$CMD" Enter
    sleep 0.2
done

# 모든 pane을 읽기 전용으로 설정 (실수로 입력하는 것을 방지)
for i in {0..8}; do
    tmux select-pane -t "$SESSION_NAME:0.$i" -d 2>/dev/null || true
done

echo ""
echo "✓ 모든 에이전트 뷰가 준비되었습니다!"
echo ""
echo "사용법:"
echo "  - 각 pane은 1초마다 해당 에이전트 세션의 최근 30줄을 표시합니다"
echo "  - Ctrl+b, 방향키: pane 간 이동"
echo "  - Ctrl+b, z: 현재 pane을 전체화면으로 토글"
echo "  - Ctrl+b, d: 이 화면에서 나가기"
echo ""

# 자동 접속
sleep 1
tmux attach-session -t "$SESSION_NAME"
