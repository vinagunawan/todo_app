const express = require('express');
const mysql = require('mysql');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(express.json());

const db = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '',
  database: 'todo_app',
});

db.connect((err) => {
  if (err) throw err;
  console.log('Terhubung ke database MySQL');
});

// Mendapatkan semua tugas dari database
app.get('/tasks', (req, res) => {
  const sql = 'SELECT * FROM tasks';
  db.query(sql, (err, results) => {
    if (err) throw err;
    res.json(results);
  });
});

// Menambahkan tugas baru ke database
app.post('/tasks', (req, res) => {
  const { title, description } = req.body; // Tambahkan deskripsi
  const sql = 'INSERT INTO tasks (title, description) VALUES (?, ?)';
  db.query(sql, [title, description], (err, result) => {
    if (err) throw err;
    res.json({ id: result.insertId, title, description, is_completed: false });
  });
});

// Mengubah status tugas (selesai atau belum)
app.put('/tasks/:id', (req, res) => {
  const { id } = req.params;
  const { is_completed } = req.body;
  const sql = 'UPDATE tasks SET is_completed = ? WHERE id = ?';
  db.query(sql, [is_completed, id], (err) => {
    if (err) throw err;
    res.json({ message: 'Tugas berhasil diperbarui' });
  });
});

// Menghapus tugas dari database
app.delete('/tasks/:id', (req, res) => {
  const { id } = req.params;
  const sql = 'DELETE FROM tasks WHERE id = ?';
  db.query(sql, [id], (err) => {
    if (err) throw err;
    res.json({ message: 'Tugas berhasil dihapus' });
  });
});

const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Server berjalan di port ${PORT}`);
});
