const express = require('express');
const mysql = require('mysql');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(express.json());

// Koneksi ke database MySQL
const db = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '',
  database: 'todo_app',
});

// Cek koneksi database
db.connect((err) => {
  if (err) {
    console.error('Koneksi ke database gagal:', err);
    return;
  }
  console.log('Terhubung ke database MySQL');
});

// Mendapatkan semua tugas dari database
app.get('/tasks', (req, res) => {
  const sql = 'SELECT * FROM tasks';
  db.query(sql, (err, results) => {
    if (err) {
      console.error('Gagal mendapatkan data:', err);
      res.status(500).send('Gagal mendapatkan data');
      return;
    }
    res.json(results);
  });
});

// Menambahkan tugas baru ke database
app.post('/tasks', (req, res) => {
  const { title, description } = req.body;
  const sql = 'INSERT INTO tasks (title, description) VALUES (?, ?)';
  db.query(sql, [title, description], (err, result) => {
    if (err) {
      console.error('Gagal menambahkan tugas:', err);
      res.status(500).send('Gagal menambahkan tugas');
      return;
    }
    res.json({ id: result.insertId, title, description, is_completed: false });
  });
});

// Mengubah status tugas (selesai atau belum)
app.put('/tasks/:id', (req, res) => {
  const { id } = req.params;
  const { is_completed } = req.body;
  
  if (typeof is_completed !== 'boolean' && typeof is_completed !== 'number') {
    return res.status(400).send('Nilai is_completed tidak valid');
  }

  const sql = 'UPDATE tasks SET is_completed = ? WHERE id = ?';
  db.query(sql, [is_completed ? 1 : 0, id], (err) => {
    if (err) {
      console.error('Gagal memperbarui tugas:', err);
      res.status(500).send('Gagal memperbarui tugas');
      return;
    }
    res.json({ message: 'Tugas berhasil diperbarui' });
  });
});

// Menghapus tugas dari database
app.delete('/tasks/:id', (req, res) => {
  const { id } = req.params;
  const sql = 'DELETE FROM tasks WHERE id = ?';
  db.query(sql, [id], (err) => {
    if (err) {
      console.error('Gagal menghapus tugas:', err);
      res.status(500).send('Gagal menghapus tugas');
      return;
    }
    res.json({ message: 'Tugas berhasil dihapus' });
  });
});

// Menjalankan server di port 3000
const PORT = 4000;
app.listen(PORT, () => {
  console.log(`Server berjalan di port ${PORT}`);
});
