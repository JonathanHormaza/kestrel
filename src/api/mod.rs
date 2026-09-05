use axum::{routing::get, Router};
use sqlx::PgPool;

mod ejemplo;

pub fn routes() -> Router<PgPool> {
    Router::new()
        .route("/status", get(ejemplo::status))
}