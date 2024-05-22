# sql-covid-data-exploration

## Overview about the project

### Objective

This project focuses on exploring COVID-19 pandemic data using SQL queries and visualizing the data using Tableau. The main objective is to gain an overview about the pandemic including infection, mortality rate, and vaccination worldwide; also further exploring any valuable insights obtained.

### Data

The dataset is provided by Edouard Mathieu, Hannah Ritchie, Lucas Rodés-Guirao, Cameron Appel, Charlie Giattino, Joe Hasell, Bobbie Macdonald, Saloni Dattani, Diana Beltekian, Esteban Ortiz-Ospina and Max Roser (2020) - "Coronavirus Pandemic (COVID-19)". Published online at OurWorldInData.org. Retrieved from [online source](https://ourworldindata.org/coronavirus).

### Tools and Technologies

Docker: For setting up the MySQL server.
MySQL: For storing and querying the data.
DBeaver: As the database management tool for data import and transformation.

## Workflow

### Setting Up MySQL Server with Docker

Run the MySQL container:

    docker run --name mysql-container -e MYSQL_ROOT_PASSWORD=root -d mysql:latest

### Using DBeaver to connect to the database

![connect to a db screen](<screenshots/dbeaver_connect_to_db_screen.png>)

*As this is a personal project, I will skip any security measurement.

### Performing data exploration

Create a new database for the project in DBeaver:

    CREATE DATABASE covid_db;

Loading Data into MySQL:

* Use DBeaver to import the CSV data into the covid_db database.
* Transform the data types as needed (e.g., converting varchar to int).
* Remove unnecessary columns during the import process.

### Data Exploration and Analysis

Identify key metrics to explore:

Infection cases: The number of new cases are being confirmed each day and total cases have been confirmed since the pandemic started.

Deaths: The number of new deaths are being reported each day and total deaths have been reported since the pandemic started.

Percentage of Population Infected (infection rate): The percentage of the population that has been infected by COVID-19 measures the spread of the virus.

Mortality Rate: The percentage of the population that has been died due to COVID-19 measures the severity of the pandemic.

Rolling Count of People Vaccinated: The cumulative number of vaccinated individuals on each day presents the medical treatment provided in each specific location and in the world in general against the virus. Additionally, it shows the percentage of the population that has received the vaccine.
