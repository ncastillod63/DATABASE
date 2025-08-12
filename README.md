# API Library + Interface

This project is an application for:
- Managing clients of the Expertsof company (CRUD).
- Populating the database with a manually formatted CSV file.

---

## Prerequisites

You must have installed:

1. **Node.js** (v18 or higher) → https://nodejs.org
2. A database manager (example: MySQL)

---

## Installation and Configuration
In the project folder, run the following command to install the nodejs dependencies.

**npm install**

This will install:
express → Backend Framework

mysql2 → MySQL Connection

nodemon → Automatically restart the development server.

Then we can start the server with the following command:
**npm start**

To access the frontend, go to **http://localhost:3000**

Importing the CSV files into the database still needs to be done separately with the SQL scripts, which are in another project folder.

The server is statically configured on port 3000 and can be modified from the server.js file.

This project implements a relational database in MySQL to manage customers, payment platforms, invoices, and financial transactions.
The system allows administrators, financial managers, and analysts to track revenue, outstanding invoices, and transactions by platform.


---

Database Structure

1. clients

Stores customer details.

Column      Type  Description

id_client   INT (PK, AI)      Unique client identifier.
name_client VARCHAR(100)      Client's full name.
identification    VARCHAR(30) Unique identification number.
address     VARCHAR(200)      Address.
phone VARCHAR(20) Phone number.
email VARCHAR(100)      Email address.



---

2. platforms

Stores available payment platforms.

Column      Type  Description

id_platform INT (PK, AI)      Unique platform identifier.
platform    VARCHAR(100)      Platform name (e.g., Nequi, PayPal)



---

3. bills

Stores billing details for each client.

Column      Type  Description

id_bill     VARCHAR(20) Unique bill identifier.
id_client   INT (FK)    References clients(id_client).
period      VARCHAR(20) Billing period (e.g., 2024-07).
invoiced_amount   DECIMAL(12,2)     Total invoiced amount.
paid_amount DECIMAL(12,2)     Amount already paid.



---

4. transactions

Stores payment and transaction records.

Column      Type  Description

id_transaction    VARCHAR(20) Unique transaction identifier.
date_transaction  DATETIME    Transaction date and time.
amount_transaction      DECIMAL(12,2)     Transaction amount.
estatus_transaction     VARCHAR(100)      Transaction status (e.g., Paid, Pending, Failed).
type_transaction  VARCHAR(100)      Type (e.g., Bill Payment).
id_client   INT (FK)    References clients(id_client).
id_platform INT (FK)    References platforms(id_platform).
id_bill     VARCHAR(20) References bills(id_bill).



---

Relationships

One client → can have multiple bills and transactions.

One bill → belongs to one client but can have multiple related transactions.

One platform → can process many transactions.

One transaction → belongs to exactly one client, one bill, and one platform.



---

Example Queries

1. Total amount paid per client

SELECT 
    c.id_client,
    c.name_client,
    SUM(t.amount_transaction) AS total_paid
FROM clients c
JOIN transactions t ON c.id_client = t.id_client
WHERE t.estatus_transaction = 'Completada'
GROUP BY c.id_client, c.name_client
ORDER BY total_paid DESC;


---

2. Pending bills with client and transaction details

SELECT 
    b.id_bill,
    b.period,
    b.invoiced_amount,
    b.paid_amount,
    (b.invoiced_amount - b.paid_amount) AS outstanding_balance,
    c.name_client,
    t.id_transaction,
    t.date_transaction,
    t.amount_transaction,
    t.estatus_transaction
FROM bills b
JOIN clients c ON b.id_client = c.id_client
LEFT JOIN transactions t ON b.id_bill = t.id_bill
WHERE b.paid_amount < b.invoiced_amount
ORDER BY outstanding_balance DESC;


---

3. Transactions filtered by platform

SELECT 
    p.platform,
    t.id_transaction,
    t.date_transaction,
    t.amount_transaction,
    t.estatus_transaction,
    c.name_client,
    b.id_bill
FROM transactions t
JOIN platforms p ON t.id_platform = p.id_platform
JOIN clients c ON t.id_client = c.id_client
JOIN bills b ON t.id_bill = b.id_bill
WHERE p.platform = 'Nequi'
ORDER BY t.date_transaction DESC;


