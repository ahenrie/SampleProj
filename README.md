# Data Warehouse Project - CRM Database and Data Warehouse

## Overview

This repository contains the implementation of a data warehouse project for a Customer Relationship Management (CRM) system. The project includes the design and creation of a CRM database, a data warehouse, along with stored procedures in TSQL, and a SQL script to autoassign new customers to account managers.

## Database and Data Warehouse Design

### CRM Database (OLTP)

The CRM database is designed to store operational data related to customers, accounts, sales, and other relevant information. The database schema includes the following main tables:

- Customers: Contains information about individual customers, such as CustomerID, Name, Email, Address, etc.
- Accounts: Stores account details, including AccountID, AccountName, ContactPerson, Address, etc.
- Sales: Records sales transactions, with SalesID, CustomerID, AccountID, ProductID, SaleDate, Quantity, and Amount.
- Products: Holds information about various products offered by the company, with ProductID, ProductName, UnitPrice, etc.

The CRM database follows normalization principles to ensure data integrity and minimize redundancy.

### Data Warehouse (OLAP)

The data warehouse is designed to support analytical reporting and business intelligence. It is built on a star schema for simplified querying and performance optimization. The central fact table is the Sales fact table, surrounded by dimension tables:

- DimCustomers: Contains information about customers, including CustomerKey, CustomerName, Email, Address, etc.
- DimAccounts: Stores account details, with AccountKey, AccountName, ContactPerson, Address, etc.
- DimProducts: Holds information about products, with ProductKey, ProductName, UnitPrice, etc.
- DimTime: Contains time-related information to facilitate time-based analysis, with attributes like DateKey, Day, Month, Year, etc.

The data warehouse enables complex queries and provides valuable insights into sales trends, customer behavior, and account performance.

## DDL (Data Definition Language)

The DDL script includes the SQL statements necessary to create the CRM database and data warehouse tables:

- `DDL.sql`: This script creates all the required tables and establishes primary keys, foreign keys, and constraints for the CRM database.

- `DataWarhouseDDL.sql`: This script creates the dimension and fact tables for the data warehouse.

## Stored Procedures in TSQL

The `StoredProcsFuncTriggers.sql` script consists of stored procedures, user-defined functions, and triggers for data management and analysis:

- `fillDates`: This stored procedure fills the Dates dimension table with data, generating date records between specified start and end dates.

- `fillDepartments`: This stored procedure fills the Departments dimension table with data, adding new departments as needed.

- `fillEmployees`: This stored procedure fills the Employee dimension table with data, adding new employees as needed.

- `fillCustAgg`: This stored procedure fills the Customer Aggregate table with data, updating existing records with new customer information and task completion counts.

- `fillTaskFacts`: This stored procedure fills the Task Facts table with data, using full replacement to ensure data accuracy.

- `convertDate`: This user-defined function converts a given calendar date to its corresponding DateID in the Dates dimension table.

- `taskUpdated`: This trigger fires after updates on the Task table, marking updated records with a flag.

- `syncTaskDetails`: This stored procedure synchronizes the Task Facts table with the updated Task records and disables/re-enables the trigger for data consistency.

## Autoassign Customers to Account Managers

The `AutoAssign.SQL` script includes SQL queries to autoassign new customers to account managers based on specified criteria:

- The script selects active employees with the appropriate department ID to be considered for account manager assignment.
- The script selects all existing departments and customers.
- The script defines a trigger called `RandomSalesAssign` that automatically assigns a new customer to a random account manager when inserted into the CRM database.

## Conclusion

This data warehouse project provides a comprehensive solution for managing CRM data, enabling efficient querying and in-depth analysis. With the implemented database schema, stored procedures, and customer autoassignment script, the CRM system becomes more robust and better equipped to handle large volumes of data and generate valuable insights for business growth.
