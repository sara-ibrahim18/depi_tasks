const table = document.getElementById("table");
const status = document.getElementById("status");

function loadData() {
 
  const xhr = new XMLHttpRequest();
  xhr.open("GET", "https://jsonplaceholder.typicode.com/users", true);

  xhr.onreadystatechange = function () {
    if (xhr.readyState === 4) {
    
        const data = JSON.parse(xhr.responseText);

        // clear table before inserting new data
        table.innerHTML = `
          <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Email</th>
          </tr>
        `;

        data.forEach(user => {
          table.innerHTML += `
            <tr>
              <td>${user.id}</td>
              <td>${user.name}</td>
              <td>${user.email}</td>
            </tr>
          `;
        });
      
    }
  };

  xhr.send();
}
