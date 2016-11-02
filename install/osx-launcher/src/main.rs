use std::process::Command;
use std::env::current_exe;

fn main() {
    Command::new(build_path("env/bin/python3"))
        // Set the environment variables
        .env("PATH", build_path("env/bin"))
        .env("PYTHONHOME", build_path("env"))
        .env("PYTHONPATH", build_path("env/lib/python3.5"))
        // Set the arguements
        .arg("-c")
        .arg("import gpgsync; gpgsync.main()")
        .spawn()
        .expect("failed to execute process");
}

fn build_path(filename: &str) -> String {
    // Find the path inside the app bundle of Contents/MacOS
    let mut path = current_exe().unwrap();
    path.pop(); // chop off gpgsync, the name of the launcher
    path.push(filename);
    String::from(path.to_str().unwrap())
}
