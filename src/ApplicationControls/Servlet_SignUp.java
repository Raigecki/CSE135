package ApplicationControls;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class Servlet_SignUp
 */
@WebServlet("/Servlet_SignUp")
public class Servlet_SignUp extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public Servlet_SignUp() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		response.setContentType("text/html");

		//retrieve the user's sign up information
		String user = request.getParameter("input_userName");
		int age = Integer.parseInt(request.getParameter("input_age"));
		int state = Integer.parseInt(request.getParameter("select_state"));
		int role = Integer.parseInt(request.getParameter("select_role"));
		
		System.out.println(user);
		System.out.println(age);
		System.out.println(state);
		System.out.println(role);

		Connection conn;
		try {

			Class.forName("org.postgresql.Driver");

			conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/CSE135", "postgres", "$$JBlue");

			PreparedStatement verifyStmt = conn.prepareStatement("SELECT name FROM usert WHERE name =?");

			verifyStmt.setString(1, user);

			ResultSet result = verifyStmt.executeQuery();
			boolean username = result.next();
			if (username == false) System.out.println("Name is available");
			else System.out.println("Name already taken");
			
			/*
			 * 0 = null age
			 * 1 = null user name
			 * 2 = user name taken
			 */

			//Check if the user did not put in an age
			if (age == 0) {

				((ServletRequest) response).setAttribute("failType", 0);
				response.sendRedirect("Fail_SignUp.jsp");
			}
			
			//Check if the user did not put in a user name
			else if (user == "") {
				((ServletRequest) response).setAttribute("failType", 1);
				response.sendRedirect("Fail_SignUp.jsp");
			}
				
			//Check if the user name is already taken
			else if (username == true) {

				((ServletRequest) response).setAttribute("failType", 2);
				response.sendRedirect("Fail_SignUp.jsp");
			} 
			
			//Case when sign up is successful
			else if (username == false) {
				
				PreparedStatement postStmt = conn.prepareStatement("INSERT INTO usert (name, age, state, role)"
						+ "VALUES (?, ?, ?, ?)");
				
				postStmt.setString(1, user);
				postStmt.setInt(2,age);
				postStmt.setInt(3, state);
				postStmt.setInt(4, role);
				postStmt.executeQuery();
				response.sendRedirect("Success_SignUp.jsp");
			}

		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		doGet(request, response);
	}

}
