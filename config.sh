#!/bin/bash

# =============================================================================
# Multi-Agent System Configuration
# =============================================================================
# 이 파일을 수정하여 시스템 설정을 변경할 수 있습니다.
# =============================================================================

# -----------------------------------------------------------------------------
# 에이전트별 Gemini 모델 설정
# 사용 가능한 모델: gemini-1.5-pro, gemini-1.5-flash 등
# -----------------------------------------------------------------------------
MODEL_orchestrator="gemini-1.5-pro"
MODEL_requirement_analyst="gemini-1.5-pro"
MODEL_ux_designer="gemini-1.5-pro"
MODEL_tech_architect="gemini-1.5-pro"
MODEL_planner="gemini-1.5-pro"
MODEL_test_designer="gemini-1.5-pro"
MODEL_developer="gemini-1.5-pro"
MODEL_reviewer="gemini-1.5-pro"
MODEL_documenter="gemini-1.5-pro"

# 에이전트 이름으로 모델 조회 함수
get_model() {
    local agent=$1
    case "$agent" in
        orchestrator) echo "$MODEL_orchestrator" ;;
        requirement-analyst) echo "$MODEL_requirement_analyst" ;;
        ux-designer) echo "$MODEL_ux_designer" ;;
        tech-architect) echo "$MODEL_tech_architect" ;;
        planner) echo "$MODEL_planner" ;;
        test-designer) echo "$MODEL_test_designer" ;;
        developer) echo "$MODEL_developer" ;;
        reviewer) echo "$MODEL_reviewer" ;;
        documenter) echo "$MODEL_documenter" ;;
        *) echo "gemini-1.5-pro" ;;
    esac
}

# -----------------------------------------------------------------------------
# 에이전트 목록
# -----------------------------------------------------------------------------
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

# 초기 단계 에이전트 (구현 단계 진입 시 종료 가능)
PREP_AGENTS=(
    "requirement-analyst"
    "ux-designer"
    "tech-architect"
    "planner"
    "test-designer"
)

# 구현 단계 에이전트
IMPL_AGENTS=(
    "orchestrator"
    "developer"
    "reviewer"
    "documenter"
)

# -----------------------------------------------------------------------------
# 대시보드 설정
# -----------------------------------------------------------------------------
DASHBOARD_PORT=8080
TTYD_START_PORT=7681

# -----------------------------------------------------------------------------
# 기타 설정
# -----------------------------------------------------------------------------
# 작업 결과물 보존 여부 (true: 보존, false: 매 실행시 정리)
PRESERVE_OUTPUT=true

# 로그 보존 여부
PRESERVE_LOGS=false
