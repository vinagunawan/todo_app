import React, { useState, useEffect } from 'react';
import { fetchTasks, addTask, updateTask, deleteTask } from './todo_database';
import './Styles.css';

function TodoApp() {
  const [tasks, setTasks] = useState([]);  // Inisialisasi tasks sebagai array kosong
  const [title, setTitle] = useState('');
  const [description, setDescription] = useState('');

  // Fetch tasks ketika komponen pertama kali dimuat
  useEffect(() => {
    const getTasks = async () => {
      const fetchedTasks = await fetchTasks();
      
      // Pastikan fetchedTasks adalah array
      if (Array.isArray(fetchedTasks)) {
        setTasks(fetchedTasks);  // Jika ya, set tasks
      } else {
        setTasks([]);  // Jika tidak, set tasks menjadi array kosong
      }
    };
    getTasks();
  }, []);

  const handleAddTask = async () => {
    await addTask(title, description);
    const updatedTasks = await fetchTasks();
    setTasks(updatedTasks);
    setTitle('');
    setDescription('');
  };

  const handleUpdateTask = async (id, isCompleted) => {
    await updateTask(id, isCompleted);
    const updatedTasks = await fetchTasks();
    setTasks(updatedTasks);
  };

  const handleDeleteTask = async (id) => {
    await deleteTask(id);
    const updatedTasks = await fetchTasks();
    setTasks(updatedTasks);
  };

  return (
    <div className="todo-app">
      <header>
        <h1>Your To-Do List</h1>
      </header>

      <div className="task-input">
        <input
          type="text"
          placeholder="Task title"
          value={title}
          onChange={(e) => setTitle(e.target.value)}
        />
        <textarea
          placeholder="Task description"
          value={description}
          onChange={(e) => setDescription(e.target.value)}
        />
        <button onClick={handleAddTask}>Add Task</button>
      </div>

      <div className="task-list">
        {tasks.length === 0 ? (
          <p>No tasks available</p>
        ) : (
          tasks.map((task) => (
            <div
              key={task.id}
              className={`task-card ${task.is_completed === 1 ? 'completed' : ''}`}
            >
              <h3>{task.title}</h3>
              <p>{task.description}</p>
              <div className="task-actions">
                <label>
                  <input
                    type="checkbox"
                    checked={task.is_completed === 1}
                    onChange={(e) =>
                      handleUpdateTask(task.id, e.target.checked)
                    }
                  />
                  Completed
                </label>
                <button onClick={() => handleDeleteTask(task.id)}>Delete</button>
              </div>
            </div>
          ))
        )}
      </div>
    </div>
  );
}

export default TodoApp;
