# README

## Rails Type

This app uses Rails 5

## What is It?

This app is a database of Special Transit passengers, to be used by ST dispatchers and administrators.

## What Does It Do?

- Stores all Spacial Transit passengers and their attributes. This allows for functionality such as automatically deactivating temporary ST passengers who have expired doctors notes (done with a cron job that runs every day at 4:30am)

## Current Functionality

- Allows administrators to add, edit, and delete passengers (both temporary and permanent) from the database. Admins can also override passenger deactivation regardless of doctor's note expiration date
- Allows on-duty ST dispatchers to add and edit temporary passengers in the database
- Database is searchable, sortable, and filterable.
- Color-coded for easy identification of passengers who are not active and good to go (e.g., passengers without doctor's notes, those within a week of the expiration date, notes that have expired within the grace period ...)

This app may later be expanded to serve other ST department needs, as well.

## Setup

- To seed the database, use `rails db:seed`.
- Run `yarn` to add Boostrap, jQuery, jQuery-ui, and Datatables packages.

## Pull Requests

(Eventual PR Guidelines)

## Contribution Guidelines
(Might make Contributing.md later)

## Archived

Found out that the deployed app (https://st-pax.admin.umass.edu/) is no longer being used. Talked to the ST Supervisors, and was told it's not due to bugs or issues with the app, but rather because they determined that a spreadsheet is more suitable for ST's workflow.
