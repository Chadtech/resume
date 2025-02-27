use actix_web::{get, App, HttpResponse, HttpServer, Responder};
use clap::Parser;
use notify::event::ModifyKind;
use notify::{EventKind, RecommendedWatcher, RecursiveMode, Watcher};
use std::process::Command;

#[derive(Debug, Parser, Clone)]
#[clap(
    author = "Chad Stearns",
    version = "0.1",
    about = "Commands for developing and deploying my resume"
)]
enum Cmd {
    Dev,
    DeployPdf,
    DeployWebsite,
    DevThankYou { recipient: String },
    DeployThankYou { recipient: String, suffix: String },
}

const VIEW_FORMAT_MODULE: &str = r#"module ViewFormat exposing
    ( ViewFormat(..)
    , viewFormat
    )

{-|

    This module is generated by the Rust program in src/main.rs.
    Do not edit it directly.

-}


type ViewFormat
    = Web
    | Pdf
    | ThankYou { recipient : String, message : String }


viewFormat : ViewFormat
viewFormat =
    ${view_format}
"#;

enum ViewFormat {
    Web,
    Pdf,
    ThankYou { recipient: String, message: String },
}

#[actix_web::main]
async fn main() -> Result<(), String> {
    let cmd = Cmd::parse();

    match cmd {
        Cmd::Dev => {
            std::thread::spawn(|| {
                if let Err(err) = compile_elm_and_file_watch() {
                    println!("{}", err);
                };
            });

            generate_view_format_file(ViewFormat::Web)?;

            run_server().await
        }
        Cmd::DeployPdf => deploy(
            ViewFormat::Pdf,
            "chad-stearns-resume-pdf.surge.sh".to_string(),
        ),
        Cmd::DeployWebsite => deploy(ViewFormat::Web, "chad-stearns-resume.surge.sh".to_string()),
        Cmd::DevThankYou { recipient } => {
            let msg = get_thank_you_message()?;

            generate_view_format_file(ViewFormat::ThankYou {
                recipient,
                message: msg,
            })?;

            std::thread::spawn(|| {
                if let Err(err) = compile_elm_and_file_watch() {
                    println!("{}", err);
                };
            });

            run_server().await
        }
        Cmd::DeployThankYou { recipient, suffix } => {
            let msg = get_thank_you_message()?;

            let mut domain = "chad-stearns-thank-you-".to_string();
            domain.push_str(suffix.as_str());
            domain.push_str(".surge.sh");

            deploy(
                ViewFormat::ThankYou {
                    recipient,
                    message: msg,
                },
                domain,
            )
        }
    }
}

#[get("/")]
async fn html() -> impl Responder {
    HttpResponse::Ok().body(include_str!("./index.html"))
}

#[get("/elm.js")]
async fn elm_js() -> impl Responder {
    match std::fs::read("./public/elm.js") {
        Ok(data) => HttpResponse::Ok().body(data),
        Err(err) => HttpResponse::InternalServerError().body(err.to_string()),
    }
}

async fn run_server() -> Result<(), String> {
    let r = HttpServer::new(|| App::new().service(html).service(elm_js))
        .bind(("127.0.0.1", 1754))
        .map_err(|err| err.to_string())?
        .run()
        .await
        .map_err(|err| err.to_string())?;

    Ok(r)
}

fn get_thank_you_message() -> Result<String, String> {
    let thank_you_file_name = "thank_you.txt";
    std::fs::read_to_string(thank_you_file_name).map_err(|err| err.to_string())
}

fn deploy(view_format: ViewFormat, domain: String) -> Result<(), String> {
    generate_view_format_file(view_format)?;

    Command::new("elm")
        .args(["make", "./src/Main.elm", "--output=./public/elm.js"])
        .spawn()
        .map_err(|err| err.to_string())?
        .wait()
        .map_err(|err| err.to_string())?;

    put_index_in_public()?;

    Command::new("surge")
        .args(["./public", domain.as_str()])
        .spawn()
        .map_err(|err| err.to_string())?
        .wait()
        .map_err(|err| err.to_string())?;

    Ok(())
}

fn put_index_in_public() -> Result<(), String> {
    std::fs::copy("./src/index.html", "./public/index.html")
        .map_err(|err| err.to_string())
        .map(|_| ())
}

fn generate_view_format_file(view_format: ViewFormat) -> Result<(), String> {
    let view_format_str: String = match view_format {
        ViewFormat::Web => "Web".to_string(),
        ViewFormat::Pdf => "Pdf".to_string(),
        ViewFormat::ThankYou { recipient, message } => {
            let mut buf = "ThankYou { recipient = \"".to_string();
            buf.push_str(recipient.as_str());
            buf.push_str("\", message = \"\"\"");
            buf.push_str(message.as_str());
            buf.push_str("\"\"\" }");

            buf
        }
    };

    let content = VIEW_FORMAT_MODULE.replace("${view_format}", view_format_str.as_str());

    std::fs::write("./src/ViewFormat.elm", content).map_err(|err| err.to_string())
}

fn compile_elm_and_file_watch() -> Result<(), String> {
    let run_cmd = |from_cmd: fn(&mut Command) -> Result<(), String>| {
        from_cmd(Command::new("elm").args(["make", "./src/Main.elm", "--output=./public/elm.js"]))
    };

    println!("Compiling Elm");
    run_cmd(|cmd| cmd.spawn().map(|_| ()).map_err(|err| err.to_string()))?;

    let (tx, rx) = std::sync::mpsc::channel();

    let mut watcher =
        RecommendedWatcher::new(tx, notify::Config::default()).map_err(|err| err.to_string())?;

    watcher
        .watch("./src".as_ref(), RecursiveMode::Recursive)
        .unwrap();

    for res in rx {
        match res {
            Ok(event) => {
                let mut any_elm = false;

                for path in event.paths {
                    let file_extension = path.extension().and_then(|ext| ext.to_str());
                    if let Some("elm") = file_extension {
                        if let EventKind::Modify(ModifyKind::Data(_)) = event.kind {
                            any_elm = true;
                        }
                    }
                }

                if any_elm {
                    run_cmd(|cmd| cmd.spawn().map(|_| ()).map_err(|err| err.to_string())).unwrap();
                }
            }
            Err(err) => {
                println!("{}", err);
            }
        }
    }

    Ok(())
}
