<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link href="bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="bootstrap/js/bootstrap.min.js"></script>
<script src="Javascripts/main.js"></script>
<title>Sign Up</title>
</head>
<body>
	
	<div class="container_outer">
	
		<div class="container_inner">
		
			<h3>Username</h3>
			<input type="text" id="tb_username">	
		</div>
		
		<div class="container_inner">
		
			<button type="button" class="btn" id="btn_submit">
				Submit
			</button>
		</div>
		
		
		<!------------------------------ Signup ----------------------------------->
		<div>
		
			Username: <input type="text" id="input_userName"> </br>
			Age: <input type="text" id="input_age"> </br>
			State: 
			<select id = select_state>
  				<option value="1">Hawaii</option>
  				<option value="2">California</option>
  			</select> </br>
			<select id = select_role>
  				<option value="0">Owner</option>
  				<option value="1">Customer</option>
  			</select> </br>
			<button type="button" class="btn" id="btn_signUp">Submit</button>
			
		</div>
	</div>

</body>
</html>