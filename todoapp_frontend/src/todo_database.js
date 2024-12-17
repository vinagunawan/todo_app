// Fungsi untuk mengambil semua tugas
export const fetchTasks = async () => {
    try {
      const response = await fetch('http://localhost:4000/tasks'); // Pastikan URL sesuai dengan backend Anda
      if (response.ok) {
        const data = await response.json();
        return data;
      } else {
        throw new Error('Gagal memuat tugas');
      }
    } catch (error) {
      console.error('Error:', error);
    }
  };
  
  // Fungsi untuk menambahkan tugas baru
  export const addTask = async (title, description) => {
    try {
      await fetch('http://localhost:4000/tasks', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ title, description }),
      });
    } catch (error) {
      console.error('Error:', error);
    }
  };
  
  // Fungsi untuk memperbarui status tugas
  export const updateTask = async (id, isCompleted) => {
    try {
      await fetch(`http://localhost:4000/tasks/${id}`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ is_completed: isCompleted ? 1 : 0 }),
      });
    } catch (error) {
      console.error('Error:', error);
    }
  };
  
  // Fungsi untuk menghapus tugas
  export const deleteTask = async (id) => {
    try {
      await fetch(`http://localhost:4000/tasks/${id}`, {
        method: 'DELETE',
      });
    } catch (error) {
      console.error('Error:', error);
    }
  };
  