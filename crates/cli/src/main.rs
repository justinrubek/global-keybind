use crate::{
    commands::{Commands, HelloCommands},
    error::Result,
};
use clap::Parser;

mod commands;
mod error;

#[tokio::main]
async fn main() -> Result<()> {
    tracing_subscriber::fmt::init();

    let args = commands::Args::parse();
    match args.command {
        Commands::Hello(hello) => {
            let cmd = hello.command;
            match cmd {
                HelloCommands::World => {
                    println!("Hello, world!");
                }
                HelloCommands::Name { name } => {
                    println!("Hello, {}!", name);
                }
            }
        }
    }

    Ok(())
}
