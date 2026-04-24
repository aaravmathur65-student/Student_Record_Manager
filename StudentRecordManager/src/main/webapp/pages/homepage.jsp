<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>Home Page</title>
</head>
<body>
	<div class="profile">
		<table>
			<tr>
				<th>Name:</th>
				<td>Aarav</td>
			</tr>
			<tr>
				<th>ID:</th>
				<td>ADM001</td>
			</tr>
			<tr>
				<th>Username:</th>
				<td>admin_user</td>
			</tr>
			<tr>
				<th>Email:</th>
				<td>admin@example.com</td>
			</tr>
			<tr>
				<th>Phone:</th>
				<td>9876543210</td>
			</tr>
		</table>
	</div>
	<div class="dashboard_layout">
		<div class="dashboard">
			<div id="students">
				<div>
					<p>Total Stundets:</p>
					<p>120</p>
				</div>
			</div>
			<div id="courses">
				<div>
					<p>Total Courses:</p>
					<p>8</p>
				</div>
			</div>
			<div id="attendance_today">
				<div>
					<p>Attendance Today:</p>
					<p>10/10</p>
				</div>
			</div>
			<div id="avg_marks">
				<div>
					<p>Marks</p>
					<p>10/10</p>
				</div>
			</div>
			<a id="btn1" class="dashboard-btn"
				href="${pageContext.request.contextPath}/layout?page=student">Student
				<br />management
			</a> <a id="btn2" class="dashboard-btn"
				href="${pageContext.request.contextPath}/layout?page=course">Courses
				<br />management
			</a>
		</div>
	</div>
</body>
</html>
