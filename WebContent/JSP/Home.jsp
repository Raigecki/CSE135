<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Home</title>
</head>
<body>

	<%String user = (String) session.getAttribute("user"); 
	  if (user == null) {
	  	session.setAttribute("user", user);
	  }
	  
	  Integer role = (Integer) session.getAttribute("role");
	  if (role == null) {
	  	session.setAttribute("role", role);
	  }
	%>

	<h2>Welcome <%= user%></h2> 

	<div>
	
		<% if (role == 0) { %>
			<a href="Categories.jsp">Categories</a> </br>
			<a href="Products.jsp">Products</a> </br>
			
		<% } else if (role == 1){ %>		
			<a href="Browse.jsp">Browse Products</a> </br>
			<a href="Cart.jsp">Shopping Cart</a> </br>
			<a href="Buy.jsp">Buy Shopping Cart</a>

		<% } %>
	</div>

</body>
</html>