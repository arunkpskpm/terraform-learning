resource "google_compute_instance" "server1" {
  name = "firstserver"
  machine_type = "n1-standard-1"
  zone = "asia-south1-c"

  boot_disk {
    initialize_params{
      image = "rhel-cloud/rhel-7"
    }
  }
  network_interface {
    subnetwork = "${google_compute_subnetwork.dev-subnet.name}"
    
    access_config {
    }
  }

  metadata {
    foo = "bar"
  }

  metadata_startup_script = "echo hi > /test.txt"
  
  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}
