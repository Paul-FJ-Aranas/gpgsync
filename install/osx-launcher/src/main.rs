use std::process::Command;

fn main() {
    Command::new("/Applications/Calculator.app/Contents/MacOS/Calculator")
        .spawn()
        .expect("failed to execute process");
}
