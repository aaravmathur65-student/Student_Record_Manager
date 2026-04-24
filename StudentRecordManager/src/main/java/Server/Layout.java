package Server;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Main.JDBC;

@WebServlet("/layout")
public class Layout extends HttpServlet {
	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String page = getPage(request);
		setPageAttributes(page, request);

		try (Connection con = JDBC.getConnection()) {
			loadPageData(page, request, con);
		} catch (Exception e) {
			throw new ServletException(e);
		}

		request.getRequestDispatcher("/layout.jsp").forward(request, response);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String page = request.getParameter("page");
		String action = request.getParameter("action");

		try (Connection con = JDBC.getConnection()) {
			String message = handleAction(page, action, request, con);

			if (message != null) {
				request.setAttribute("message", message);
				request.setAttribute("actionType", action);
				setPageAttributes(page, request);
				loadPageData(page, request, con);
				request.getRequestDispatcher("/layout.jsp").forward(request, response);
				return;
			}
			if ("logout".equals(action)) {
			    request.getSession().invalidate();
			    response.sendRedirect(request.getContextPath() + "/login");
			    return;
			}
		} catch (Exception e) {
			throw new ServletException(e);
		}
		response.sendRedirect("layout?page=" + page);

	}

	private String getPage(HttpServletRequest request) {
		String page = request.getParameter("page");
		return (page == null || page.trim().isEmpty()) ? "home" : page;
	}

	private String handleAction(String page, String action, HttpServletRequest request, Connection con)
			throws Exception {

		if ("student".equals(page)) {
			if ("add".equals(action))
				return addStudent(request, con);
			if ("delete".equals(action))
				return deleteStudent(request, con);
		}

		if ("course".equals(page)) {
			if ("add".equals(action))
				return addCourse(request, con);
			if ("delete".equals(action))
				return deleteCourse(request, con);
		}

		if ("attendance".equals(page)) {
			if ("save".equals(action))
				return saveAttendance(request, con);
			if ("delete".equals(action))
				return deleteAttendance(request, con);
		}
		if ("marks".equals(page)) {
			if ("save".equals(action))
				return saveMarks(request, con);
		}

		return null;
	}

	private void loadPageData(String page, HttpServletRequest request, Connection con) throws Exception {
		loadCourseOptions(request, con);

		switch (page) {
		case "student":
			loadStudentData(request, con);
			break;
		case "course":
			loadCourseData(request, con);
			break;
		case "attendance":
			loadAttendanceData(request, con);
			loadAttendanceForEntry(request, con);
			break;
		case "marks":
			loadMarksData(request, con);
			loadMarksForEntry(request, con);
			break;
		}
	}

	private void setPageAttributes(String page, HttpServletRequest request) {

		String contentPage = "/pages/homepage.jsp";
		String cssPage = "/pages/homepage.css";

		switch (page) {
		case "student":
			contentPage = "/pages/StudentManagement.jsp";
			cssPage = "/pages/StudentManagement.css";
			break;
		case "course":
			contentPage = "/pages/CourseManagement.jsp";
			cssPage = "/pages/CourseManagement.css";
			break;
		case "attendance":
			contentPage = "/pages/Attendance_manager.jsp";
			cssPage = "/pages/Attendance_manager.css";
			break;
		case "marks":
			contentPage = "/pages/Results.jsp";
			cssPage = "/pages/Results.css";
			break;
		}

		request.setAttribute("contentPage", contentPage);
		request.setAttribute("cssPage", cssPage);
	}

	private void loadCourseOptions(HttpServletRequest request, Connection con) throws Exception {

		List<String[]> courseOptions = new ArrayList<>();

		String sql = "SELECT course_id FROM course";

		try (PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

			while (rs.next()) {
				courseOptions.add(new String[] { rs.getString("course_id") });
			}
		}

		request.setAttribute("courseOptions", courseOptions);
	}

	private void loadStudentData(HttpServletRequest request, Connection con) throws Exception {

		List<String[]> studentList = new ArrayList<>();

		String sql = "SELECT s.roll_no, s.name, s.email, c.course_name "
				+ "FROM student s LEFT JOIN course c ON s.course_id = c.course_id";

		try (PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

			while (rs.next()) {
				studentList.add(new String[] { rs.getString("roll_no"), rs.getString("name"), rs.getString("email"),
						rs.getString("course_name") });
			}
		}

		request.setAttribute("studentList", studentList);
	}

	private void loadCourseData(HttpServletRequest request, Connection con) throws Exception {

		List<String[]> courseList = new ArrayList<>();

		String sql = "SELECT course_id, course_name, course_duration FROM course";

		try (PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

			while (rs.next()) {
				courseList.add(new String[] { rs.getString("course_id"), rs.getString("course_name"),
						rs.getString("course_duration") });
			}
		}

		request.setAttribute("courseList", courseList);
	}

	private void loadAttendanceData(HttpServletRequest request, Connection con) throws Exception {
		List<String[]> attendanceList = new ArrayList<>();
		String course = request.getParameter("course");
		String sql = "SELECT s.roll_no, s.name, COUNT(a.date) AS total, "
				+ "SUM(CASE WHEN a.present THEN 1 ELSE 0 END) AS present " + "FROM student s "
				+ "LEFT JOIN attendance a ON s.roll_no = a.roll_no ";
		if (course != null && !course.isEmpty()) {
			sql += "WHERE TRIM(UPPER(s.course_id)) = TRIM(UPPER(?)) ";
		}
		sql += "GROUP BY s.roll_no, s.name";
		try (PreparedStatement ps = con.prepareStatement(sql)) {
			if (course != null && !course.isEmpty()) {
				ps.setString(1, course);
			}
			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					int total = rs.getInt("total");
					int present = rs.getInt("present");
					int percentage = (total == 0) ? 0 : (present * 100 / total);
					attendanceList.add(new String[] { rs.getString("roll_no"), rs.getString("name"),
							present + "/" + total, percentage + "%" });
				}
			}
		}
		request.setAttribute("attendanceList", attendanceList);
	}

	private void loadAttendanceForEntry(HttpServletRequest request, Connection con) throws Exception {
		List<String[]> studentList = new ArrayList<>();
		String course = request.getParameter("course");
		String date = request.getParameter("date");
		String sql = "SELECT s.roll_no, s.name, a.present " + "FROM student s "
				+ "LEFT JOIN attendance a ON s.roll_no = a.roll_no AND a.date = ? ";
		if (course != null && !course.isEmpty()) {
			sql += "WHERE TRIM(UPPER(s.course_id)) = TRIM(UPPER(?)) ";
		}
		try (PreparedStatement ps = con.prepareStatement(sql)) {
			int index = 1;
			ps.setString(index++, date);
			if (course != null && !course.isEmpty()) {
				ps.setString(index++, course);
			}
			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					String rollNo = rs.getString("roll_no");
					String name = rs.getString("name");
					boolean present = rs.getBoolean("present");
					studentList.add(new String[] { rollNo, name, String.valueOf(present) });
				}
			}
		}
		request.setAttribute("studentEntryList", studentList);
	}

	private void loadMarksData(HttpServletRequest request, Connection con) throws Exception {

		List<String[]> resultList = new ArrayList<>();

		String course = request.getParameter("course");

		String sql = "SELECT s.roll_no, s.name, COALESCE(r.total, 0) AS total, COALESCE(r.result, 'FAIL') AS result "
				+ "FROM student s LEFT JOIN results r ON s.roll_no = r.roll_no ";

		if (course != null && !course.isEmpty()) {
			sql += "WHERE TRIM(UPPER(s.course_id)) = TRIM(UPPER(?)) ";
		}

		try (PreparedStatement ps = con.prepareStatement(sql)) {

			if (course != null && !course.isEmpty()) {
				ps.setString(1, course);
			}

			try (ResultSet rs = ps.executeQuery()) {

				while (rs.next()) {
					resultList.add(new String[] { rs.getString("roll_no"), rs.getString("name"), rs.getString("total"), // ✅
																														// FIXED
							rs.getString("result") });
				}
			}
		}

		request.setAttribute("resultList", resultList);
	}

	private void loadMarksForEntry(HttpServletRequest request, Connection con) throws Exception {

		List<String[]> studentList = new ArrayList<>();

		String course = request.getParameter("course");

		String sql = "SELECT s.roll_no, s.name, COALESCE(r.total, 0) AS total "
				+ "FROM student s LEFT JOIN results r ON s.roll_no = r.roll_no ";

		if (course != null && !course.isEmpty()) {
			sql += "WHERE TRIM(UPPER(s.course_id)) = TRIM(UPPER(?)) ";
		}

		try (PreparedStatement ps = con.prepareStatement(sql)) {

			if (course != null && !course.isEmpty()) {
				ps.setString(1, course);
			}

			try (ResultSet rs = ps.executeQuery()) {

				while (rs.next()) {

					String rollNo = rs.getString("roll_no");
					String name = rs.getString("name");
					String total = rs.getString("total");

					studentList.add(new String[] { rollNo, name, total == null ? "" : total // show empty if not set
					});
				}
			}
		}

		request.setAttribute("marksEntryList", studentList);
	}

	private String saveMarks(HttpServletRequest request, Connection con) throws Exception {

		String course = request.getParameter("course");

		if (course == null || course.trim().isEmpty())
			course = "";

		String sql1 = "SELECT roll_no FROM student";

		if (!course.isEmpty()) {
			sql1 += " WHERE TRIM(UPPER(course_id)) = TRIM(UPPER(?))";
		}

		try (PreparedStatement ps1 = con.prepareStatement(sql1)) {

			if (!course.isEmpty()) {
				ps1.setString(1, course);
			}

			try (ResultSet rs = ps1.executeQuery()) {

				while (rs.next()) {

					int rollNo = rs.getInt("roll_no");

					String param = "marks_" + rollNo;
					String marksStr = request.getParameter(param);

					if (marksStr == null || marksStr.trim().isEmpty())
						continue;

					int newMarks = Integer.parseInt(marksStr.trim());

					// STEP 1: get old total
					int oldTotal = 0;

					String getSql = "SELECT total FROM results WHERE roll_no = ?";
					try (PreparedStatement psGet = con.prepareStatement(getSql)) {
						psGet.setInt(1, rollNo);
						ResultSet rsGet = psGet.executeQuery();
						if (rsGet.next()) {
							oldTotal = rsGet.getInt("total");
						}
					}

					// STEP 2: add marks
					int total = oldTotal + newMarks;

					String result = (total >= 40) ? "PASS" : "FAIL";

					// STEP 3: insert or update
					String upsert = "MERGE INTO results (roll_no, total, result) KEY (roll_no) VALUES (?, ?, ?)";

					try (PreparedStatement ps2 = con.prepareStatement(upsert)) {
						ps2.setInt(1, rollNo);
						ps2.setInt(2, total);
						ps2.setString(3, result);
						ps2.executeUpdate();
					}
				}
			}
		}

		return null;
	}



	private String addStudent(HttpServletRequest request, Connection con) throws Exception {

		String rollNo = request.getParameter("roll_no");
		String name = request.getParameter("name");
		String email = request.getParameter("email");
		String courseId = request.getParameter("course_id");

		String checkSql = "SELECT roll_no FROM student WHERE roll_no = ?";

		try (PreparedStatement checkPs = con.prepareStatement(checkSql)) {
			checkPs.setString(1, rollNo);
			ResultSet rs = checkPs.executeQuery();

			if (rs.next())
				return "Roll number already<br>exists!";
		}

		String sql = "INSERT INTO student (name, roll_no, email, course_id) VALUES (?, ?, ?, ?)";

		try (PreparedStatement ps = con.prepareStatement(sql)) {
			ps.setString(1, name);
			ps.setString(2, rollNo);
			ps.setString(3, email);
			ps.setString(4, courseId);
			ps.executeUpdate();
		}

		return null;
	}

	private String deleteStudent(HttpServletRequest request, Connection con) throws Exception {

		String rollNo = request.getParameter("roll_no");

		String sql = "DELETE FROM student WHERE roll_no = ?";

		try (PreparedStatement ps = con.prepareStatement(sql)) {
			ps.setString(1, rollNo);
			int rows = ps.executeUpdate();

			if (rows == 0)
				return "Roll number not found!";
		}

		return null;
	}

	private String addCourse(HttpServletRequest request, Connection con) throws Exception {

		String courseName = request.getParameter("course_name");
		String courseId = request.getParameter("course_id");
		String courseDuration = request.getParameter("course_duration");

		String checkSql = "SELECT course_id FROM course WHERE course_id = ?";

		try (PreparedStatement checkPs = con.prepareStatement(checkSql)) {
			checkPs.setString(1, courseId);
			ResultSet rs = checkPs.executeQuery();

			if (rs.next())
				return "Course ID already exists!";
		}

		String sql = "INSERT INTO course (course_id, course_name, course_duration) VALUES (?, ?, ?)";

		try (PreparedStatement ps = con.prepareStatement(sql)) {
			ps.setString(1, courseId);
			ps.setString(2, courseName);
			ps.setString(3, courseDuration);
			ps.executeUpdate();
		}

		return null;
	}

	private String deleteCourse(HttpServletRequest request, Connection con) throws Exception {

		String courseId = request.getParameter("course_id");

		String sql = "DELETE FROM course WHERE course_id = ?";

		try (PreparedStatement ps = con.prepareStatement(sql)) {
			ps.setString(1, courseId);
			int rows = ps.executeUpdate();

			if (rows == 0)
				return "Course ID not found!";
		}

		return null;
	}

	private String saveAttendance(HttpServletRequest request, Connection con) throws Exception {

		String date = request.getParameter("date");
		String[] presentIds = request.getParameterValues("presentIds");

		if (date == null || date.isEmpty())
			return "Date required!";

		String sql1 = "SELECT roll_no FROM student";

		try (PreparedStatement ps1 = con.prepareStatement(sql1); ResultSet rs = ps1.executeQuery()) {

			while (rs.next()) {

				String rollNo = rs.getString("roll_no");
				boolean isPresent = false;

				if (presentIds != null) {
					for (String id : presentIds) {
						if (id.equals(rollNo)) {
							isPresent = true;
							break;
						}
					}
				}

				String sql2 = "INSERT INTO attendance (roll_no, date, present) VALUES (?, ?, ?)";

				try {
					PreparedStatement ps2 = con.prepareStatement(sql2);
					ps2.setString(1, rollNo);
					ps2.setString(2, date);
					ps2.setBoolean(3, isPresent);
					ps2.executeUpdate();
				} catch (Exception e) {

					String updateSql = "UPDATE attendance SET present=? WHERE roll_no=? AND date=?";
					PreparedStatement ps3 = con.prepareStatement(updateSql);
					ps3.setBoolean(1, isPresent);
					ps3.setString(2, rollNo);
					ps3.setString(3, date);
					ps3.executeUpdate();
				}
			}
		}

		return null;
	}

	private String deleteAttendance(HttpServletRequest request, Connection con) throws Exception {

		String rollNo = request.getParameter("roll_no");
		String date = request.getParameter("date");

		String sql = "DELETE FROM attendance WHERE roll_no=? AND date=?";

		try (PreparedStatement ps = con.prepareStatement(sql)) {
			ps.setString(1, rollNo);
			ps.setString(2, date);

			int rows = ps.executeUpdate();

			if (rows == 0)
				return "Not found!";
		}

		return null;
	}
}