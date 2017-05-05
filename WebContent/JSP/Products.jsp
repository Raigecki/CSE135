<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Products</title>
</head>
<body>

	<a href="Home.jsp">Home</a>

<% 
		int userid = (Integer)session.getAttribute("userid");
		String err = request.getParameter("error");
		if (err != null) {
			%>Data modification failure
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
 	            ResultSet rsTemp2 = null;
 	            
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
						String skuParam = request.getParameter("sku");
						String priceParam = request.getParameter("price");
						String categoryParam = request.getParameter("category");
						System.err.println("name: " + nameParam + "sku: " + skuParam + "price: " + priceParam + "category: " + categoryParam);

						if (nameParam == "" || skuParam == "" || priceParam == "" || categoryParam == "") {
							%>
							<script>window.location.replace(window.location.href + "?error=1");</script>
							<%
							
						} else {
							double price = Double.parseDouble(priceParam);
							int category = Integer.parseInt(categoryParam);
 	                    	// Begin transaction
 	                    	conn.setAutoCommit(false);

 	                    	// Create the prepared statement and use it to
 	                    	// INSERT student values INTO the students table.
 	                    	pstmt = conn
 	                    	.prepareStatement("INSERT INTO product (name, sku, price, category) VALUES (?, ?, ?, ?)");

 	                    	pstmt.setString(1, nameParam);
 	                    	pstmt.setString(2, skuParam);
 	                    	pstmt.setDouble(3, price);
 	                    	pstmt.setInt(4, category);
 	                    	int rowCount = pstmt.executeUpdate();

 	                   	 	// Commit transaction
 	                    	conn.commit();
 	                   	 	conn.setAutoCommit(true);
 	                    	
 	                    	pstmt = conn.prepareStatement("SELECT * FROM product WHERE name = ?");
 	                    	pstmt.setString(1, nameParam);
 	                    	rsTemp = pstmt.executeQuery();
 	                    	int productid = 0;
 	                    	if (rsTemp.next()) {
 	                    		productid = rsTemp.getInt("id");
 	                    		System.out.println("product id: " + productid);
 	                    	} else {
 	                    		// catastrophic failure; product never got inserted...
 	                    		%> <script>window.location.replace(window.location.href + "?error=1");</script>
 	                    		<%
 	                    	}
 	                    	
 	                    	conn.setAutoCommit(false);
 	                    	pstmt = conn.prepareStatement("INSERT INTO incategory (product, category) VALUES (?, ?)");
 	                    	pstmt.setInt(1, productid);
 	                    	pstmt.setInt(2, category);
 	                    	rowCount = pstmt.executeUpdate();
 	                    	System.out.println("RowCount: " + rowCount);
 	                    	conn.commit();
 	                    	conn.setAutoCommit(true);
						}
						%>You have successfully added product <%=nameParam%>.<%
 	                }
 	            %>
 	            
 	            <%-- -------- UPDATE Code -------- --%>
 	            <%
 	                // Check if an update is requested
 	                if (action != null && action.equals("update")) {
 	                // do error checking on provided parameters (no null parameters allowed)
						String nameParam = request.getParameter("name");
						String skuParam = request.getParameter("sku");
						String priceParam = request.getParameter("price");
						String categoryParam = request.getParameter("category");
						if (nameParam == "" || skuParam == "" || priceParam == "" || categoryParam == "") {
							%>
							<script>window.location.replace(window.location.href + "?error=1");</script>
							<%
						} else {
							double price = Double.parseDouble(priceParam);
							int category = Integer.parseInt(categoryParam);
 	                    	// Begin transaction
 	                    	conn.setAutoCommit(false);

 	                    	// Create the prepared statement and use it to
 	                    	// UPDATE student values in the Students table.
 	                    	pstmt = conn
 	                        .prepareStatement("UPDATE product SET name = ?, sku = ?, price = ?, category = ? "
 	                            + "WHERE id = ?");

 	                    	pstmt.setString(1, nameParam);
 	                    	pstmt.setString(2, skuParam);
 	                    	pstmt.setDouble(3, price);
 	                    	pstmt.setInt(4, category);
 	                    	pstmt.setInt(5, Integer.parseInt(request.getParameter("productid")));
 	                    	int rowCount = pstmt.executeUpdate();

 	                    	// Commit transaction
 	                    	conn.commit();
 	                    	conn.setAutoCommit(true);
						}
 	                }
 	            %>
 	            
 	            <%-- -------- DELETE Code -------- --%>
 	            <%
 	                // Check if a delete is requested
 	                if (action != null && action.equals("delete")) {
 	                	
 	                    // Begin transaction
 	                    conn.setAutoCommit(false);

 	                    // Create the prepared statement and use it to
 	                    
 	                    pstmt = conn
 	                        .prepareStatement("DELETE FROM product WHERE id = ?");

 	                    pstmt.setInt(1, Integer.parseInt(request.getParameter("productid")));
 	                   
 	                    // Commit transaction
 	                   	conn.commit();
 	                    conn.setAutoCommit(true);
			
 	                }
 	            %>
 	            <%-- -------- DISPLAY PRODUCTS CODE -------- --%>
 	            <%
 	            	// check if we are to display products
 	            	if (action != null && action.equals("display")) {
 	            		// get search and display parameters
 	            		String category = request.getParameter("categoryid");
 	            		String searchString = request.getParameter("searchstring");
 	            		
 	 	                // Create the statement
 	 	                Statement statement = conn.createStatement();

 	 	                // Use the created statement to SELECT
 	 	                if (category.equals("")) {
 	 	                	rs = statement.executeQuery("SELECT * FROM product WHERE name LIKE %" + searchString + "%");
 	 	                } else {
 	 	                	rs = statement.executeQuery("SELECT * FROM product WHERE category = " + category + " AND name LIKE %" + searchString + "%");
 	 	                }
 	            	
 	 	            %>
 	 	            
 	 	            <!-- Add an HTML table header row to format the results -->
 	 	            <table border="1">
 	 	            <tr>
 	 	                <th>Name</th>
 	 	                <th>Sku</th>
 	 	                <th>Price</th>
 	 	                <th>Category</th>
 	 	            </tr>

 	 	            <%-- -------- Iteration Code -------- --%>
 	 	            <%
						Statement stmt = null;
 	 	                // Iterate over the ResultSet
 	 	                while (rs.next()) {
 	 	                	int id = rs.getInt("id");
 	 	                	String name = rs.getString("name");
 	 	                	String sku = rs.getString("sku");
 	 	                	double price = rs.getDouble("price");
 	 	                	int categoryid = rs.getInt("category");
 	 	                	
 	 	                	// get the category name (very helpful)
 	 	                	String categoryName;
 	 	 	            	rsTemp = stmt.executeQuery("SELECT name FROM category WHERE id = " + categoryid);
 	 	 	            	rsTemp.next();
 	 	 	            	categoryName = rsTemp.getString("name");
 	 	 	            	
 	 	 	            	// get all products under category
 	 	 	            	stmt = conn.createStatement();
 	 	 	            	rsTemp = stmt.executeQuery("SELECT * FROM category");

 					%>
 	 	            <tr>
 	 	                <form action="./Products.jsp" method="POST">
 	 	                    <input type="hidden" name="action" value="update"/>
 	 	                    <td><input name="name" value="<%=name%>"/></td>
 	 	                    <td><input name="sku" value="<%=sku%>"/></td>
 	 	                    <td><input name="price" value="<%=price%>"/></td>
 	 	                    <td><select name="category" selected="<%=categoryName%>">
 	 	                    <%
 	 	                    String tempName;
 	 	                    while (rsTemp.next()) {
 	 	                    	rsTemp2 = stmt.executeQuery("SELECT name FROM category WHERE id = " + rsTemp.getInt("id"));
 	 	                    	rsTemp2.next();
 	 	                    	tempName = rsTemp2.getString("name");
 	 	                    %>
 	 	                    	<option value=<%=categoryid%>><%=tempName%></option>
 	 	                    <%
 	 	                    }
 	 	                    %>
 	 	                    </select>
 	 	                    <input type="hidden" name="id" value="<%=id%>"/>
 	 	                    
 	 	                <%-- Button --%>
 	 	                <td><input type="submit" value="Update"></td>
 	 	                </form>

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
 	            	%>

 	            <%-- -------- SELECT Statement Code -------- --%>
 	            <%
 	                // Create the statement
 	                Statement statement = conn.createStatement();

 	                // Use the created statement to SELECT
 	                rs = statement.executeQuery("SELECT * FROM category");
 	            %>
 	            
 	            <!-- Add an HTML table header row to format the results -->
 	            <table border="1">
 	            <tr>
 	                <th>Name</th>
 	                <th>SKU</th>
 	                <th>Price</th>
 	                <th>Category</th>
 	            </tr>

 	            <tr>
 	                <form action="./Products.jsp" method="POST">
 	                    <input type="hidden" name="action" value="insert"/>
 	                    <th><input value="" name="name" size="15"/></th>
 	                    <th><input value="" name="sku" size=25/></th>
 	                    <th><input value="" name="price" size=10/></th>
 	                    <th><select name="category">
 	                    <%
 	                    // iterate over category list and collect results in dropdown menu
 	                    while (rs.next()) {
 	                    	%> <option value=<%=rs.getInt("id") %>><%=rs.getString("name") %></option>
 	                    	<%
 	                    }
 	                    %>
 	                    </select>
 	                    <th><input type="submit" value="Insert"/></th>
 	                </form>
 	            </tr>

 	            

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
 	                %>Failure to insert new product.<%
 	               
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