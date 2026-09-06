# 🦅 Kestrel Web Framework

**Kestrel** is a lightning-fast, modular, unopinionated, and production-ready Web Framework / Boilerplate built in Rust. It combines the power of **Axum**, asynchronous persistence with **PostgreSQL 16**, IP-based rate limiting via **`tower-governor`**, and perimeter security with **Caddy 2**.

---

## 📋 Prerequisites

Before installing Kestrel, ensure you have the following installed on your system:

- **[Rust & Cargo](https://www.rust-lang.org/tools/install)** (2021 edition)
- **[Git](https://git-scm.com/)** (To clone the project)
- **[Docker & Docker Compose](https://docs.docker.com/get-docker/)** (Optional, to orchestrate PostgreSQL and Caddy)

---

## 🚀 Quick Start (One-Step Installation)

The interactive installer will prompt you to choose the project name, whether to include PostgreSQL support (SQLx), and Docker/Caddy integration.

---

### 🐧 Linux (Fedora, Debian, Mint, Arch, Ubuntu) / 🍎 macOS

Open your terminal and run:

```bash
curl -sSL [https://raw.githubusercontent.com/JonathanHormaza/kestrel/main/install.sh](https://raw.githubusercontent.com/JonathanHormaza/kestrel/main/install.sh) | bash
```

### 🪟 Windows (PowerShell)

Open PowerShell and run:

```powershell
iwr -useb [https://raw.githubusercontent.com/JonathanHormaza/kestrel/main/install.ps1](https://raw.githubusercontent.com/JonathanHormaza/kestrel/main/install.ps1) | iex
```

---

### ⚙️ Next Steps

Once the interactive setup is complete, navigate into your newly generated folder and spin up the environment:

```bash
# 1. Start the infrastructure (PostgreSQL database + Caddy proxy)
docker compose up -d

# 2. Build and run the Rust application
cargo run
```

---

### 🛠️ Project Structure

```plaintext
├── Caddyfile            # Reverse proxy configuration & security headers
├── docker-compose.yml   # PostgreSQL 16 & Caddy 2 container orchestration
├── install.sh           # Interactive setup script for Linux & macOS
├── install.ps1          # Interactive setup script for Windows PowerShell
├── migrations/          # Native SQL migrations managed by SQLx
├── src/
│   ├── api/             # REST endpoints and controllers
│   ├── public/          # Static file server and secure 404 fallback
│   ├── db.rs            # PostgreSQL connection pool setup
│   └── main.rs          # Axum initialization, middleware & router
└── Cargo.toml           # Rust package dependencies
```

---

### 🛡️ Built-in Security Features

• DoS Defense: Automatic IP-based rate limiting powered by tower-governor.

• Security Headers: Automatic header injection via Caddy (HSTS, X-Frame-Options, X-Content-Type-Options).

• Path Sanitization: Route normalization to prevent Directory Traversal attacks.

---

### 📄 License

This project is licensed under the MIT License.
>>>>>>> 12f353c (fix: README)
