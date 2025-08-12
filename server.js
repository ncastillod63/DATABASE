const express = require('express');
const mysql = require('mysql2/promise');
const app = express();
const multer = require('multer');
const path = require('path');

app.use(express.json()); // Para recibir JSON en POST y PUT
app.use(express.static('public'));


// Configuración de la base de datos
const dbConfig = {
    host: 'localhost',
    user: 'root',        
    password: 'P@ssw0rd1234', 
    database: 'pd_nadine_castillo_manglar'
};

// Configuración de almacenamiento
const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        cb(null, 'uploads/'); // Carpeta donde guardar
    },
    filename: (req, file, cb) => {
        cb(null, Date.now() + path.extname(file.originalname)); // Nombre único
    }
});
const upload = multer({ storage: storage });

// Endpoint para subir archivo
app.post('/upload', upload.single('archivo'), (req, res) => {
    if (!req.file) {
        return res.status(400).json({ mensaje: 'No se envió ningún archivo' });
    }
    res.json({ mensaje: 'Archivo recibido correctamente', nombre: req.file.filename });
});


// GET /clients → Listar todos los clientes
app.get('/clients', async (req, res) => {
    const conn = await mysql.createConnection(dbConfig);
    const [rows] = await conn.query('SELECT * FROM clients');
    res.json(rows);
});

// GET /clients/:id → Obtener cliente por ID
app.get('/clients/:id', async (req, res) => {
    const conn = await mysql.createConnection(dbConfig);
    const [rows] = await conn.query('SELECT * FROM clients WHERE id_client = ?', [req.params.id]);
    res.json(rows[0] || {});
});

// POST /prestamos → Crear nuevo cliente
app.post('/client', async (req, res) => {
    const { id_client, name_client, identification, address, phone, email } = req.body;
    const conn = await mysql.createConnection(dbConfig);
    const [result] = await conn.query(
        'INSERT INTO Clientes (id_client, name_client, identification, address, phone, email) VALUES (?, ?, ?, ?, ?, ?)',
        [id_client, name_client, identification, address, phone, email]
    );
    res.json({ message: 'Cliente creado', id: result.insertId });
});

// PUT /prestamos/:id → Editar cliente
app.put('/client/:id', async (req, res) => {
    const { id_client, name_client, identification, address, phone, email } = req.body;
    const conn = await mysql.createConnection(dbConfig);
    await conn.query(
        'UPDATE Prestamos SET id_client=?, name_client=?, identification=?, address=?, phone=? email=? WHERE id_client=?',
        [id_client, name_client, identification, address, phone, email, req.params.id]
    );
    res.json({ message: 'Cliente actualizado' });
});

// DELETE /clients/:id → Eliminar cliente
app.delete('/clients/:id', async (req, res) => {
    const conn = await mysql.createConnection(dbConfig);
    await conn.query('DELETE FROM clients WHERE id_client=?', [req.params.id]);
    res.json({ message: 'Cliente eliminado' });
});



//total pagado por cada cliente
app.get('/transactions/clients/total-pagado', async (req, res) => {
    const conn = await mysql.createConnection(dbConfig);
    const [rows] = await conn.query(`
        SELECT 
    c.id_client,
    c.name_client,
    SUM(t.amount_transaction) AS total_pagado
FROM clients c
JOIN transactions t ON c.id_client = t.id_client
WHERE t.estatus_transaction = 'Completada'
GROUP BY c.id_client, c.name_client
ORDER BY total_pagado DESC;
    `);
    res.json(rows);
});

//Facturas pendientes con información de cliente y transacción asociada
app.get('/transaction/clients/facturas-pendientes', async (req, res) => {
    const conn = await mysql.createConnection(dbConfig);
    const [rows] = await conn.query(`
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
    `);
    res.json(rows);
});

//Listado de transacciones por plataforma
app.get('/transaction/platform', async (req, res) => {
    const conn = await mysql.createConnection(dbConfig);
    const [rows] = await conn.query(`
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
    `);
    res.json(rows);
});

const PORT = 3000;
app.listen(PORT, () => {
    console.log(`Servidor escuchando en http://localhost:${PORT}`);
});
