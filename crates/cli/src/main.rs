use crate::{commands::Commands, error::Result};
use clap::Parser;
use evdev::{InputEventKind, Key};

mod commands;
mod error;

#[tokio::main]
async fn main() -> Result<()> {
    tracing_subscriber::fmt::init();

    let args = commands::Args::parse();
    match args.command {
        Commands::Start => {
            let mut device = evdev::Device::open("/dev/input/event5")?;
            let keybind = Key::BTN_EXTRA;

            loop {
                for ev in device.fetch_events()? {
                    if ev.event_type() == evdev::EventType::KEY
                        && ev.kind() == InputEventKind::Key(keybind)
                    {
                        println!("Key event: {:?}", ev);
                    }
                }
            }
        }
    }
}
