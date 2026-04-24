package Main;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

@WebListener
public class DBinit implements ServletContextListener {

	@Override
	public void contextInitialized(ServletContextEvent sce) {
		try (Connection con = JDBC.getConnection(); Statement st = con.createStatement()) {

			// COURSE
			st.execute("CREATE TABLE IF NOT EXISTS course (" + "course_id VARCHAR(10) PRIMARY KEY,"
					+ "course_name VARCHAR(100)," + "course_duration VARCHAR(20))");

			// STUDENT
			st.execute("CREATE TABLE IF NOT EXISTS student (" + "roll_no INT PRIMARY KEY," + "name VARCHAR(50),"
					+ "email VARCHAR(50)," + "course_id VARCHAR(10),"
					+ "FOREIGN KEY (course_id) REFERENCES course(course_id) ON DELETE CASCADE)");

			st.execute("CREATE TABLE IF NOT EXISTS attendance (" + "roll_no INT," + "date DATE," + "present BOOLEAN,"
					+ "PRIMARY KEY (roll_no, date),"
					+ "FOREIGN KEY (roll_no) REFERENCES student(roll_no) ON DELETE CASCADE)");
			st.execute("CREATE TABLE IF NOT EXISTS results (" + "roll_no INT PRIMARY KEY, " + "total INT, "
					+ "result VARCHAR(10), " + "FOREIGN KEY (roll_no) REFERENCES student(roll_no) ON DELETE CASCADE)");
			System.out.println("All tables created successfully");
			// after creating course table

			// COURSE
			System.out.println("---- COURSE TABLE ----");
			ResultSet rs1 = st.executeQuery("SELECT * FROM course");
			while (rs1.next()) {
				System.out.println(rs1.getString(1) + " | " + rs1.getString(2) + " | " + rs1.getString(3));
			}
			rs1.close();

			// STUDENT
			System.out.println("\n---- STUDENT TABLE ----");
			ResultSet rs2 = st.executeQuery("SELECT * FROM student");
			while (rs2.next()) {
				System.out.println(
						rs2.getInt(1) + " | " + rs2.getString(2) + " | " + rs2.getString(3) + " | " + rs2.getString(4));
			}
			rs2.close();

			// ATTENDANCE
			System.out.println("\n---- ATTENDANCE TABLE ----");
			ResultSet rs3 = st.executeQuery("SELECT * FROM attendance");
			while (rs3.next()) {
				System.out.println(rs3.getInt(1) + " | " + rs3.getDate(2) + " | " + rs3.getBoolean(3));
			}
			rs3.close();

			// RESULTS
			System.out.println("\n---- RESULTS TABLE ----");
			ResultSet rs4 = st.executeQuery("SELECT * FROM results");
			while (rs4.next()) {
				System.out.println(rs4.getInt(1) + " | " + rs4.getInt(2) + " | " + rs4.getString(3));
			}
			rs4.close();

			st.close();

		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}