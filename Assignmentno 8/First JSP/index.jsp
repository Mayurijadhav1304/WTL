<%@ page import="java.sql.*" %>
<html>
<head>
    <title>Student Management</title>
    <style>
        table {
            width: 80%;
            border-collapse: collapse;
            margin: 20px auto;
        }
        th, td {
            padding: 10px;
            text-align: center;
            border: 2px solid #000;
        }
        form {
            margin: 20px auto;
            width: 50%;
        }
        h1, h2 {
            text-align: center;
        }
        input[type="text"], input[type="submit"] {
            padding: 8px;
            margin: 5px;
        }
    </style>
</head>
<body>

<%
Connection con = null;
PreparedStatement pstmt = null;
Statement stmt = null;
ResultSet rs = null;
String url = "jdbc:mysql://localhost:3306/student_db1";
String username = "root";
String password = "";

try {
    Class.forName("com.mysql.jdbc.Driver");
    con = DriverManager.getConnection(url, username, password);
    stmt = con.createStatement();

    // Handling Actions
    String action = request.getParameter("action");
    if (action != null) {
        if (action.equals("insert")) {
            String id = request.getParameter("id");
            String name = request.getParameter("name");
            String cls = request.getParameter("class");
            String division = request.getParameter("division");
            String city = request.getParameter("city");

            pstmt = con.prepareStatement("INSERT INTO info VALUES (?, ?, ?, ?, ?)");
            pstmt.setString(1, id);
            pstmt.setString(2, name);
            pstmt.setString(3, cls);
            pstmt.setString(4, division);
            pstmt.setString(5, city);
            pstmt.executeUpdate();
            out.println("<p style='color:green;text-align:center;'>Record Inserted Successfully!</p>");
        } else if (action.equals("update")) {
            String id = request.getParameter("id");
            String name = request.getParameter("name");
            String cls = request.getParameter("class");
            String division = request.getParameter("division");
            String city = request.getParameter("city");

            pstmt = con.prepareStatement("UPDATE info SET name=?, class=?, division=?, city=? WHERE stud_id=?");
            pstmt.setString(1, name);
            pstmt.setString(2, cls);
            pstmt.setString(3, division);
            pstmt.setString(4, city);
            pstmt.setString(5, id);
            pstmt.executeUpdate();
            out.println("<p style='color:blue;text-align:center;'>Record Updated Successfully!</p>");
        } else if (action.equals("delete")) {
            String id = request.getParameter("id");

            pstmt = con.prepareStatement("DELETE FROM info WHERE stud_id=?");
            pstmt.setString(1, id);
            pstmt.executeUpdate();
            out.println("<p style='color:red;text-align:center;'>Record Deleted Successfully!</p>");
        }
    }
} catch (Exception e) {
    out.println("<p style='color:red;text-align:center;'>Error: " + e.getMessage() + "</p>");
}
%>

<h1>Welcome to Sanjivani College of Engineering, IT Department</h1>

<h2>Student Information Table</h2>
<table>
<tr>
    <th>Stud_id</th>
    <th>Name</th>
    <th>Class</th>
    <th>Division</th>
    <th>City</th>
    <th>Actions</th>
</tr>

<%
try {
    rs = stmt.executeQuery("SELECT * FROM info");
    while (rs.next()) {
%>
<tr>
    <form method="post">
        <td><input type="text" name="id" value="<%= rs.getString("stud_id") %>" readonly></td>
        <td><input type="text" name="name" value="<%= rs.getString("name") %>"></td>
        <td><input type="text" name="class" value="<%= rs.getString("class") %>"></td>
        <td><input type="text" name="division" value="<%= rs.getString("division") %>"></td>
        <td><input type="text" name="city" value="<%= rs.getString("city") %>"></td>
        <td>
            <input type="hidden" name="action" value="update">
            <input type="submit" value="Update">
    </form>
    <form method="post" style="display:inline;">
        <input type="hidden" name="id" value="<%= rs.getString("stud_id") %>">
        <input type="hidden" name="action" value="delete">
        <input type="submit" value="Delete">
    </form>
        </td>
</tr>
<%
    }
} catch (Exception e) {
    out.println("<p style='color:red;text-align:center;'>Error displaying table: " + e.getMessage() + "</p>");
} finally {
    if (rs != null) rs.close();
    if (stmt != null) stmt.close();
    if (con != null) con.close();
}
%>
</table>

<h2>Insert New Student</h2>
<form method="post">
    Stud_id: <input type="text" name="id" required><br>
    Name: <input type="text" name="name" required><br>
    Class: <input type="text" name="class" required><br>
    Division: <input type="text" name="division" required><br>
    City: <input type="text" name="city" required><br><br>
    <input type="hidden" name="action" value="insert">
    <input type="submit" value="Insert">
</form>

</body>
</html>
