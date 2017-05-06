<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Browse Products</title>
</head>
<body>

	<a href="Home.jsp">Home</a> </br>
	<a href="Buy.jsp">Buy Shopping Cart</a> </br>
	
	<%@ page import="java.sql.*" %>
	
	<!-- //////////////////////////////////////Connection Code/////////////////////////////////////////// -->
		
	<%
	
		Connection conn;
		try {
								
			Class.forName("org.postgresql.Driver");
				
			conn = DriverManager.getConnection("jdbc:postgresql://" +
					"localhost:5432/CSE135", "postgres", "$$JBlue");
			
	%>
	
	<!-- /////////////////////////////////////Initialization Code//////////////////////////////////////// -->
	<%

		PreparedStatement popStmt = conn.prepareStatement("SELECT name, id FROM category");
		ResultSet catList = popStmt.executeQuery();		
		
	%>
		
		
	<!-- /////////////////Search Bar Code/////////////////// -->
	
	 	</br></br>
 	     <form method="get">
 	     	<input type="hidden" name="action" 
 	       		value="setSearchStringToDisplay"/>
 	     	<input value="" name="searchstring" size="15"/>
 	      	<input type="submit" value="Search"/>
 	     </form>
 		
 	<!-- /////////////////Category List Code//////////////// -->
 	
 	</br>
 	<h4>Categories:</h4>
 	
 	<%
 		PreparedStatement catStmt = conn.prepareStatement("SELECT * from category");
 	    ResultSet catRes = catStmt.executeQuery();
 	    
 	 	//tells display to display all products
         String hrefstring = "./Browse.jsp?action=setCategoryToDisplay&category=-1";
         %>
         <a href=<%=hrefstring %>>All Products</a></br>
 	<%
 	    while (catRes.next()) {
 	    	hrefstring = "./Browse.jsp?action=setCategoryToDisplay" + "&category=" + catRes.getInt("id");
 	%>
 	    <a href=<%=hrefstring %>><%=catRes.getString("name")%></a></br>	
 	<%
 	    }
 	%>
 	
 	<%-- //////////Display products based on search parameter /////// --%>
 	
	<%
		String action = request.getParameter("action");
	
		//When someone clicks on a category link
 	    if (action != null && action.equals("setCategoryToDisplay")) {
 	    	session.setAttribute("categoryToDisplay", request.getParameter("category"));
 	        session.setAttribute("searchStringToDisplay", null);
 	    }
	
		//When someone uses the search bar
 	    if (action != null && action.equals("setSearchStringToDisplay")) {
 	    	if (request.getParameter("searchstring") != null) {
 	        	session.setAttribute("searchStringToDisplay", request.getParameter("searchstring"));
 	        }
 	    }
 	            
 	            
 	    String categoryFilter = (String) session.getAttribute("categoryToDisplay");
 	    String searchFilter = (String) session.getAttribute("searchStringToDisplay");
 	    ResultSet searchResults = null;
 	    
 	    if (categoryFilter != null || searchFilter != null) {
 	    	
 	        // if at least one of these is not null, we can display some stuff
 	        if (searchFilter == null) {
 	        	searchFilter = "";
 	        }
 	       
 	        PreparedStatement searchQuery = null;
 	  		// decide what to query!
 	  				
 	  		//case when we need to display products without category
 	        if (categoryFilter == null || categoryFilter.equals("-1")) {
 	        	System.out.println("Executing search only query");
 	 	        searchQuery = conn.prepareStatement("SELECT product.*, category.name AS cname FROM product JOIN category ON product.category = category.id WHERE product.name LIKE '%" + searchFilter + "%'");
 	            searchResults = searchQuery.executeQuery();
 	        } 
 	  		
 	        //case when we need to search based on category and search string
 	        else if (searchFilter != null){
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
 	        </br>
 	        <table border="1">
 	        	<tr>
 	            	<th>Name</th>
 	                <th>Sku</th>
 	                <th>Price</th>
 	                <th>Category</th>               
 	            </tr>
 	            
 	       	<!-- /////////////////Insertion Code///////////////////// -->
	<%
		
		if (action != null && action.equals("buy")) {
				
			System.out.println("Got into buy");
				
			Integer productId = Integer.parseInt(request.getParameter("productid"));
			String productName = request.getParameter("name");
			String productSKU = request.getParameter("sku");
			Integer productPrice = Integer.parseInt(request.getParameter("price"));
				
			session.setAttribute("productId", productId);
			session.setAttribute("productName", productName);
			session.setAttribute("productSKU", productSKU);
			session.setAttribute("productPrice", productPrice);
				
			response.sendRedirect("Cart.jsp");
		}
	%>	

 	            <%-- -------- Iteration Code -------- --%>
 	            <%
 	       		// get all categories
              	catStmt = conn.prepareStatement("SELECT * FROM category", ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
              	catRes = catStmt.executeQuery();
              	
 	            String categoryName = "";
 	            while (searchResults.next()) {
 	            		
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
	 	 	    	<form method="post">
	 	 	        	
	 	 	            <td><input name="name" value="<%=name%>"/></td>
	 	 	            <td><input name="sku" value="<%=sku%>"/></td>
	 	 	            <td><input name="price" value="<%=price%>"/></td>
	 	 	                    
	 	 	            <input type="hidden" name="productid" value="<%=productid%>"/>
	 	 	            <input type="hidden" name="action" value="buy"/>  
	 	 	                  
	 	 	            <%-- Button --%>
	 	 	            <td><input type="submit" value="Add to Cart"></td>
	 	 	        </form>

	 	 	    </tr>
	 	 	           
	 	 	        <% 
	 	 	        catRes.beforeFirst();
 	            	} %>
 	         
 	            	</table>
 	            <% 
            	} 
            	%>
 	  
	
	</br>
	
 	<!-- ///////////////////////////////////Close connection code/////////////////////////////////////// -->
	
	<%
			conn.close();
			//result.close();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	%>

</body>
</html>