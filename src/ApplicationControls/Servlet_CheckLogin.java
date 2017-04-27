package ApplicationControls;
import java.io.*;
import java.sql.*;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.ws.rs.core.Response;

public class Servlet_CheckLogin extends HttpServlet  {

	public void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException{
		
		res.setContentType("text/html");
		
		String user = req.getParameter("tb_username");
		System.out.println(user);
		
		Connection conn;
		try {
			conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/CSE135","postgres", "$$JBlue");
			
			PreparedStatement verifyStmt = conn.prepareStatement("SELECT name FROM user WHERE name =?");
			
			verifyStmt.setString(1, user);
			
			ResultSet result = verifyStmt.executeQuery();
			
			if (result.next()) {
				
				res.sendRedirect("Home.html");
			}
			else {
				res.sendRedirect("Index.jsp");
			}
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
		
		
		
	}
}
