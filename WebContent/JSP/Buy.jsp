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
					"cart.quantity, cart.product, cart.id " +
					"from cart " + 
					"join product on product.id = cart.product " +
					"where cart.userid =?");
			getStmt.setInt(1, userId);
			ResultSet cartItem = getStmt.executeQuery();
			
	%>
	
	<!-- //////////////////////Confirmation Code ////////////////////// -->
	<% 
			String action = request.getParameter("action");
			
			if (action != null && action.equals("Purchase")) {
				
				System.out.println("Got into buy");
				
				PreparedStatement reStmt = conn.prepareStatement("SELECT " +
						"id from cart WHERE userid =?");
				reStmt.setInt(1, userId);
				ResultSet idCart = reStmt.executeQuery();
				
				if (idCart.next()) {
					Integer cartId = idCart.getInt("id");
					
					System.out.println(cartId);
					session.setAttribute("cartId", cartId);
					response.sendRedirect("Confirmation.jsp");
				}			
			}
			reStmt.close();
			idCart.close();
	%>
	
	</br>
	
	<h4>Beware of identity theft and credit card fraud</h4>
	
	<form method="post">
		Credit Card Number: <input type="text" name="input_creditCard" /> 
		<input type="submit" name="action" value="Purchase" />
	</form>
	
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
	
			getStmt.close();
			cartItem.close();
			conn.close();
	
		} 
		catch(Exception e) {
			e.printStackTrace();
		}
	%>

</body>
</html>