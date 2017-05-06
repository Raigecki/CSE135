<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Confirmation</title>
</head>
<body>

	<a href="Home.jsp">Home</a> </br>
	<a href="Browse.jsp">Browse Products</a> </br>
	
	
	<h2>Thank you for your purchase</h2>

	<%@ page import="java.sql.*" %>

	<!--////////////////////// Open Connection Code /////////////////// -->
	
	<% 
		Connection conn;
		
		try {
			
			conn = DriverManager.getConnection("jdbc:postgresql://" +
					"localhost:5432/CSE135", "postgres", "$$JBlue");
			
	%>
	
	<!-- /////////////////////// Delete Code ////////////////////////// -->
	
	<% 		
			Integer cartId = (Integer) session.getAttribute("cartId");
			
			conn.setAutoCommit(false);
			PreparedStatement delStmt = conn.prepareStatement("DELETE FROM " +
					" cart WHERE id =?");
			delStmt.setInt(1, cartId);
			int res = delStmt.executeUpdate();
	
	
	%>
	<%
			delStmt.close();
			conn.close();
			//result.close();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	%>

</body>
</html>