<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Product Order</title>
</head>
<body>

	<a href="Home.jsp">Home</a> </br> </br>
	
	<%@ page import="java.sql.*" %>

	<!--////////////////////// Open Connection Code /////////////////// -->
	
	<% 
		Connection conn;
		
		try {
			
			conn = DriverManager.getConnection("jdbc:postgresql://" +
					"localhost:5432/CSE135", "postgres", "$$JBlue");
			
	%>
	
	<!-- //////////////////////Initialization Code //////////////////// -->
	
	<%
	
			//Get all the information for the item that is just clicked
			String productName = (String) session.getAttribute("productName");
			String productSKU = (String) session.getAttribute("productSKU");
			Integer productPrice = (Integer) session.getAttribute("productPrice");
			Integer productId = (Integer) session.getAttribute("productId");
			
			System.out.println(productName);
			System.out.println(productSKU);
			System.out.println(productPrice);
			System.out.println(productId);
			
			
			//Get information for the current shopping cart
			Integer userId = (Integer) session.getAttribute("userid");
			System.out.println(userId);
			
			PreparedStatement getStmt = conn.prepareStatement("SELECT " +
					"product.name, product.price, product.sku, " +
					"cart.quantity, cart.product " +
					"from cart " + 
					"join product on product.id = cart.product " +
					"where cart.userid =?");
			getStmt.setInt(1, userId);
			ResultSet cartItem = getStmt.executeQuery();
	%>

	<h4>Select Quantity:</h4>
	
	<table border="1">
		<tr>
			<th>Product</th>
			<th>SKU</th>
			<th>Price</th>
			<th>Quantity</th>
		</tr>
		<tr>
			<form>
				<td><input name="productName" value="<%= productName %>" /></td>
				<td><input name="productSKU" value="<%= productSKU %>" /></td>
				<td><input name="productPrice" value="<%= productPrice %>" /></td>
				<td><input type="text" name="productQuantity"/></td>	
				<td><input type="submit" value="Add" /></td>
				<input type="hidden" name="action" value="add" />		
				<input type="hidden" name="productId" value="<%= productId %>" />
			</form>
		</tr>
		
	</table>
	
	<!-- ////////////////////////////Update Code /////////////////////////////// -->
	<%
	
			String action = request.getParameter("action");
			
			if (action != null && action.equals("add")) {
			
				Integer prodId = Integer.parseInt(request.getParameter("productId"));
				Integer idUser = (Integer) session.getAttribute("userid");
				Integer prodQuantity = Integer.parseInt(request.getParameter("productQuantity"));
				
				conn.setAutoCommit(false);
				PreparedStatement insStmt = conn.prepareStatement("INSERT INTO cart " +
						"(userid, product, quantity) " + 
						"values (?, ?, ?)");
				insStmt.setInt(1, idUser);
				insStmt.setInt(2, prodId);
				insStmt.setInt(3, prodQuantity);
				
				int succ = insStmt.executeUpdate();
				
				conn.commit();
				conn.setAutoCommit(true);
				
				response.sendRedirect("Browse.jsp");
			}
		
	%>

	<h3>Your Orders:</h3>
	
	<table border="1">
		<tr>
			<th>Product</th>
			<th>SKU</th>
			<th>Price</th>
			<th>Quantity</th>
		</tr>
	
		<!--//// Iteration Code ////-->
		<% while(cartItem.next()) { 
		
			String itemName = cartItem.getString("name");
			String itemSKU = cartItem.getString("sku");
			Integer itemPrice = cartItem.getInt("price");
			Integer itemQuantity = cartItem.getInt("quantity");
			Integer itemId = cartItem.getInt("product");
			
			System.out.println(itemName);
			System.out.println(itemSKU);
			System.out.println(itemPrice);
			System.out.println(itemQuantity);
			System.out.println(itemId);
			
		%>
		<tr>
			<td><input name="itemName" value="<%= itemName %>" /></td>
			<td><input name="itemSKU" value="<%= itemSKU %>" /></td>
			<td><input name="itemPrice" value="<%= itemPrice %>" /></td>
			<td><input name="itemQuantity" value="<%= itemQuantity %>" /></td>		
			<input type="hidden" name="itemId" value="<%= itemId %>" />	
		</tr>
		<% } %>
	</table>

	<!--//////////////////// Close Connection Code //////////////////// -->
	<%
	
			conn.close();
	
		} 
		catch(Exception e) {
			e.printStackTrace();
		}
	%>

</body>
</html>