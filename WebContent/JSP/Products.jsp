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
 	            ResultSet searchResults = null;
 	            
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
 	                    	
 	                    	pstmt = conn.prepareStatement("UPDATE incategory SET category = ? WHERE product = ?");
 	                    	pstmt.setInt(1, category);
 	                    	pstmt.setInt(2, Integer.parseInt(request.getParameter("productid")));
 	                    	pstmt.executeUpdate();
 	                    	conn.commit();
 	                    	
 	                    	conn.setAutoCommit(true);
						}
						%>Product successfully updated<%
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
 	                    pstmt.executeUpdate();
 	                   
 	                    // Commit transaction
 	                   	conn.commit();
 	             
 	                    pstmt = conn.prepareStatement("DELETE FROM incategory WHERE product = ?");
 	                    pstmt.setInt(1, Integer.parseInt(request.getParameter("productid")));
 	                    pstmt.executeUpdate();
 	                    conn.commit();
 	                    
 	                    conn.setAutoCommit(true);
 	                    %>Successfully deleted product.<%
			
 	                }
 	            %>


 	            <%-- -------- DISPLAY INSERT FORM CODE -------- --%>
 	            
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
 	                    </th><th><input type="submit" value="Insert"/></th>
 	                </form>
 	            </tr>
 	            </table>
 	            
 	             	                  
 	            <!-- SEARCH BAR STUFF -->
				<table border="1">
 	            <tr>
 	                <th>Search</th>
 	            </tr>

 	            <tr>
 	                <form action="./Products.jsp" method="GET">
 	                    <input type="hidden" name="action" value="setSearchStringToDisplay"/>
 	                    <td><input value="" name="searchstring" size="15"/></td>
 	                    <td><input type="submit" value="Search"/></td>
 	                </form>
 	            </tr>
 	            </table>
 	            
 	            <!--  CATEGORY LIST STUFF -->
 	            
 	            <%
 	            Statement stmt = conn.createStatement();
 	            rsTemp2 = stmt.executeQuery("SELECT * from category");
 	            String hrefstring = "./Products.jsp?action=setCategoryToDisplay&category=-1";
 	            %>
 	            </br><a href=<%=hrefstring %>>All Products</a>
 	            <%
 	            while (rsTemp2.next()) {
 	            	hrefstring = "./Products.jsp?action=setCategoryToDisplay" + "&category=" + rsTemp2.getInt("id");
 	            %>
 	            	</br><a href=<%=hrefstring %>><%=rsTemp2.getString("name")%></a>	
 	            <%
 	            }
 	            %>

 	            <%-- -------- DISPLAY PRODUCTS BASED ON SEARCH PARAMETERS CODE -------- --%>
 	            <%
 	            if (action != null && action.equals("setCategoryToDisplay")) {
 	            	session.setAttribute("categoryToDisplay", request.getParameter("category"));
 	            	session.setAttribute("searchStringToDisplay", null);
 	            	System.out.println("Category just got set to: " + (String) session.getAttribute("categoryToDisplay"));
 	            }
 	            if (action != null && action.equals("setSearchStringToDisplay")) {
 	            	if (request.getParameter("searchstring") != null) {
 	            		session.setAttribute("searchStringToDisplay", request.getParameter("searchstring"));
 	            	}
 	            }
 	            
 	            
 	            String categoryFilter = (String) session.getAttribute("categoryToDisplay");
 	            String searchFilter = (String) session.getAttribute("searchStringToDisplay");
 	            if (categoryFilter != null || searchFilter != null) {
 	            	System.out.println("Entered possible query if statement");
 	            	// if at least one of these is not null, we can display some stuff
 	            	if (searchFilter == null) {
 	            		searchFilter = "";
 	            	}
 	       
 	            	PreparedStatement searchQuery = null;
 	  				// decide what to query
 	            	if (categoryFilter == null || categoryFilter.equals("-1")) {
 	            		System.out.println("Executing search only query");
 	 	            	searchQuery = conn.prepareStatement("SELECT product.*, category.name AS cname FROM product JOIN category ON product.category = category.id WHERE product.name LIKE '%" + searchFilter + "%'");
 	            		searchResults = searchQuery.executeQuery();
 	            	} else if (searchFilter != null){
 	            		System.out.println("Executing category AND search query");
 	            		System.out.println("categoryFilter: " + categoryFilter);
 	            		System.out.println("searchFilter: " + searchFilter);
 	            		searchQuery = conn.prepareStatement("SELECT product.*, category.name AS cname FROM product JOIN category ON product.category = category.id WHERE category = " + categoryFilter + " AND product.name LIKE '%" + searchFilter + "%'");
 	            		searchResults = searchQuery.executeQuery();
 	            	}
 	            }
 	            
 	            if (searchResults != null) {
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
 	 	       		// get all categories
	               	PreparedStatement catStmt = conn.prepareStatement("SELECT * FROM category", ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	               	ResultSet catRes = catStmt.executeQuery();
 	 	            int index = 0;
 	 	            String categoryName = "";
 	 	            	while (searchResults.next()) {
 	 	           			index++;
 	 	           			int productid = searchResults.getInt("id");
	 	                	String name = searchResults.getString("name");
	 	                	String sku = searchResults.getString("sku");
	 	                	double price = searchResults.getDouble("price");
	 	                	int categoryid = searchResults.getInt("category"); 	           	
	 	                	
	 	                	// get the category name (very helpful)
	 	                	categoryName = searchResults.getString("cname");
	 	                	System.out.println("categoryName: " + categoryName);
	 	                	%>
	 	 	 	            <tr>
	 	 	 	                <form action="./Products.jsp" method="POST">
	 	 	 	                    <input type="hidden" name="action" value="update"/>
	 	 	 	                    <td><input name="name" value="<%=name%>"/></td>
	 	 	 	                    <td><input name="sku" value="<%=sku%>"/></td>
	 	 	 	                    <td><input name="price" value="<%=price%>"/></td>
	 	 	 	                    <td><select name="category">
	 	 	 	                    <%
	 	 	 	                    
	 	 	 	                    String tempName;
	 	 	 	                    int innerIndex = 0;
	 	 	 	                 	PreparedStatement tempStmt2;
	 	 	 	                    while (catRes.next()) {
	 	 	 	                    	innerIndex++;
	 	 	 	                    		 	 	 	                    	
	 	 	 	                    	tempName = catRes.getString("name");
	 	 	 	                    	if (tempName.equals(categoryName)) {
	 	 	 	                    		%>
	 	 	 	                    		<option value=<%=catRes.getInt("id")%> selected><%=tempName%></option>
	 	 	 	                    	<%
	 	 	 	                    	} else {
	 	 	 	                    %>
	 	 	 	                    	<option value=<%=catRes.getInt("id")%>><%=tempName%></option>
	 	 	 	                    <%
	 	 	 	                    	}
	 	 	 	                    }
	 	 	 	                    %>
	 	 	 	                    </select></td>
	 	 	 	                    <input type="hidden" name="productid" value="<%=productid%>"/>
	 	 	 	                    
	 	 	 	                <%-- Button --%>
	 	 	 	                <td><input type="submit" value="Update"></td>
	 	 	 	                </form>

	 	 	 	                <form action="./Products.jsp" method="POST">
	 	 	 	                    <input type="hidden" name="action" value="delete"/>
	 	 	 	                    <input type="hidden" name="productid" value="<%=productid%>"/>
	 	 	 	                    <%-- Button --%>
	 	 	 	                <td><input type="submit" value="Delete"/></td>
	 	 	 	                </form>
	 	 	 	            </tr>
	 	 	 	           
	 	 	 	        <% 
	 	 	 	        catRes.beforeFirst();
 	 	            	} %>
 	 	         
 	 	            	</table>
 	 	            <% 
 	 	            	System.out.println("index: " + index);	
 	            	} %>
 	            	
 	           
 	            <%-- -------- Close Connection Code -------- --%>
 	            <%
 	                // Close the ResultSet
 	                /*rs.close();
 	            	rsTemp.close();
 	            	rsTemp2.close();*/

 	                // Close the Statement
 	                statement.close();

 	                // Close the Connection
 	                conn.close();
 	            } catch (SQLException e) {

 	                // Wrap the SQL exception in a runtime exception to propagate
 	                // it upwards
 	                %>Failed to insert new product.<%
 	               
 	            } finally {
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
</body>
</html>