package ApplicationControls;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class Servlet_LoginCheck
 */
@WebServlet("/Servlet_LoginCheck")
public class Servlet_LoginCheck extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Servlet_LoginCheck() {
        super();
        // TODO Auto-generated constructor stub
        
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		response.setContentType("text/html");
		
		String user = request.getParameter("tb_username");
		System.out.println(user);
		
		Connection conn;
		try {
			
			Class.forName("org.postgresql.Driver");
			
			conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/CSE135","postgres", "$$JBlue");
			
			PreparedStatement verifyStmt = conn.prepareStatement("SELECT name, role FROM foooo WHERE name =?");
			
			verifyStmt.setString(1, user);
			
			ResultSet result = verifyStmt.executeQuery();
			
			boolean isNull = result.next();
			
			
			if (isNull == true) {
				
				int role = result.getInt("ROLE");
				String name = result.getString("name");
				((ServletRequest) response).setAttribute("role", role);
				((ServletRequest) response).setAttribute("user", name);
				response.sendRedirect("Home.html");
			}
			else if (isNull == false) {
				response.sendRedirect("Index.jsp");
			}
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
