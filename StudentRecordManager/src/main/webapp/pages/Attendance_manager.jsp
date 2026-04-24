
<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<%@ page import="java.util.List"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Attendance Manager</title>
</head>
<body>
	<%
	String mode = request.getParameter("mode");
	%>
	<h1 id="head">ATTENDANCE MANAGEMENT</h1>
	<div class="box1">
		<form method="get" action="layout">
			<input type="hidden" name="page" value="attendance">

			<div class="selector">
				<div>
					<label>COURSE: </label> <select name="course">
						<option value="">ALL</option>
						<%
						List<String[]> courses = (List<String[]>) request.getAttribute("courseOptions");
						String selectedCourse = request.getParameter("course");

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
					<button type="submit">VIEW</button>
				</div>
			</div>
		</form>
		<div class="table_container1">
			<div class="table_scroll">
				<table class="table1">
					<thead>
						<tr>
							<th>Roll Number</th>
							<th>Student Name</th>
							<th>Present/Total</th>
							<th>Percentage</th>
						</tr>
					</thead>
					<tbody>
						<%
						List<String[]> list = (List<String[]>) request.getAttribute("attendanceList");
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
	<form id="attendanceForm" action="layout" method="post">

		<input type="hidden" name="page" value="attendance"> <input
			type="hidden" name="action" value="save">
		<div class="box2">
			<div class="selector">
				<div>
					<label>COURSE: </label><select name="course" id="course_picker">
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
					<label for="date"> Date: </label><input type="date" name="date"
						value="<%=request.getParameter("date") != null ? request.getParameter("date") : ""%>" />
				</div>
				<div>
					<button type="button">LOAD</button>
				</div>
			</div>
			<div class="table_container2">
				<div class="table_scroll">
					<table class="table2">
						<thead>
							<tr>
								<th>Roll Number</th>
								<th>Student Name</th>
								<th>Present</th>
							</tr>
						</thead>
						<tbody>
							<%
							List<String[]> entryList = (List<String[]>) request.getAttribute("studentEntryList");

							if (entryList != null) {
								for (String[] row : entryList) {
									String studentId = row[0];
							%>
							<tr>
								<td><%=row[0]%></td>
								<td><%=row[1]%></td>
								<td><input type="checkbox" name="presentIds"
									value="<%=studentId%>"> Present</td>
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
				<a class="savebtn" href="#">Save Attendance</a>
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
        setTimeout(() => {
          box2.classList.add("active");
        }, 250);
      });

      savebtn.addEventListener("click", (e) => {
        e.preventDefault();
        
        document.getElementById("attendanceForm").submit();
        
        box2.classList.remove("active");
        setTimeout(() => {
          box1.classList.remove("active");
        }, 250);
      });
      const dateInputs = document.querySelectorAll('input[type="date"]');

      const today = new Date().toISOString().split("T")[0];

      dateInputs.forEach(input => {
          if (!input.value) {
              input.value = today;
          }
      });
      document.querySelector(".box1 button").addEventListener("click", function () {
    	    
    	    const course = document.querySelector(".box1 select").value;
    	    const date = document.querySelector(".box1 input[type='date']").value;

    	    window.location.href = "layout?page=attendance&course=" + course + "&date=" + date;
    	});
      document.querySelector(".box2 button").addEventListener("click", function () {

    	    const date = document.querySelector(".box2 input[type='date']").value;
    	    const course = document.querySelector("#course_picker").value;

    	    window.location.href = "layout?page=attendance&course=" + course + "&date=" + date + "&mode=load";
    	});
      <%if ("load".equals(mode)) {%>
      document.querySelector(".box1").classList.add("active");
      setTimeout(() => {
          document.querySelector(".box2").classList.add("active");
      }, 100);
  <%}%>
    </script>

</body>
</html>