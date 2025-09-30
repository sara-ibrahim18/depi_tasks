const apiUrl = "https://jsonplaceholder.typicode.com/users";
const tableBody = document.getElementById("table-body");
const statusElement = document.getElementById("status");

// 📌 READ (عرض البيانات)
function loadData() {
  const xhr = new XMLHttpRequest();
  xhr.open("GET", apiUrl, true);

  xhr.onreadystatechange = function () {
    if (xhr.readyState === 4) {
      if (xhr.status === 200) {
        const users = JSON.parse(xhr.responseText);
        tableBody.innerHTML = "";

        users.forEach(user => {
          const row = document.createElement("tr");
          row.innerHTML = `
            <td>${user.id}</td>
            <td>${user.name}</td>
            <td>${user.email}</td>
            <td>
              <button onclick="editUser(${user.id})">✏️ Edit</button>
              <button onclick="deleteUser(${user.id})">🗑️ Delete</button>
            </td>
          `;
          tableBody.appendChild(row);
        });

        statusElement.textContent = "✅ Data loaded successfully!";
        statusElement.className = "success";
      } else {
        statusElement.textContent = "❌ Error loading data!";
        statusElement.className = "error";
      }
    }
  };

  xhr.send();
}

// 📌 CREATE (إضافة مستخدم جديد)
function createUser(name, email) {
  const xhr = new XMLHttpRequest();
  xhr.open("POST", apiUrl, true);
  xhr.setRequestHeader("Content-Type", "application/json; charset=UTF-8");

  xhr.onreadystatechange = function () {
    if (xhr.readyState === 4) {
      if (xhr.status === 201) {
        const newUser = JSON.parse(xhr.responseText);
        statusElement.textContent = `✅ User created with ID: ${newUser.id}`;
        statusElement.className = "success";
        loadData(); // إعادة تحميل البيانات
      } else {
        statusElement.textContent = "❌ Error creating user!";
        statusElement.className = "error";
      }
    }
  };

  const data = JSON.stringify({ name, email });
  xhr.send(data);
}

// 📌 Prompt لإدخال بيانات المستخدم الجديد
function createUserPrompt() {
  const name = prompt("Enter user name:");
  const email = prompt("Enter user email:");
  if (name && email) {
    createUser(name, email);
  }
}

// 📌 UPDATE (تعديل مستخدم)
function editUser(id) {
  const newName = prompt("Enter new name:");
  const newEmail = prompt("Enter new email:");

  if (!newName || !newEmail) return;

  const xhr = new XMLHttpRequest();
  xhr.open("PUT", `${apiUrl}/${id}`, true);
  xhr.setRequestHeader("Content-Type", "application/json; charset=UTF-8");

  xhr.onreadystatechange = function () {
    if (xhr.readyState === 4) {
      if (xhr.status === 200) {
        statusElement.textContent = `✏️ User ${id} updated!`;
        statusElement.className = "success";
        loadData();
      } else {
        statusElement.textContent = "❌ Error updating user!";
        statusElement.className = "error";
      }
    }
  };

  const data = JSON.stringify({ id, name: newName, email: newEmail });
  xhr.send(data);
}

// 📌 DELETE (حذف مستخدم)
function deleteUser(id) {
  const xhr = new XMLHttpRequest();
  xhr.open("DELETE", `${apiUrl}/${id}`, true);

  xhr.onreadystatechange = function () {
    if (xhr.readyState === 4) {
      if (xhr.status === 200) {
        statusElement.textContent = `🗑️ User ${id} deleted!`;
        statusElement.className = "success";
        loadData();
      } else {
        statusElement.textContent = "❌ Error deleting user!";
        statusElement.className = "error";
      }
    }
  };

  xhr.send();
}
