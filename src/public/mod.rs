use axum::{extract::Request, http::StatusCode, response::Html};

pub async fn handle(request: Request) -> Result<Html<String>, (StatusCode, Html<String>)> {
    let path = request.uri().path();

    let page = if path == "/" {
        "index"
    } else {
        path.trim_start_matches("/")
    };

    let file = format!("src/public/{}.html", page);

    match std::fs::read_to_string(&file) {
        Ok(html) => Ok(Html(html)),

        Err(_) => {
            let error = std::fs::read_to_string("src/public/404.html")
                .unwrap_or_else(|_| "<h1>404 - Página no encontrada</h1>".to_string());

            Err((StatusCode::NOT_FOUND, Html(error)))
        }
    }
}
