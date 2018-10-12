provider "google" {
	credentials = "${file("../account.jason")}"
	project = "trans-rainfall-218109"
	region = "asia-south1-c"
}
