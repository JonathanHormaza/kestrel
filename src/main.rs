use axum::Router;
use std::sync::Arc;
use std::{
    io::{self, Write},
    net::{SocketAddr, UdpSocket},
};
use tokio::{sync::oneshot, task::JoinHandle};
use tower_governor::{
    governor::GovernorConfigBuilder, key_extractor::PeerIpKeyExtractor, GovernorLayer,
};

mod api;
mod db;
mod public;

#[tokio::main]
async fn main() {
    dotenvy::dotenv().ok();
    let pool = db::init_db().await;

    let governor_conf = Arc::new(
        GovernorConfigBuilder::default()
            .per_second(1)
            .burst_size(5)
            .key_extractor(PeerIpKeyExtractor)
            .finish()
            .unwrap(),
    );

    let app = Router::new()
        .nest("/api", api::routes())
        .with_state(pool)
        .fallback(public::handle)
        .layer(GovernorLayer {
            config: governor_conf,
        });

    let mut server: Option<RunningServer> = None;

    loop {
        println!("\n=== Control del servidor ===");
        println!("1. Reiniciar servidor");
        println!("2. Apagar servidor");
        print!("Selecciona una opción: ");
        io::stdout().flush().expect("No se pudo mostrar el menú");

        let mut option = String::new();

        if io::stdin().read_line(&mut option).is_err() {
            eprintln!("No se pudo leer la opción");
            continue;
        }

        match option.trim() {
            "1" => {
                if let Some(running_server) = server.take() {
                    stop_server(running_server).await;
                    println!("Servidor detenido. Reiniciando...");
                }

                match start_server(app.clone()).await {
                    Ok(running_server) => server = Some(running_server),
                    Err(error) => eprintln!("No se pudo iniciar el servidor: {error}"),
                }
            }

            "2" => {
                if let Some(running_server) = server.take() {
                    stop_server(running_server).await;
                }

                println!("Servidor apagado.");
                break;
            }

            _ => println!("Opción no válida. Escribe 1 o 2."),
        }
    }
}

struct RunningServer {
    shutdown: oneshot::Sender<()>,
    handle: JoinHandle<()>,
}

async fn start_server(app: Router) -> Result<RunningServer, std::io::Error> {
    let listener = tokio::net::TcpListener::bind("0.0.0.0:8080").await?;
    let (shutdown, shutdown_signal) = oneshot::channel();
    let ip = get_local_ip();

    let handle = tokio::spawn(async move {
        if let Err(error) = axum::serve(
            listener,
            app.into_make_service_with_connect_info::<SocketAddr>(),
        )
        .with_graceful_shutdown(async move {
            let _ = shutdown_signal.await;
        })
        .await
        {
            eprintln!("Error en el servidor: {error}");
        }
    });

    println!("Servidor iniciado: http://{}:8080", ip);

    Ok(RunningServer { shutdown, handle })
}

async fn stop_server(server: RunningServer) {
    let _ = server.shutdown.send(());
    let _ = server.handle.await;
}

fn get_local_ip() -> std::net::IpAddr {
    let socket = UdpSocket::bind("0.0.0.0:0").expect("No se pudo crear el socket");

    socket
        .connect("8.8.8.8:80")
        .expect("No se pudo detectar la IP");

    socket.local_addr().expect("No se pudo obtener la IP").ip()
}
