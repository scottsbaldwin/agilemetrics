Measure Up
=============
Measure Up is an Agile metrics tracker for multiple teams. Use it to track per-sprint metrics including velocity, estimation accuracy, commitment accuracy, unplanned work, capacity, and more!

## Setup

Measure Up is a Ruby on Rails app that uses Postgresql as the database back-end. Once you have Ruby installed, proceed with the instructions below.

### Docker

Run Postgres in a Docker container with:

```
docker run --rm --platform linux/x86_64 --name metrics_db \
  -e POSTGRES_PASSWORD=badwolf \
  -e PGDATA=/tmp/pgdata \
  -v $(pwd)/tmp/db/metrics_db:/tmp/pgdata \
  -p 5432:5432 postgres:13

rails db:drop
rails db:setup
# or
rails db:create
rails db:migrate
rails db:seed
```

The database seed file (db/seeds.rb) will create a single user:

- Username: admin
- Password: admin

In another terminal window, launch the server with:

```
rails s
```

New users may register an account by clicking the "Sign up" link located at the bottom of the login page.

### Kubernetes

Use the k8s in Docker Desktop.

```
make local-install-helm
make local-uninstall-helm
```

This app depends on a database running in docker. The hostname needs to be `host.docker.internal`, and is defined in `helm/values/devk8s.yaml` in the `deployment.env.METRICS_DB_HOST` value.