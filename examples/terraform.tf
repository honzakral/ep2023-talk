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
  secret_id = "db-password"
}

resource "google_secret_manager_secret_version" "db_password" {
  secret      = google_secret_manager_secret.db_password.id
  secret_data = random_password.db_password.result
}

resource "google_sql_user" "users" {
  name     = "my_app"
  instance = google_sql_database_instance.prod_db.name
  password = random_password.db_password.result
}

resource "google_cloud_run_service" "myapp" {
  name     = "myapp-cloudrun"
  location = "eu-west2"

  template {
    spec {
      containers {
        image = "gcr.io/my-app/myimage"
        env {
          name = "DATABASE_PASSWORD"
          value_from {
            secret_key_ref {
              name = google_secret_manager_secret.db_passwword.name
              key  = "latest"
            }
          }
        }
      }
    }
  }
}
