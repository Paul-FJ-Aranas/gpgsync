use std::process::Command;
use std::env::current_exe;

fn main() {
    Command::new(build_path("MacOS/env/bin/python3"))
        // Set the environment variables
        .env("PATH", build_path("MacOS/env/bin"))
        .env("PYTHONHOME", build_path("MacOS/env"))
        .env("PYTHONPATH", build_path("MacOS/env/lib/python3.5"))
        .env("GPGSYNC_RESOURCE_DIR", build_path("Resources/share"))
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
    path.pop(); // chop off MacOS
    path.push(filename);
    String::from(path.to_str().unwrap())
}
