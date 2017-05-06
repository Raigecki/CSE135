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
		<% 
		int userid = (Integer)session.getAttribute("userid");
		String err = request.getParameter("error");
		if (err != null) {
			%><p>Data modification failure</p>
		<%
		}
		
		Integer i=(Integer)(session.getAttribute("role"));
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
 	            ResultSet rsTemp = null;
 	            
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
						// do error checking on provided parameters (no null parameters allowed)
						String nameParam = request.getParameter("name");
						String descParam = request.getParameter("description");
						if (nameParam == "" || descParam == "") {
							%>
							<script>window.location.replace(window.location.href + "?error=1");</script>
							<%
						} else {
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
						%>Successfully inserted category<%
 	                }
 	            %>
 	            
 	            <%-- -------- UPDATE Code -------- --%>
 	            <%
 	                // Check if an update is requested
 	                if (action != null && action.equals("update")) {
 	                	// do error checking on provided parameters (no null parameters allowed)
						String nameParam = request.getParameter("name");
						String descParam = request.getParameter("description");
						if (nameParam == "" || descParam == "") {
							%>
							<script>window.location.replace(window.location.href + "?error=1");</script>
							<%
						} else {
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
						%>Successfully updated category.<%
 	                }
 	            %>
 	            
 	            <%-- -------- DELETE Code -------- --%>
 	            <%
 	                // Check if a delete is requested
 	                if (action != null && action.equals("delete")) {
 	                	// do error checking on provided parameters (no null parameters allowed)
						String nameParam = request.getParameter("name");
						String descParam = request.getParameter("description");
						if (nameParam == "" || descParam == "") {
							%>
							<script>window.location.replace(window.location.href + "?error=1");</script>
							<%
						} else {
 	                    	// Begin transaction
 	                    	conn.setAutoCommit(false);

 	                    	// Create the prepared statement and use it to
 	                    	// DELETE students FROM the Students table.
 	                    
 	                    	// see if somehow a product got added to category
 	                    	pstmt = conn.prepareStatement("SELECT * FROM incategory WHERE category = ?");
 	                    	pstmt.setInt(1, Integer.parseInt(request.getParameter("id")));
 	                    	rsTemp = pstmt.executeQuery();
 	                    	conn.commit();
 	                    	if (rsTemp.next()) {
 	                    		// then there is a product and we can no longer delete.
 	                    		%>Error: Cannot delete category: category now has at least one product associated with it.<%
 	                    	} else {
 	                    
 	                    		pstmt = conn
 	                        		.prepareStatement("DELETE FROM category WHERE id = ?");

 	                    		System.out.println("request.getParameter(id): " + request.getParameter("id"));
 	                    		pstmt.setInt(1, Integer.parseInt(request.getParameter("id")));
 	                    
 	                			// check if category has at least one product associated with it (concurrency check)
 	   							Statement tempstmt = conn.createStatement();
 	   							rsTemp = tempstmt.executeQuery("SELECT id FROM incategory WHERE category = " + Integer.parseInt(request.getParameter("id")));
 	   							if (!rsTemp.next()) {
 	   								// if there is no products in the category still, go ahead and update
 	   					
 	                    			int rowCount = pstmt.executeUpdate();

 	                    			// Commit transaction
 	                   				conn.commit();
 	                    			conn.setAutoCommit(true);
								} else {
									%> <script>window.location.replace(window.location.href + "?error=1");</script>
									<%
								}
 	               			}
						%>Successfully deleted category.<%
 	                	}
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
 	                	int id = rs.getInt("id");
 	                	int categoryOwner = rs.getInt("userid");
 	                	String name = rs.getString("name");
 	                	String descr = rs.getString("description");
 	                	
 	                	if (categoryOwner != userid) {
 	                		// then this user cannot update or delete this category
 	                		%>
 	                		<tr>
 	                			<td><p><%=name%></p></td>
 	                			<td><p><%=descr%></p></td>
 	                		</tr>
 	                	<%
 	                	} else {
 	            		%>

				
 	            <tr>
 	                <form action="./Categories.jsp" method="POST">
 	                    <input type="hidden" name="action" value="update"/>
 	                    <td><input name="name" value="<%=name%>"/></td>
 	                    <input type="hidden" name="id" value="<%=id%>">
 	                    

 	                <%-- Get the description --%>
 	                <td>
 	                    <input value="<%=descr%>" name="description" size="25"/>
 	                </td>
 	                <%-- Button --%>
 	                <td><input type="submit" value="Update"></td>
 	                </form>

				<%
				// check if category has at least one product associated with it
				statement = conn.createStatement();
				rsTemp = statement.executeQuery("SELECT id FROM incategory WHERE category = " + id);
				if (!rsTemp.next()) {
					// if there are NO products associated with this category, display the delete button
				%>

 	                <form action="./Categories.jsp" method="POST">
 	                    <input type="hidden" name="action" value="delete"/>
 	                    <input type="hidden" name="id" value="<%=id%>"/>
 	                    <%-- Button --%>
 	                <td><input type="submit" value="Delete"/></td>
 	                </form>
 	            </tr>
 	            <%
 	            		}
 	                }
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