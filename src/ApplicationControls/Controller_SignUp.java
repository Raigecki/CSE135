package ApplicationControls;
import java.sql.*;

public class Controller_SignUp {

	public Boolean CheckUser(String userName) {
		
		return false;
	}

	
	public boolean createUser(String userInfo[]) throws SQLException, ClassNotFoundException {
		Class.forName("org.postgresql.Driver");
		
		System.out.println(userInfo[0]);
		
		// open a connection to the database
		//Connection conn = DriverManager.getConnection("jdbc:postgresql://localhost/jdbc-examples?" + "user=cse135&password=sheevspin");
		Connection conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/CSE135","postgres", "$$JBlue");
		
		String name = userInfo[0];
		int age = Integer.parseInt(userInfo[1]);
		int state = Integer.parseInt(userInfo[2]);
		int role = Integer.parseInt(userInfo[3]);
		
		PreparedStatement checkUserStmt = conn.prepareStatement("SELECT name FROM user WHERE name = ?");
		
		checkUserStmt.setString(1, name);
		ResultSet rset = checkUserStmt.executeQuery();
		if (rset.next()) {
			return false;
		}
		else {
			PreparedStatement createUserStmt = conn.prepareStatement("INSERT INTO user (name, age, state, role) " +
																	 "VALUES (?, ?, ?, ?)");
			createUserStmt.setString(1, name);
			createUserStmt.setLong(2, age);
			createUserStmt.setLong(3, state);
			createUserStmt.setLong(4, role);
			int rmsg = checkUserStmt.executeUpdate();
			return true;
			
		}
	}
}
