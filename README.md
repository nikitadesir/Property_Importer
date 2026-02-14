<<<<<<< HEAD
# Property Importer
## Description
This is a Ruby on Rails app I built to upload property data from a CSV file in order to onboard new customers. I tried to structure the app so that it's user‑friendly and would be easy for the customer success team to use: you upload a CSV, the app shows you a preview of what it’s going to upload, and then you confirm the upload if everything looks good before saving to the database. The Property Importer is designed to handle any inconsistent data in the CSVs customer success might receive from new clients, such as missing fields, weird spacing, inconsistent capitalization, duplicate units, duplicate properties, or even odd encoding issues.

Since this was my first time building a Ruby on Rails app, I want to note that I used AI tools to help me learn the overall framework and explore different approaches to creating the app. I definitely learned a lot while working on this assignment and it acted as a great crash course of the language and application building with Ruby on Rails.

## Installation
Clone the repo:

```
git clone https://github.com/nikitadesir/Property_Importer
cd property_importer
```
Install dependencies:

```
bundle install
```
Set up the database:

```
rails db:create db:migrate
```

Start the server:

```
rails server
```

## Usage
1. Upload a CSV
Go to:

```
http://localhost:3000/imports/new
```

Upload a CSV with these headers:

```
Building Name, Street Address, Unit, City, State, Zip Code
```

2. Preview
After uploading, the app shows you:

New properties

Existing properties

New units

Duplicate units

Errors (blank fields)

Rows that will be excluded in upload due to errors

3. Confirm
If everything looks right, click Confirm Import and the valid rows will be saved.

4. Try the edge cases
I included an edge_case.csv file that intentionally contains:

Missing fields

Duplicate units

Duplicate properties

Inconsistent casing

Extra whitespace

Encoding quirks

A mix of valid and invalid rows

This file basically acts as the "test suite” for the property_importer and shows how it handles real‑world data.

## Assumptions & Tradeoffs
CSV headers must match exactly.  

A property is uniquely identified by its full address. (Building name + street + city + state + ZIP.)

Units are unique within a property, so if a property already has a unit with the same number, it’s treated as a duplicate.

Normalization happens within the importer so that all of the data cleaning is centralized and keeps the models simple.


## How I Identified Duplicate Properties
To figure out whether a property already exists, I normalize and compare these fields:

building name

street address

city

state

ZIP code

After normalization (trimming, squishing, titleizing, Unicode cleanup), I combined them into a unique key. If that key matches an existing property — either in the database or earlier in the same CSV — it’s considered a duplicate.

## What I’d Improve If This Were Used Daily
If this importer were part of the team’s everyday workflow, I’d make several more improvements:

Add automated tests, especially around edge cases and normalization.

Background job processing so that larger CSVs could run asynchronously with progress updates.

Bulk inserts to speed up the upload process and make fewer database round‑trips.

Better UI for the preview page to help with large files, such as sorting, filtering, and user-friendly grouping.

Ability to download a CSV template so users always start with the correct format.

An error report that users can download or a page that highlights the problematic rows and lets them fix the issues directly.
=======
# Property_Importer
A Ruby on Rails application to upload property data from a CSV file to a PostgreSQL database.
>>>>>>> 0105dc253e911cdc69ca357ea213a472b92b9693
