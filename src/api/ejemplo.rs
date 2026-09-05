use axum::{http::StatusCode, Json};
use serde::Serialize;

#[derive(Serialize)]
pub struct StatusResponse {
    pub estado: &'static str,
    pub uptime_version: &'static str,
}

pub async fn status() -> (StatusCode, Json<StatusResponse>) {
    (
        StatusCode::OK,
        Json(StatusResponse {
            estado: "Operacional",
            uptime_version: "v0.1.0",
        }),
    )
}