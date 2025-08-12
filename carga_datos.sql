LOAD DATA LOCAL INFILE '/home/Coder/Documentos/Uploads/clients.csv'
INTO TABLE clients
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(name_client, identification, address, phone, email);



LOAD DATA LOCAL INFILE '/home/Coder/Documentos/Uploads/platforms.csv'
INTO TABLE platforms
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(platform);



LOAD DATA LOCAL INFILE '/home/Coder/Documentos/Uploads/bills.csv'

INTO TABLE bills
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id_bill, id_client, period, invoiced_amount, paid_amount);





LOAD DATA LOCAL INFILE '/home/Coder/Documentos/Uploads/transactions.csv'
INTO TABLE transactions
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id_transaction, date_transaction, amount_transaction, estatus_transaction, type_transaction, id_client, id_platform, id_bill);



INSERT INTO transactions 
(id_transaction, date_transaction, amount_transaction, estatus_transaction, type_transaction, id_client, id_platform, id_bill) 
VALUES
('TXN012', STR_TO_DATE('12/07/2024 19:00', '%d/%m/%Y %H:%i'), 174518, 'Pendiente', 'Pago de Factura', 12, 1, 'FAC8140'),
('TXN013', STR_TO_DATE('04/07/2024 12:00', '%d/%m/%Y %H:%i'), 110254, 'Fallida', 'Pago de Factura', 13, 2, 'FAC4679'),
('TXN014', STR_TO_DATE('12/07/2024 04:00', '%d/%m/%Y %H:%i'), 162283, 'Pendiente', 'Pago de Factura', 14, 1, 'FAC3589'),
('TXN015', STR_TO_DATE('21/06/2024 12:00', '%d/%m/%Y %H:%i'), 22161, 'Pendiente', 'Pago de Factura', 15, 2, 'FAC6122'),
('TXN016', STR_TO_DATE('08/07/2024 12:00', '%d/%m/%Y %H:%i'), 195775, 'Pendiente', 'Pago de Factura', 16, 2, 'FAC4870'),
('TXN017', STR_TO_DATE('27/06/2024 03:00', '%d/%m/%Y %H:%i'), 20824, 'Fallida', 'Pago de Factura', 17, 1, 'FAC5322'),
('TXN018', STR_TO_DATE('09/07/2024 05:00', '%d/%m/%Y %H:%i'), 191134, 'Completada', 'Pago de Factura', 18, 1, 'FAC8663'),
('TXN019', STR_TO_DATE('06/06/2024 20:00', '%d/%m/%Y %H:%i'), 62979, 'Completada', 'Pago de Factura', 19, 2, 'FAC4380'),
('TXN020', STR_TO_DATE('08/06/2024 22:00', '%d/%m/%Y %H:%i'), 36472, 'Fallida', 'Pago de Factura', 20, 2, 'FAC5128');


