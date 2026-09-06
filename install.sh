#!/usr/bin/env bash
set -e

GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${CYAN}====================================================${NC}"
echo -e "${CYAN}    🦅  Welcome to the Kestrel Framework Installer   ${NC}"
echo -e "${CYAN}====================================================${NC}\n"

read -p "1. Project Name [my-app]: " PROJECT_NAME < /dev/tty
PROJECT_NAME=${PROJECT_NAME:-my-app}

read -p "2. Include PostgreSQL support (SQLx)? (y/n) [y]: " INCLUDE_DB < /dev/tty
INCLUDE_DB=${INCLUDE_DB:-y}

read -p "3. Include Docker Compose (PostgreSQL + Caddy)? (y/n) [y]: " INCLUDE_DOCKER < /dev/tty
INCLUDE_DOCKER=${INCLUDE_DOCKER:-y}

echo -e "\n${YELLOW}Creating project in './$PROJECT_NAME'...${NC}\n"

git clone https://github.com/JonathanHormaza/kestrel.git "$PROJECT_NAME" -q
cd "$PROJECT_NAME"

rm -rf .git
git init -q

if [[ "$INCLUDE_DOCKER" =~ ^[Nn]$ ]]; then
  rm -f docker-compose.yml Caddyfile
fi

if [[ "$INCLUDE_DB" =~ ^[Nn]$ ]]; then
  rm -rf migrations
  
  if command -v sed >/dev/null 2>&1; then
    sed -i '/sqlx/d' Cargo.toml
  fi

  cat << 'ENVEOF' > .env
SERVER_PORT=3000
ENVEOF
else
  cat << 'ENVEOF' > .env
DATABASE_URL=postgres://postgres:postgres@localhost:5432/auth_db
SERVER_PORT=3000
ENVEOF
fi

rm -f install.sh install.ps1

echo -e "\n${GREEN}====================================================${NC}"
echo -e "${GREEN}  ✅ Project '$PROJECT_NAME' successfully initialized!${NC}"
echo -e "${GREEN}====================================================${NC}\n"

echo -e "Next steps:"
echo -e "  ${CYAN}cd $PROJECT_NAME${NC}"
if [[ "$INCLUDE_DOCKER" =~ ^[YySs]$ ]]; then
  echo -e "  ${CYAN}docker compose up -d${NC}"
fi
echo -e "  ${CYAN}cargo build${NC}\n"
