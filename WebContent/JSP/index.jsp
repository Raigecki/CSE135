<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link href="bootstrap/css/bootstrap.min.css" rel="stylesheet"
	type="text/css" />
<script type="text/javascript" src="bootstrap/js/bootstrap.min.js"></script>
<script src="Javascripts/main.js"></script>
<title>CSE135Shopping</title>
<h2>Login</h2>
</head>
<body>

	<%@ page import="java.sql.*" %>
	
	<div class="container_outer">

		<div class="container_inner">

			<form method="get">

				<input type="hidden" name="action" value="check">
				Username: <input type="text" name="tb_username">
				
				</br> </br>
				<input type="submit" id="btn_login_submit" value="Sign In" />
			</form>
		</div>
		
		
		<!-- //////////////////////////////////////Connection Code/////////////////////////////////////////// -->
		
		<%
		
		String action = request.getParameter("action");
		if (action != null && action.equals("check")) {
			Connection conn;
			try {
				
				String user = request.getParameter("tb_username");
				System.out.println(user);
				
				Class.forName("org.postgresql.Driver");
				
				conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/CSE135",
						"postgres", "$$JBlue");
			
		%>
			
		<!-- ////////////////////////////////////////Statement Code//////////////////////////////////////// -->
		<% 
			PreparedStatement verifyStmt = conn.prepareStatement("SELECT id, name, role FROM usert WHERE name =?");
			
			verifyStmt.setString(1, user);
			
			ResultSet result = verifyStmt.executeQuery();			
			
			if (result.next()) {
				
				int role = result.getInt("role");
				int userid = result.getInt("id");
				String name = result.getString("name");
				System.out.println("role: " + role);
				System.out.println("name: " + name);
				System.out.println("userid: " + userid);
				
				session.setAttribute("role", role);
				session.setAttribute("user", name);
				session.setAttribute("userid", userid);
				response.sendRedirect("Home.jsp");
			}
			else{ 
		%>
			
			<h4 id="text_errorMsg">User name not found</h4>
						
		<% 
				response.sendRedirect("index.jsp");
			}
		%>
		
	<!-- ///////////////////////////////////Close connection code/////////////////////////////////////// -->
		<%
			result.close();
			verifyStmt.close();
			conn.close();
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		%>

		
	</div>
</body>
</html>