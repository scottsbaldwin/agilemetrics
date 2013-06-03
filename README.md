Measure Up
=============
Measure Up is an Agile metrics tracker for multiple teams. Use it to track per-sprint metrics including velocity, estimation accuracy, commitment accuracy, unplanned work, capacity, and more!

##Pre-requisites

Measure Up is a Ruby on Rails app that uses Postgresql as the database back-end. Once you have Ruby installed, proceed with the instructions below.

Install Postgres using homebrew:

```
brew install postgress
```

##Setup

Get the source code, bundle, and get the database setup:

```
cd ~
git clone git@github.com:scottsbaldwin/agilemetrics.git
cd ~/agilemetrics
bundle install
rake db:setup
```

The database seed file (db/seeds.rb) will create a single user:

Username: admin
Password: admin

Currently there is no way in the application to add more users from the web UI. Add more users in the seed file and re-run the database migration scripts.

##Heroku

This app can be deployed to heroku. Create an app with heroku and add a Postgresql database to that app. Once you clone the Measure Up repository from GitHub, add the heroku remote repository to your working copy.

```
cd ~/agilemetrics
heroku git:remote -a YourHerokuAppName
```

Now, push your working copy to heroku:

```
git push heroku master
```

Run the db setup and migrations on heroku:

```
heroku run rake db:setup
```
