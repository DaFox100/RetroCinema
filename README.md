Movie Rental System
A Java-based web application for managing movie rentals, built using Servlets, JSP, and PostgreSQL. The application allows users to browse movies, rent and return them, manage accounts, and view rental history. It is packaged as a WAR file and designed to run on servlet containers like Apache Tomcat.

Table of Contents
Project Overview

Prerequisites

Installation

Running the Application

Database Configuration

Project Structure

Dependencies

Additional configuration
Project Overview
This application facilitates the management of movie rentals through a web interface. Key features include:

User account creation and management

Browsing available movies

Renting and returning movies

Viewing and removing rental history

Prerequisites
Ensure the following software is installed on your system:

Java Development Kit (JDK): Version 8 or higher

Apache Maven: For building the project

Apache Tomcat: Version 9 or higher, for deploying the WAR file

PostgreSQL: For the application's database

Installation
Clone the Repository:

git clone https://github.com/DaFox100/RetroCinema.git
cd movierentalsystem
Configure Database Connection:

Update the database connection details in your application's configuration file (e.g., db.properties or similar). Ensure the following properties are set:

db.url=jdbc:postgresql://localhost:5432/movierentaldbString url = "jdbc:postgresql://aws-0-us-west-1.pooler.supabase.com:6543/postgres?sslmode=require";

db.username=your_db_username
db.password=your_db_password
Build the Project:

Use Maven to compile the project and package it into a WAR file:

mvn clean install
The generated WAR file will be located in the target/ directory.

Running the Application
Deploy to Tomcat:

Copy the generated movierentalsystem.war file to the webapps/ directory of your Tomcat installation.

Start Tomcat:

Start the Tomcat server using the appropriate script:

Windows: bin\startup.bat

Unix/Linux: bin/startup.sh

Access the Application:

Open a web browser and navigate to:

http://localhost:8080/movierentalsystem/movies



Database Configuration
Create the Database:
We used Supabase to create our database to connect to ours the connction string is below:
String url = "jdbc:postgresql://aws-0-us-west-1.pooler.supabase.com:6543/postgres?sslmode=require";
       String user = "postgres.fnvoefvmbaknmhryrxuj";
       String password = "CS157A052025";
       return DriverManager.getConnection(url, user, password);

Set Up Tables:

Execute the necessary SQL scripts to create tables and seed initial data. These scripts should be located in the sql/ directory of the project.

User Permissions:

Ensure that the database user specified in the configuration has the necessary permissions to read and write to the movierentaldb database.



Project Structure 

movierentalsystem/
├── src/
│   └── main/
│       ├── java/
│       │   └── com/
│       │       └── movierental/
│       │           ├── MoviesServlet.java
│       │           ├── RentServlet.java
│       │           ├── ReturnServlet.java
│       │           ├── AccountServlet.java
│       │           ├── CreateAccountServlet.java
│       │	           ├──Movies.java
|       |            ├──DatabaseConnection.java
│       │            │
│       │           └── RemoveHistoryServlet.java
│       └── webapp/
│           ├── WEB-INF/
│            |	└── web.xml
│           └── index.jsp
│	 └── about.jsp
│	 └── createAccount.jsp
│	 └── account.jsp
├── pom.xml
└── README.md


<img width="386" alt="image" src="https://github.com/user-attachments/assets/c515d350-a535-4ef7-be30-d7d49b168f11" />




Dependencies
The project utilizes the following dependencies, managed via Maven:

JUnit: For unit testing

Servlet API: Provided by the servlet container (e.g., Tomcat)

PostgreSQL JDBC Driver: For database connectivity

Apache Commons Text: For text processing utilities

These dependencies are specified in the pom.xml file.


Additional configuration
This project used Supabase PostgreSQL to create our dataframes and store user data, so if you would like to make an account with Supabase, here is our design schema with our naming conventions to implement it:
movies
movie_id: INTEGER, Primary Key, NOT NULL
title: VARCHAR(255), NOT NULL
total_copies: INTEGER
copies_rented: INTEGER
genre: VARCHAR(255)
price: DECIMAL(6,2)
url: VARCHAR(255)
customers
customer_id: INTEGER, Primary Key, NOT NULL, 
first_name: VARCHAR(255)
last_name: VARCHAR(255)
email: VARCHAR(255)
address: VARCHAR(255)
rentals
movie_id: Primary Key, Foreign Key, NOT NULL
customer_id: Primary Key, Foreign Key, NOT NULL
price_paid: DECIMAL(6,2) 
Rented_date: Primary Key, timestamp
returned_date: timestamp
ratings
movie_id: Primary Key, Foreign Key, NOT NULL
customer_id: Primary Key, Foreign Key, NOT NULL
rating: INTEGER


