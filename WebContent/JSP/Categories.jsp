<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Categories</title>
</head>
<body>

			<a href="Home.jsp">Home</a>
		<% Integer i=(Integer)(session.getAttribute("role"));
 			if (i == null) {
 		%>
 		
 		<p>You must log in to see this page.</p>
 		<%
 			}
 			else if (i == 1) { // if user
 		%>
 		
 		<p>This page is available to owners only</p>
 		<%
 			} else if (i == 0) {  // if owner
 				// display owner relevant details
		%>
		<table>
			<tr>
				<td>
 	            <%-- Import the java.sql package --%>
 	            <%@ page import="java.sql.*"%>
 	            <%-- -------- Open Connection Code -------- --%>
 	            <%
 			
 	            Connection conn = null;
 	            PreparedStatement pstmt = null;
 	            ResultSet rs = null;
 	            
 	            try {
 	                // Registering Postgresql JDBC driver with the DriverManager
 	                Class.forName("org.postgresql.Driver");

 	                // Open a connection to the database using DriverManager
 	                conn = DriverManager.getConnection(
 	                    "jdbc:postgresql://localhost:5432/CSE135?" +
 	                    "user=postgres&password=$$JBlue");
 	            %>
 	            
 	            <%-- -------- INSERT Code -------- --%>
 	            <%
 	                String action = request.getParameter("action");
 	                // Check if an insertion is requested
 	                if (action != null && action.equals("insert")) {

 	                    // Begin transaction
 	                    conn.setAutoCommit(false);

 	                    // Create the prepared statement and use it to
 	                    // INSERT student values INTO the students table.
 	                    pstmt = conn
 	                    .prepareStatement("INSERT INTO category (userid, name, description) VALUES (?, ?, ?)");

 	                    pstmt.setInt(1, (Integer)session.getAttribute("userid"));
 	                    pstmt.setString(2, request.getParameter("name"));
 	                    pstmt.setString(3, request.getParameter("description"));
 	                    int rowCount = pstmt.executeUpdate();

 	                    // Commit transaction
 	                    conn.commit();
 	                    conn.setAutoCommit(true);
 	                }
 	            %>
 	            
 	            <%-- -------- UPDATE Code -------- --%>
 	            <%
 	                // Check if an update is requested
 	                if (action != null && action.equals("update")) {

 	                    // Begin transaction
 	                    conn.setAutoCommit(false);

 	                    // Create the prepared statement and use it to
 	                    // UPDATE student values in the Students table.
 	                    pstmt = conn
 	                        .prepareStatement("UPDATE category SET name = ?, description = ? "
 	                            + "WHERE id = ?");

 	                    pstmt.setString(1, request.getParameter("name"));
 	                    pstmt.setString(2, request.getParameter("description"));
 	                    System.out.println("request.getParameter(id): " + request.getParameter("id"));
 	                    pstmt.setInt(3, Integer.parseInt(request.getParameter("id")));
 	                    int rowCount = pstmt.executeUpdate();

 	                    // Commit transaction
 	                    conn.commit();
 	                    conn.setAutoCommit(true);
 	                }
 	            %>
 	            
 	            <%-- -------- DELETE Code -------- --%>
 	            <%
 	                // Check if a delete is requested
 	                if (action != null && action.equals("delete")) {

 	                    // Begin transaction
 	                    conn.setAutoCommit(false);

 	                    // Create the prepared statement and use it to
 	                    // DELETE students FROM the Students table.
 	                    pstmt = conn
 	                        .prepareStatement("DELETE FROM category WHERE id = ?");

 	                    System.out.println("request.getParameter(id): " + request.getParameter("id"));
 	                    pstmt.setInt(1, Integer.parseInt(request.getParameter("id")));
 	                    int rowCount = pstmt.executeUpdate();

 	                    // Commit transaction
 	                    conn.commit();
 	                    conn.setAutoCommit(true);
 	                }
 	            %>

 	            <%-- -------- SELECT Statement Code -------- --%>
 	            <%
 	                // Create the statement
 	                Statement statement = conn.createStatement();

 	                // Use the created statement to SELECT
 	                // the student attributes FROM the Student table.
 	                rs = statement.executeQuery("SELECT * FROM category");
 	            %>
 	            
 	            <!-- Add an HTML table header row to format the results -->
 	            <table border="1">
 	            <tr>
 	                <th>Name</th>
 	                <th>Description</th>
 	            </tr>

 	            <tr>
 	                <form action="./Categories.jsp" method="POST">
 	                    <input type="hidden" name="action" value="insert"/>
 	                    <th><input value="" name="name" size="15"/></th>
 	                    <th><input value="" name="description" size=25/></th>
 	                    <th><input type="submit" value="Insert"/></th>
 	                </form>
 	            </tr>

 	            <%-- -------- Iteration Code -------- --%>
 	            <%
 	                // Iterate over the ResultSet
 	                while (rs.next()) {
 	            %>

 	            <tr>
 	                <form action="./Categories.jsp" method="POST">
 	                    <input type="hidden" name="action" value="update"/>
 	                    <td><input name="name" value="<%=rs.getString("name")%>"/></td>
 	                    <input type="hidden" name="id" value="<%=rs.getInt("id")%>">

 	                <%-- Get the description --%>
 	                <td>
 	                    <input value="<%=rs.getString("description")%>" name="description" size="25"/>
 	                </td>

 	                <%-- Button --%>
 	                <td><input type="submit" value="Update"></td>
 	                </form>
 	                <form action="./Categories.jsp" method="POST">
 	                    <input type="hidden" name="action" value="delete"/>
 	                    <input type="hidden" name="id" value="<%=rs.getInt("id")%>"/>
 	                    <%-- Button --%>
 	                <td><input type="submit" value="Delete"/></td>
 	                </form>
 	            </tr>

 	            <%
 	            System.out.println("rs.getInt(id): " + rs.getInt("id"));
 	                }
 	            %>

 	            <%-- -------- Close Connection Code -------- --%>
 	            <%
 	                // Close the ResultSet
 	                rs.close();

 	                // Close the Statement
 	                statement.close();

 	                // Close the Connection
 	                conn.close();
 	            } catch (SQLException e) {

 	                // Wrap the SQL exception in a runtime exception to propagate
 	                // it upwards
 	                throw new RuntimeException(e);
 	            }
 	            finally {
 	                // Release resources in a finally block in reverse-order of
 	                // their creation

 	                if (rs != null) {
 	                    try {
 	                        rs.close();
 	                    } catch (SQLException e) { } // Ignore
 	                    rs = null;
 	                }
 	                if (pstmt != null) {
 	                    try {
 	                        pstmt.close();
 	                    } catch (SQLException e) { } // Ignore
 	                    pstmt = null;
 	                }
 	                if (conn != null) {
 	                    try {
 	                        conn.close();
 	                    } catch (SQLException e) { } // Ignore
 	                    conn = null;
 	                }
 	            }
 	            %>
			<% 
			}
 			%>
 	        	</table>
 	        	</td>
 	      	</tr>
</table>
</body>
</html>