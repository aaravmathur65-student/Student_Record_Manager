package Main;

import java.io.File;
import java.sql.Connection;
import java.sql.DriverManager;

public class JDBC {

	public static Connection getConnection() {

		Connection con = null;

		try {
			Class.forName("org.h2.Driver");

			File folder = new File("data");
			if (!folder.exists()) {
				folder.mkdirs();
			}

			String url = "jdbc:h2:./data/institutionDB";
			String user = "sa";
			String pass = "";

			con = DriverManager.getConnection(url, user, pass);
			
		} catch (Exception e) {
			e.printStackTrace();
		}

		return con;
	}
}