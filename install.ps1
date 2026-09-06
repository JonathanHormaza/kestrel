Write-Host "====================================================" -ForegroundColor Cyan
Write-Host "    🦅  Welcome to the Kestrel Framework Installer   " -ForegroundColor Cyan
Write-Host "====================================================" -ForegroundColor Cyan
Write-Host ""

$PROJECT_NAME = Read-Host "1. Project Name [my-app]"
if ([string]::IsNullOrWhitespace($PROJECT_NAME)) { $PROJECT_NAME = "my-app" }

$INCLUDE_DB = Read-Host "2. Include PostgreSQL support (SQLx)? (y/n) [y]"
if ([string]::IsNullOrWhitespace($INCLUDE_DB)) { $INCLUDE_DB = "y" }

$INCLUDE_DOCKER = Read-Host "3. Include Docker Compose (PostgreSQL + Caddy)? (y/n) [y]"
if ([string]::IsNullOrWhitespace($INCLUDE_DOCKER)) { $INCLUDE_DOCKER = "y" }

Write-Host "`nCreating project in './$PROJECT_NAME'..." -ForegroundColor Yellow

git clone https://github.com/JonathanHormaza/kestrel.git "$PROJECT_NAME" -q
Set-Location "$PROJECT_NAME"

Remove-Item -Recurse -Force .git -ErrorAction SilentlyContinue
git init -q

if ($INCLUDE_DOCKER -match "^[Nn]$") {
    Remove-Item -Force docker-compose.yml, Caddyfile -ErrorAction SilentlyContinue
}

if ($INCLUDE_DB -match "^[Nn]$") {
    Remove-Item -Recurse -Force migrations -ErrorAction SilentlyContinue
    
    if (Test-Path Cargo.toml) {
        (Get-Content Cargo.toml) | Where-Object { $_ -notmatch 'sqlx' } | Set-Content Cargo.toml
    }

    "SERVER_PORT=3000" | Out-File -FilePath .env -Encoding utf8
} else {
    "DATABASE_URL=postgres://postgres:postgres@localhost:5432/auth_db`nSERVER_PORT=3000" | Out-File -FilePath .env -Encoding utf8
}

Remove-Item -Force install.sh, install.ps1 -ErrorAction SilentlyContinue

Write-Host "`n====================================================" -ForegroundColor Green
Write-Host "  ✅ Project '$PROJECT_NAME' successfully initialized!" -ForegroundColor Green
Write-Host "====================================================" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:"
Write-Host "  cd $PROJECT_NAME" -ForegroundColor Cyan
if ($INCLUDE_DOCKER -match "^[YySs]$") {
    Write-Host "  docker compose up -d" -ForegroundColor Cyan
}
Write-Host "  cargo build`n" -ForegroundColor Cyan
