use sqlx::{postgres::PgPoolOptions, PgPool};
use std::env;

pub async fn init_db() -> PgPool {
    let database_url = env::var("DATABASE_URL")
        .expect("DATABASE_URL debe estar definida en el archivo .env");

    let pool = PgPoolOptions::new()
        .max_connections(5)
        .connect(&database_url)
        .await
        .expect("Fallo al conectar con la base de datos");

    // Ejecuta las migraciones contenidas en ./migrations
    if let Err(err) = sqlx::migrate!("./migrations").run(&pool).await {
        eprintln!("Aviso de migraciones: {err}");
    }

    pool
}
