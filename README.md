# README

**Devloper Notes:

I've worked on this project for a few hours over the past 3 days split up due to full-time work, full-time school(currently second year into Bachelors in Computer Science), and being a full-time father to my newborn son. Usually this time is dedicated to personal projects but it was instead invested to this assessment for the time being.

**

This app is currently also deployed to heroku and can be run from the link:

"https://fathomless-eyrie-37734.herokuapp.com/v1/ "

examples: 

"https://fathomless-eyrie-37734.herokuapp.com/v1/ping"

"https://fathomless-eyrie-37734.herokuapp.com/v1/posts?tags=tech,health,science,culture&sortBy=popularity&direction=desc"

Ruby version

-Rails - 6.1.4
-Ruby - 2.7.2

Configuration

to run app in local environment:

-bundle install

-rails db:create
    Development, test, & production database run on PostgreSQL

-rails db:migrate

-rails server, port 3000

Multithreading

In order to allow for Parallel api requests,
I utilized the Thread object for multithreading.

Testing

testing is done with Rspec. contained in the test directory.

-Linux
To run the test suite simply run 'rspec' in the command line from the root directory.