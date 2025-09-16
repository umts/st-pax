# README

## What is It?

This app is a database of Accessible Van Service (AVS) passengers, to be used by
AVS dispatchers and administrators.

## What Does It Do?

Stores all AVS passengers and their attributes. This allows for functionality
such as automatically deactivating temporary AVS passengers who have expired
doctors notes (done with a cron job that runs every day at 4:30am)

## Current Functionality

- Allows administrators to add, edit, and delete passengers (both temporary and
  permanent) from the database. Admins can also override passenger deactivation
  regardless of doctor's note expiration date
- Allows on-duty AVS dispatchers to add and edit temporary passengers in the
  database
- Database is searchable, sortable, and filterable.
- Color-coded for easy identification of passengers who are not active and good
  to go (e.g., passengers without doctor's notes, those within a week of the
  expiration date, notes that have expired within the grace period ...)

This app may later be expanded to serve other AVS department needs, as well.

## Setup

- To seed the database, use `rails db:seed`.
- Run `npm i` to add Boostrap, jQuery, jQuery-ui, and Datatables packages.

## Pull Requests

(Eventual PR Guidelines)

## Contribution Guidelines
(Might make Contributing.md later)
