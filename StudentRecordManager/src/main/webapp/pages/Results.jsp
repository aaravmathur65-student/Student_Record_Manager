
<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<%@ page import="java.util.List"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Result</title>
</head>
<body>


	<%
	String mode = request.getParameter("mode");
	String selectedCourse = request.getParameter("course");
	String selectedExam = request.getParameter("exam");
	%>

	<h1 id="head">RESULT MANAGEMENT</h1>

	<!-- ================= BOX 1 ================= -->
	<div class="box1">
		<form method="get" action="layout">
			<input type="hidden" name="page" value="marks">

			<div class="selector">
				<div>
					<label>COURSE: </label> <select name="course">
						<option value="">ALL</option>
						<%
						List<String[]> courses = (List<String[]>) request.getAttribute("courseOptions");
						if (courses != null) {
							for (String[] courseRow : courses) {
						%>
						<option value="<%=courseRow[0]%>"
							<%=courseRow[0].equals(selectedCourse) ? "selected" : ""%>>
							<%=courseRow[0]%>
						</option>
						<%
						}
						}
						%>
					</select>
				</div>

				<div>
					<button type="submit">VIEW RESULT</button>
				</div>
			</div>
		</form>

		<!-- RESULT TABLE -->
		<div class="table_container1">
			<div class="table_scroll">
				<table>
					<thead>
						<tr>
							<th>Roll Number</th>
							<th>Name</th>
							<th>Marks</th>
							<th>Result</th>
						</tr>
					</thead>
					<tbody>
						<%
						List<String[]> list = (List<String[]>) request.getAttribute("resultList");
						if (list != null) {
							for (String[] row : list) {
						%>
						<tr>
							<td><%=row[0]%></td>
							<td><%=row[1]%></td>
							<td><%=row[2]%></td>
							<td><%=row[3]%></td>
						</tr>
						<%
						}
						}
						%>
					</tbody>
				</table>
			</div>
		</div>

		<div class="manage_btn">
			<a class="add_btn" href="">Add</a>
		</div>
	</div>

	<!-- ================= BOX 2 ================= -->
	<form id="marksForm" action="layout" method="post">
		<input type="hidden" name="page" value="marks"> <input
			type="hidden" name="action" value="save">

		<div class="box2">
			<div class="selector">
				<div>
					<label>COURSE: </label> <select name="course" id="course_picker">
						<option value="">ALL</option>
						<%
						if (courses != null) {
							for (String[] courseRow : courses) {
						%>
						<option value="<%=courseRow[0]%>"
							<%=courseRow[0].equals(selectedCourse) ? "selected" : ""%>>
							<%=courseRow[0]%>
						</option>
						<%
						}
						}
						%>
					</select>
				</div>

				<div>
					<label>Exam: </label> <select name="exam" id="exam_picker">
						<option value="MIDTERM"
							<%="MIDTERM".equals(selectedExam) ? "selected" : ""%>>MIDTERM</option>
						<option value="ENDTERM"
							<%="ENDTERM".equals(selectedExam) ? "selected" : ""%>>ENDTERM</option>
					</select>
				</div>

				<div>
					<button type="button">LOAD</button>
				</div>
			</div>

			<!-- ENTRY TABLE -->
			<div class="table_container2">
				<div class="table_scroll">
					<table>
						<thead>
							<tr>
								<th>Roll</th>
								<th>Name</th>
								<th>Marks</th>
							</tr>
						</thead>
						<tbody>
							<%
							List<String[]> entryList = (List<String[]>) request.getAttribute("marksEntryList");

							if (entryList != null) {
								for (String[] row : entryList) {
									String studentId = row[0];
									String marks = row[2];
							%>
							<tr>
								<td><%=row[0]%></td>
								<td><%=row[1]%></td>
								<td><input type="number" min="0" max="100"
									name="marks_<%=studentId%>"
									value="<%=marks != null ? marks : ""%>" /></td>
							</tr>
							<%
							}
							}
							%>
						</tbody>
					</table>
				</div>
			</div>

			<div class="manage_btn">
				<a class="savebtn" href="#">Save Marks</a>
			</div>
		</div>
	</form>

	<script>
const box1 = document.querySelector(".box1");
const box2 = document.querySelector(".box2");
const add_btn = document.querySelector(".add_btn");
const savebtn = document.querySelector(".savebtn");


add_btn.addEventListener("click", (e) => {
    e.preventDefault();
    box1.classList.add("active");
    setTimeout(() => box2.classList.add("active"), 200);
});


savebtn.addEventListener("click", (e) => {
    e.preventDefault();
    document.getElementById("marksForm").submit();
});

document.querySelector(".box2 button").addEventListener("click", function () {
    const course = document.querySelector("#course_picker").value;
    const exam = document.querySelector("#exam_picker").value;

    window.location.href = "layout?page=marks&course=" + course + "&exam=" + exam + "&mode=load";
});

<%if ("load".equals(mode)) {%>
box1.classList.add("active");
setTimeout(() => box2.classList.add("active"), 100);
<%}%>
</script>

</body>
</html>