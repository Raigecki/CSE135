<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Buy Shopping Cart</title>
</head>
<body>

	<a href="Home.jsp">Home</a> </br>

	<%@ page import="java.sql.*" %>
	
	<!-- //////////////////////////////////////Connection Code/////////////////////////////////////////// -->
		
	<%
	
		Connection conn;
		try {
								
			Class.forName("org.postgresql.Driver");
				
			conn = DriverManager.getConnection("jdbc:postgresql://" +
					"localhost:5432/CSE135", "postgres", "$$JBlue");
			
	%>
	
	<!-- //////////////////////Initialization Code //////////////////// -->
	
	<%		
			//Get information for the current shopping cart
			Integer userId = (Integer) session.getAttribute("userid");
			
			PreparedStatement getStmt = conn.prepareStatement("SELECT " +
					"product.name, product.price, product.sku, " +
					"cart.quantity, cart.product " +
					"from cart " + 
					"join product on product.id = cart.product " +
					"where cart.userid =?");
			getStmt.setInt(1, userId);
			ResultSet cartItem = getStmt.executeQuery();
	%>
	
	</br>
	<form method="post">
		<input type="text" name="input_creditCard" /> 
		<input type="submit" name="action" value="Purchase" />
	</form>
	<h4>Beware of identity theft and credit card fraud</h4>
	
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
			Integer productId = cartItem.getInt("product");
		%>
		<tr>
			<td><input name="itemName" value="<%= itemName %>" /></td>
			<td><input name="itemSKU" value="<%= itemSKU %>" /></td>
			<td><input name="itemPrice" value="<%= itemPrice %>" /></td>
			<td><input name="itemQuantity" value="<%= itemQuantity %>" /></td>		
			<input type="hidden" name="productId" value="<%= productId %>" />	
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