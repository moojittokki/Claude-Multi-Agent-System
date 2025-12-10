#!/bin/bash

# =============================================================================
# Multi-Agent System - Setup Script
# =============================================================================
# 의존성 확인 및 초기 설정을 수행합니다
# =============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo ""
echo "========================================"
echo "  Multi-Agent System Setup"
echo "========================================"
echo ""

# -----------------------------------------------------------------------------
# 의존성 확인
# -----------------------------------------------------------------------------

echo -e "${CYAN}[STEP]${NC} 의존성 확인 중..."
echo ""

check_command() {
    if command -v "$1" &> /dev/null; then
        return 0
    else
        return 1
    fi
}

MISSING_DEPS=()

# Node.js
if check_command node; then
    echo -e "${GREEN}[OK]${NC} Node.js: $(node --version)"
else
    MISSING_DEPS+=("node")
    echo -e "${RED}[MISSING]${NC} Node.js - ${CYAN}brew install node${NC}"
fi

# npm
if check_command npm; then
    echo -e "${GREEN}[OK]${NC} npm: $(npm --version)"
else
    MISSING_DEPS+=("npm")
    echo -e "${RED}[MISSING]${NC} npm - ${CYAN}brew install node${NC}"
fi

# tmux
if check_command tmux; then
    echo -e "${GREEN}[OK]${NC} tmux: $(tmux -V)"
else
    MISSING_DEPS+=("tmux")
    echo -e "${RED}[MISSING]${NC} tmux - ${CYAN}brew install tmux${NC}"
fi

# Claude CLI
if check_command claude; then
    echo -e "${GREEN}[OK]${NC} Claude CLI: 설치됨"
else
    MISSING_DEPS+=("claude")
    echo -e "${RED}[MISSING]${NC} Claude CLI - ${CYAN}npm install -g @anthropic-ai/claude-code${NC}"
fi

# ttyd (optional, for dashboard)
if check_command ttyd; then
    echo -e "${GREEN}[OK]${NC} ttyd: 설치됨 (웹 대시보드용)"
else
    echo -e "${YELLOW}[OPTIONAL]${NC} ttyd - ${CYAN}brew install ttyd${NC} (웹 대시보드용)"
fi

echo ""

# 필수 의존성 누락 시 종료
if [ ${#MISSING_DEPS[@]} -gt 0 ]; then
    echo -e "${RED}[ERROR]${NC} 위의 누락된 의존성을 먼저 설치해주세요."
    echo ""
    exit 1
fi

# -----------------------------------------------------------------------------
# npm 의존성 설치
# -----------------------------------------------------------------------------

echo -e "${CYAN}[STEP]${NC} npm 의존성 설치 중..."
echo ""

DASHBOARD_DIR="$SCRIPT_DIR/packages/dashboard"
if [ -d "$DASHBOARD_DIR" ]; then
    if [ ! -d "$DASHBOARD_DIR/node_modules" ]; then
        echo -e "${BLUE}[INFO]${NC} 대시보드 의존성 설치 중..."
        cd "$DASHBOARD_DIR"
        npm install --silent 2>/dev/null
        cd "$SCRIPT_DIR"
        echo -e "${GREEN}[OK]${NC} 대시보드 의존성 설치 완료"
    else
        echo -e "${GREEN}[OK]${NC} 대시보드 의존성 이미 설치됨"
    fi
fi

# -----------------------------------------------------------------------------
# 워크스페이스 초기화
# -----------------------------------------------------------------------------

echo ""
echo -e "${CYAN}[STEP]${NC} 워크스페이스 초기화 중..."
echo ""

bash "$SCRIPT_DIR/scripts/setup-workspace.sh"
echo -e "${GREEN}[OK]${NC} 워크스페이스 초기화 완료"

# -----------------------------------------------------------------------------
# 완료
# -----------------------------------------------------------------------------

echo ""
echo "========================================"
echo -e "${GREEN}  Setup 완료!${NC}"
echo "========================================"
echo ""
echo "시작하기:"
echo -e "  ${CYAN}./run.sh${NC}"
echo ""
