<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Sign Up</title>
</head>
<body>

<!------------------------------ Signup ----------------------------------->
		<div>
	
			<form method="post" action="./Servlet_SignUp">
				Username: </br> <input type="text" name="input_userName"> </br>
				Age: </br> <input type="text" name="input_age"> </br>
				State: </br>
				<select id ="select_state" name="select_state">
	  				<option value="1">Hawaii</option>
	  				<option value="2">California</option>
	  			</select> </br>
				Role: </br>
				<select id ="select_role" name="select_role">
	  				<option value="0">Owner</option>
	  				<option value="1">Customer</option>
	  			</select> </br>
  			
  				<input type="submit" id="btn_signUp_submit" value="Sign Up" />
  			</form>	
			
		</div>
	</div>
	
	<!--------------------------------Messages------------------------------------>
	<div>
	
		<h4 id="text_errorMsg"></h4>
	</div>

</body>
</html>