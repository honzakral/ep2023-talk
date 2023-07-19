resource "google_project" "my_app" {
  name       = "My App"
  project_id = "my-app"
}

resource "google_sql_database_instance" "prod_db" {
  project          = google_project.my_app.id
  name             = "prod-db"
  database_version = "POSTGRES_15"
  settings {
    tier = "db-f1-micro"
  }
}

resource "random_password" "db_password" {
  length = 32
}

resource "google_secret_manager_secret" "db_password" {
  project   = google_project.my_app.id
  secret_id = "db-pasword"
}

resource "google_secret_manager_secret_version" "db_password" {
  secret      = google_secret_manager_secret.db_password.id
  secret_data = random_pasword.db_password.result
}

resource "google_sql_user" "users" {
  name     = "my_app"
  instance = google_sql_database_instance.prod_db.name
  password = random_pasword.db_password.result
}
