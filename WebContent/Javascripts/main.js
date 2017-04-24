/**
 * 
 */

function() createUser {
	
	var username = document.getElementById("input_userName").value;
	var age = document.getElementById("input_age").value;
	var stateField = document.getElementById("select_state");
	var state = stateField.options[stateField.selectedIndex].value;
	
	var roleField = document.getElementById("select_role");
	var role = roleField.options[roleField.selectedIndex].value;
	
	var info = [username, age, state, role];
	
	var req = new XMLHttpRequest();

    req.onreadystatechange = function() {
        if (req.readyState == XMLHttpRequest.DONE ) {
           if (req.status == 200) {
               document.getElementById("myDiv").innerHTML = xmlhttp.responseText;
           }
           else if (req.status == 400) {
              alert('There was an error 400');
           }
           else {
               alert('something else other than 200 was returned');
           }
        }
    };

    xmlhttp.open("POST", "ajax_info.txt", true);
    xmlhttp.send();
}