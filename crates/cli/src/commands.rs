#[derive(clap::Parser, Debug)]
#[command(author, version, about, long_about = None)]
pub(crate) struct Args {
    #[clap(subcommand)]
    pub command: Commands,
}

#[derive(clap::Subcommand, Debug)]
pub(crate) enum Commands {
    Start {
        /// the device to read events from
        #[clap(long, short)]
        device: String,
        /// the key to press to trigger the event
        #[clap(long, short = 'p')]
        key_to_press: u16,
        /// the key to send when the event is triggered
        #[clap(long, short = 's')]
        key_to_send: String,
    },
}
