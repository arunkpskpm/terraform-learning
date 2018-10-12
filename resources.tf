resource "google_compute_network" "development_network" {
  name = "devnetwork"
  auto_create_subnetworks = "true"
}	
