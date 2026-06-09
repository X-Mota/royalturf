// Royal Turf — API de Cavalos
// Instale: npm install express mysql2 cors
// Inicie:  node server.js

const express = require('express');
const mysql   = require('mysql2/promise');
const cors    = require('cors');

const app  = express();
const PORT = 3000;

app.use(cors());
app.use(express.json());

// ── Conexão ───────────────────────────────────────────────────────────────────
const pool = mysql.createPool({
  host:     process.env.DB_HOST     || 'localhost',
  user:     process.env.DB_USER     || 'root',
  password: process.env.DB_PASS     || '',
  database: process.env.DB_NAME     || 'royalturf',
  waitForConnections: true,
  connectionLimit: 10,
});

// ── Rotas ─────────────────────────────────────────────────────────────────────

// GET /cavalos — lista todos
app.get('/cavalos', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT * FROM cavalos ORDER BY id');
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// GET /cavalos/:id — busca um
app.get('/cavalos/:id', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT * FROM cavalos WHERE id = ?', [req.params.id]);
    if (!rows.length) return res.status(404).json({ error: 'Cavalo não encontrado.' });
    res.json(rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// POST /cavalos — cadastra novo
app.post('/cavalos', async (req, res) => {
  const { nome, raca, idade, pelagem, sexo, peso_kg, altura, treinador, joquei } = req.body;
  if (!nome || !idade || !peso_kg) {
    return res.status(400).json({ error: 'Campos obrigatórios: nome, idade, peso_kg.' });
  }
  try {
    const [result] = await pool.query(
      'INSERT INTO cavalos (nome, raca, idade, pelagem, sexo, peso_kg, altura, treinador, joquei) VALUES (?,?,?,?,?,?,?,?,?)',
      [nome, raca||null, idade, pelagem||null, sexo||null, peso_kg, altura||null, treinador||null, joquei||null]
    );
    const [rows] = await pool.query('SELECT * FROM cavalos WHERE id = ?', [result.insertId]);
    res.status(201).json(rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// PUT /cavalos/:id — atualiza
app.put('/cavalos/:id', async (req, res) => {
  const { nome, raca, idade, pelagem, sexo, peso_kg, altura, treinador, joquei } = req.body;
  if (!nome || !idade || !peso_kg) {
    return res.status(400).json({ error: 'Campos obrigatórios: nome, idade, peso_kg.' });
  }
  try {
    const [result] = await pool.query(
      'UPDATE cavalos SET nome=?, raca=?, idade=?, pelagem=?, sexo=?, peso_kg=?, altura=?, treinador=?, joquei=? WHERE id=?',
      [nome, raca||null, idade, pelagem||null, sexo||null, peso_kg, altura||null, treinador||null, joquei||null, req.params.id]
    );
    if (!result.affectedRows) return res.status(404).json({ error: 'Cavalo não encontrado.' });
    const [rows] = await pool.query('SELECT * FROM cavalos WHERE id = ?', [req.params.id]);
    res.json(rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// DELETE /cavalos/:id — remove
app.delete('/cavalos/:id', async (req, res) => {
  try {
    const [result] = await pool.query('DELETE FROM cavalos WHERE id = ?', [req.params.id]);
    if (!result.affectedRows) return res.status(404).json({ error: 'Cavalo não encontrado.' });
    res.json({ ok: true, id: Number(req.params.id) });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// ── Start ─────────────────────────────────────────────────────────────────────
app.listen(PORT, () => {
  console.log(`Royal Turf API rodando em http://localhost:${PORT}`);
});
