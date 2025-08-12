CREATE DATABASE IF NOT EXISTS pd_nadine_castillo_manglar;
USE pd_nadine_castillo_manglar;

-- platforms
CREATE TABLE platforms (
    id_platform INT AUTO_INCREMENT PRIMARY KEY,  
    platform VARCHAR(100) NOT NULL
);

-- clients
CREATE TABLE clients (
    id_client INT AUTO_INCREMENT PRIMARY KEY,
    name_client VARCHAR(100) NOT NULL,
    identification VARCHAR(30) UNIQUE NOT NULL,
    address VARCHAR(200),
    phone VARCHAR(20),
    email VARCHAR(100)
);

-- bills
CREATE TABLE bills (
    id_bill VARCHAR(20) PRIMARY KEY,
    id_client INT NOT NULL,
    period VARCHAR(20) NOT NULL,
    invoiced_amount DECIMAL(12,2) NOT NULL,
    paid_amount DECIMAL(12,2) DEFAULT 0,
    FOREIGN KEY (id_client) REFERENCES clients(id_client)
);

-- transactions
CREATE TABLE transactions (
    id_transaction VARCHAR(20) PRIMARY KEY,
    date_transaction DATETIME NOT NULL,
    amount_transaction DECIMAL(12,2) NOT NULL,
    estatus_transaction VARCHAR(100) NOT NULL,
    type_transaction VARCHAR(100) NOT NULL,
    id_client INT NOT NULL,
    id_platform INT NOT NULL,
    id_bill VARCHAR(20) NOT NULL,
    FOREIGN KEY (id_client) REFERENCES clients(id_client),
    FOREIGN KEY (id_platform) REFERENCES platforms(id_platform),
    FOREIGN KEY (id_bill) REFERENCES bills(id_bill)
);





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
WHERE p.platform = 'Daviplata'
ORDER BY t.date_transaction DESC;

SELECT 
    b.id_bill,
    b.period,
    b.invoiced_amount,
    b.paid_amount,
    (b.invoiced_amount - b.paid_amount) AS saldo_pendiente,
    c.name_client,
    c.identification,
    t.id_transaction,
    t.date_transaction,
    t.amount_transaction,
    t.estatus_transaction
FROM bills b
JOIN clients c ON b.id_client = c.id_client
LEFT JOIN transactions t ON b.id_bill = t.id_bill
WHERE b.paid_amount < b.invoiced_amount
ORDER BY saldo_pendiente DESC;

SELECT 
    c.id_client,
    c.name_client,
    SUM(t.amount_transaction) AS total_pagado
FROM clients c
JOIN transactions t ON c.id_client = t.id_client
WHERE t.estatus_transaction = 'Completada'
GROUP BY c.id_client, c.name_client
ORDER BY total_pagado DESC;