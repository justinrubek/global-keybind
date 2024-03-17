#[derive(thiserror::Error, Debug)]
pub enum Error {
    #[error(transparent)]
    StdIo(#[from] std::io::Error),
    #[error(transparent)]
    XDoCreation(#[from] libxdo::CreationError),
    #[error(transparent)]
    XDoOp(#[from] libxdo::OpError),
}

pub type Result<T> = std::result::Result<T, Error>;
