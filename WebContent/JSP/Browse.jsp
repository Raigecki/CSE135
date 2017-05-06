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
	<a href="Buy.jsp">Buy Shopping Cart</a>
	
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
		
	<h3>Categories:</h3>
	
	<form method="get">
		<select name="select_category">
		
		<!-- Iteration Code -->
		<%	
		
			while(catList.next()) { 
				
				String category = (String) catList.getString("name");
				Integer id = (Integer) catList.getInt("id");
				System.out.println(category);
		%>			
		
			<option value="<%= id%>"><%=category%></option>					
			
		<% } 
			popStmt.close();
			catList.close();
		%>
				
		</select>
		<input type="hidden" name="action" value="search"/>
		<input type="submit" value="Search"/>
	</form>
	
	</br>
	<table name=table_Products border="1">
	
		<tr>
			<th>Product</th>
			<th>SKU</th>
			<th>Price</th>
			<th>
		</tr>
		
	<!-- ////////////////////////////////////////Search Code/////////////////////////////////////////// -->
	<%
	
		String action = request.getParameter("action");
		if (action != null && action.equals("search")) {
			
			Integer categoryid = Integer.parseInt(request.getParameter("select_category"));
		
			conn.setAutoCommit(false);
			
			PreparedStatement searchStmt = conn.prepareStatement("SELECT * FROM " + 
					"product WHERE category=?");	
			
			searchStmt.setInt(1, categoryid);
			ResultSet prod = searchStmt.executeQuery();
		
	%>
	
	<!--///// Iteration Code /////-->
	<%
			while(prod.next()) {
			
				Integer prodId = prod.getInt("id");
				String prodName = prod.getString("name");
				String prodSKU = prod.getString("sku");
				Integer prodPrice = prod.getInt("price");
	%>
		<tr>
			<form method>
				<td><input name="prodName" value="<%= prodName %>" /></td>		
				<td><input name="prodSKU" value="<%= prodSKU %>" /></td>
				<td><input name="prodPrice" value="<%= prodPrice %>" /></td>
				<input type="hidden" name="prodId" value=<%= prodId %> />
				<input type="hidden" name="action" value="buy">
				<td><input type="submit" value="Add to Cart"/></td>
			</form>
		</tr>
		
	<% 		
			} 
			searchStmt.close();
			prod.close();
		}
		
	%>
	
	<!-- /////////////////////////////////////Insertion Code////////////////////////////////////////// -->
	<%
		
		if (action != null && action.equals("buy")) {
				
			System.out.println("Got into buy");
				
			Integer productId = Integer.parseInt(request.getParameter("prodId"));
			String productName = request.getParameter("prodName");
			String productSKU = request.getParameter("prodSKU");
			Integer productPrice = Integer.parseInt(request.getParameter("prodPrice"));
				
			session.setAttribute("productId", productId);
			session.setAttribute("productName", productName);
			session.setAttribute("productSKU", productSKU);
			session.setAttribute("productPrice", productPrice);
				
			response.sendRedirect("Cart.jsp");
		}
	%>	
	
	</table>
	
	
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