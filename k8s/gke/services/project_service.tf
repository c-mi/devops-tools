resource "google_project_service" "project" {
  for_each = toset([
    "cloudresourcemanager.googleapis.com",
    "container.googleapis.com",
    "compute.googleapis.com",
    "cloudkms.googleapis.com"
  ])

  project = var.project
  service = each.key
}