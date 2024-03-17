use crate::{commands::Commands, error::Result};
use clap::Parser;
use evdev::{InputEventKind, Key};
use libxdo::XDo;

mod commands;
mod error;

#[tokio::main]
async fn main() -> Result<()> {
    tracing_subscriber::fmt::init();

    let args = commands::Args::parse();
    match args.command {
        Commands::Start {
            device,
            key_to_press,
            key_to_send,
        } => {
            let mut device = evdev::Device::open(device)?;
            let xdo = XDo::new(None)?;

            let key_to_press = Key::new(key_to_press);

            loop {
                for ev in device.fetch_events()? {
                    if ev.event_type() == evdev::EventType::KEY
                        && ev.kind() == InputEventKind::Key(key_to_press)
                    {
                        match ev.value() {
                            0 => {
                                xdo.send_keysequence_up(&key_to_send, 0)?;
                            }
                            1 => {
                                xdo.send_keysequence_down(&key_to_send, 0)?;
                            }
                            _ => {}
                        }
                    }
                }
            }
        }
    }
}
