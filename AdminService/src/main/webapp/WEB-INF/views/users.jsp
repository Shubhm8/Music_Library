<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>View Users</title>

<style>
:root{
    --bg:#F5F5F7;
    --surface:#FFFFFF;
    --surface-alt:#FAFAFC;
    --text-primary:#1D1D1F;
    --text-secondary:#6E6E73;
    --accent:#FF2D55;
    --radius:18px;
    --border:#E5E5EA;
}

body{ 
    background:var(--bg); 
    padding:40px; 
    font-family:-apple-system,Inter,sans-serif; 
}

.container{ 
    max-width:1400px;
    margin:auto;
    background:var(--surface);
    padding:40px;
    border-radius:var(--radius);
    border:1px solid var(--border); 
}

.back-btn{ 
    padding:12px 24px; 
    background:var(--accent); 
    color:white; 
    border-radius:12px; 
    text-decoration:none; 
    font-weight:600; 
}

h1{ 
    font-size:32px; 
    font-weight:800; 
    color:var(--text-primary); 
    margin-top:18px; 
    margin-bottom:10px; 
}

table{ 
    width:100%; 
    border-collapse:separate; 
    border-spacing:0 12px; 
    margin-top:25px; 
}

th{ 
    background:var(--accent); 
    color:white; 
    padding:14px; 
    text-align:left; 
}

td{ 
    background:var(--surface-alt); 
    padding:14px; 
    color:var(--text-secondary); 
}

.status-badge{ 
    background:var(--accent); 
    color:white; 
    padding:6px 14px; 
    border-radius:20px; 
    font-size:12px; 
    font-weight:700; 
}
</style>

</head>
<body>

<div class="container">

    <a href="/admin/dashboard" class="back-btn">← Back to Dashboard</a>

    <h1>All Registered Users</h1>
    <div>Total Users: <span id="totalUsers">0</span></div>

    <table>
    <thead>
        <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Email</th>
            <th>Mobile</th>
            <th>Status</th>
            <th>Actions</th> </tr>
    </thead>
    <tbody id="usersList">
        <tr><td colspan="6">Loading...</td></tr>
    </tbody>
</table>

<script>
    // Configuration for the User Microservice (Port 8081)
    const USER_SERVICE_URL = "http://localhost:8081/api/users"; 

    async function loadUsers(){
        try {
            // Fetching the list of users via Cross-Origin request
            const res = await fetch(USER_SERVICE_URL + "/all");
            
            if (!res.ok) {
                throw new Error(`HTTP error! Status: ${res.status}`);
            }

            const users = await res.json();
            document.getElementById("totalUsers").textContent = users.length;

            let html = "";
            users.forEach(u => {
                let statusBtnColor = u.status === 'ACTIVE' ? 'orange' : 'green';
                let statusBtnText = u.status === 'ACTIVE' ? 'Block' : 'Unblock';

                html += `
                    <tr>
                        <td>\${u.userId}</td>
                        <td>\${u.firstName} \${u.lastName}</td>
                        <td>\${u.email}</td>
                        <td>\${u.mobile ? u.mobile : '-'}</td>
                        <td><span class="status-badge">\${u.status || 'ACTIVE'}</span></td>
                        <td>
                            <button onclick="updateStatus(\${u.userId}, '\${u.status}')" 
                                style="background:\${statusBtnColor}; color:white; border:none; padding:5px 10px; border-radius:5px; cursor:pointer;">
                                \${statusBtnText}
                            </button>
                            <button onclick="deleteUser(\${u.userId})" 
                                style="background:red; color:white; border:none; padding:5px 10px; border-radius:5px; cursor:pointer; margin-left:5px;">
                                Delete
                            </button>
                        </td>
                    </tr>
                `;
            });
            document.getElementById("usersList").innerHTML = html;

        } catch(err) {
            console.error("Error loading users:", err);
            document.getElementById("usersList").innerHTML = 
                `<tr><td colspan="6" style="color:red; text-align:center;">
                    Error loading data. Check Console (F12) for details.
                </td></tr>`;
        }
    }

    async function deleteUser(id) {
        if(!confirm("Are you sure? This cannot be undone.")) return;
        
        await fetch(USER_SERVICE_URL + "/" + id, { method: 'DELETE' });
        loadUsers(); 
    }
    async function updateStatus(id, currentStatus) {
        const newStatus = currentStatus === 'ACTIVE' ? 'INACTIVE' : 'ACTIVE';
        
        await fetch(USER_SERVICE_URL + "/status/" + id + "?status=" + newStatus, { method: 'PUT' });
        loadUsers(); 
    }
    loadUsers();
</script>
</body>
</html>