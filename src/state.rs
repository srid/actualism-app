//! Application state

use dioxus_signals::Signal;

#[derive(Clone, Copy)]
pub struct AppState {
    _name: Signal<String>,
}

impl AppState {
    pub fn new() -> Self {
        let name = std::env::var("USER").unwrap_or("world".to_string());
        Self {
            _name: Signal::new(name),
        }
    }
}
