use sysinfo::System;

fn main() {
    let mut sys = System::new_all();
    let n_cpus = match sys.cpus().len() {
        0 => {
            eprintln!("Can't get CPU count");
            return;
        }
        n => n,
    };

    // Wait a bit because CPU usage is based on diff.
    std::thread::sleep(sysinfo::MINIMUM_CPU_UPDATE_INTERVAL);

    sys.refresh_cpu_usage();

    let total_usage = sys.cpus().iter().map(|cpu| cpu.cpu_usage()).sum::<f32>();

    let average_usage = total_usage / n_cpus as f32;

    println!("{:.2}%", average_usage);
}
