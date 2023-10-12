# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

```
# Terminal 1: database
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


# Terminal 2: console
rails c

# Terminal 3: app
rails s

```