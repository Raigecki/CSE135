/**
 * 
 */

function createUser() {
	
	//obtain data from HTML
	var username = document.getElementById("input_userName").value;
	var age = document.getElementById("input_age").value;
	var stateField = document.getElementById("select_state");
	var state = stateField.options[stateField.selectedIndex].value;	
	var roleField = document.getElementById("select_role");
	var role = roleField.options[roleField.selectedIndex].value;
	
	//data to be sent to controller
	var info = [username, age, state, role];
	
	var sReq = new XMLHttpRequest();
	sReq.open('POST', 'Controller_SignUp.java');
	s.Req.send(info);

    sReq.onreadystatechange = function() {
        if (req.readyState == XMLHttpRequest.DONE ) {
           if (req.status == 200) {
               document.getElementById("text_errorMsg").innerText = xmlhttp.responseText;
           }
           else if (req.status == 400) {
              alert('There was an error 400');
           }
           else {
               alert('something else other than 200 was returned');
           }
        }
    };

};