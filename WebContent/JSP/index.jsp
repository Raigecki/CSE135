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

	<div class="container_outer">

		<div class="container_inner">

			<form method="get" action="../Java Resources/src/ApplicationControls/Servlet_CheckLogin">

				Username: <input type="text" name="tb_username">
				
				</br> </br>
				<input type="submit" id="btn_login_submit" value="Sign In" />
			</form>
		</div>



		<h4 id="text_errorMsg"></h4>
</body>
</html>