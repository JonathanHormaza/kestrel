# 🦅 Kestrel Server|Web Framework

**Kestrel** es una plantilla de desarrollo (boilerplate) ultrarrápida, segura y neutra para construir APIs en Rust. Combina **Axum**, **PostgreSQL** y **Caddy** en un entorno containerizado con defensas integradas listas para producción.

---

## ⚡ Características Principales

- **Arquitectura Neutra:** Sin esquemas predefinidos ni acoplamiento de dominio. Diseñado para construir cualquier modelo desde cero.
- **Proxy Inverso Seguro:** Caddy 2 administrando cabeceras de seguridad estrictas (`HSTS`, `X-Frame-Options`, `X-Content-Type-Options`).
- **Control de Tráfico (Rate Limiting):** Aislamiento de peticiones por IP vía `tower-governor` para mitigar ataques DoS.
- **Persistencia Asíncrona:** PostgreSQL 16 integrado con `SQLx` y soporte nativo para migraciones.
- **Manejo Seguro de Estáticos:** Normalización de rutas para prevención de ataques de *Directory Traversal*.

---

## 📋 Requisitos Previos

Asegúrate de tener instalados los siguientes componentes en tu sistema:

- [Rust & Cargo](https://www.rust-lang.org/) (Edición 2021)
- [Docker](https://www.docker.com/) & [Docker Compose](https://docs.docker.com/compose/)
- [SQLx CLI](https://github.com/launchbadge/sqlx) (Opcional, para administrar migraciones):
  ```bash
  cargo install sqlx-cli --no-default-features --features postgres

  ff
