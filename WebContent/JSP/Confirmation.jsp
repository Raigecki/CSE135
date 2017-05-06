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
			Integer userid = (Integer) session.getAttribute("userid");
			conn.setAutoCommit(false);
			PreparedStatement delStmt = conn.prepareStatement("DELETE FROM" +
					" cart WHERE userid =?");
			delStmt.setInt(1, userid);
			int res = delStmt.executeUpdate();
			conn.commit();
			conn.setAutoCommit(true);
			
			session.setAttribute("productName", null);
			session.setAttribute("productSKU", null);
			session.setAttribute("productPrice", null);
			session.setAttribute("productId", null);
	
	
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