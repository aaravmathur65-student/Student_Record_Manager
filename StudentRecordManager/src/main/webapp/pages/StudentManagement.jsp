
<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<%@ page import="java.util.List"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Student Manager</title>
</head>
<body>
	<%
	String message = (String) request.getAttribute("message");
	String actionType = (String) request.getAttribute("actionType");
	%>

	<h1 id="head">STUDENT MANAGEMENT</h1>
	<div class="box1">
		<div class="table_container">
			<div class="table_scroll">
			<table>
				<thead>
					<tr>
						<th>Name</th>
						<th>Roll Number</th>
						<th>Email</th>
						<th>Course</th>
					</tr>
				</thead>
				<tbody>
					<%
					List<String[]> list = (List<String[]>) request.getAttribute("studentList");
					if (list != null) {
						for (String[] row : list) {
					%>
					<tr>
						<td><%=row[1]%></td>
						<td><%=row[0]%></td>
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
			<a id="add_btn" class="btn" href="">Add</a> <a id="delete_btn"
				class="btn" href="">Delete</a>
		</div>
	</div>
	<div
		class="box2<%=(message != null && "add".equals(actionType)) ? " active" : ""%>">
		<form action="layout" method="post" id="add_form">
			<input type="hidden" name="page" value="student"> <input
				type="hidden" name="action" value="add"> <label for="name">Name
				(Full Name):</label> <br /> <br /> <input type="text" name="name"
				id="name" required /> <br /> <br /> <label for="email-ID">E-mail:</label>
			<br /> <br /> <input type="email" name="email" id="email-ID"
				required /> <br /> <br /> <label for="roll_no">Roll
				Number:</label> <br /> <br /> <input type="text" name="roll_no"
				id="roll_no" required /> <br /> <br /> <label for="course">Course:</label>
			<br /> <br /> <select name="course_id" required oninvalid="this.setCustomValidity('Please create a course first')">
			<option value="" disabled selected>Select Course</option>
				<%
				List<String[]> courses = (List<String[]>) request.getAttribute("courseOptions");
				if (courses != null) {
					for (String[] courseRow : courses) {
				%>
				
				<option value="<%=courseRow[0]%>">
					<%=courseRow[0]%>
				</option>
				<%
				}
				}
				%>
			</select> <br /> <br />

			<%
			if (message != null && "add".equals(actionType)) {
			%>
			<p class="message">
				<b><%=message%></b>
			</p>
			<br>
			<%
			}
			%>

			<div class="form_btn">
				<!-- need this too when jsp -->
				<button type="submit">Add</button>
				<button class="cancelbtn" type="button">Cancel</button>
			</div>
		</form>
	</div>
	<div
		class="box3<%=(message != null && "delete".equals(actionType)) ? " active" : ""%>">
		<form action="layout" method="post" id="delete_form">
			<input type="hidden" name="page" value="student"> <input
				type="hidden" name="action" value="delete"> <label
				for="name">Roll Number:</label> <br /> <br> <input type="text"
				name="roll_no" class="roll_no" required /> <br> <br>
			<%
			if (message != null && "delete".equals(actionType)) {
			%>
			<p class="message">
				<b><%=message%></b>
			</p>
			<br>
			<%
			}
			%>

			<div class="form_btn">
				<!-- need this too when jsp -->
				<button type="submit">Delete</button>
				<button class="cancelbtn" type="button">Cancel</button>
			</div>
		</form>
	</div>
	<script>   
 
	const form1 = document.querySelector(".box2");
	const form2 = document.querySelector(".box3");
	const add_btn = document.querySelector("#add_btn");
	const delete_btn = document.querySelector("#delete_btn");	

	add_btn.addEventListener("click", (f) => {
	  f.preventDefault();
	  form1.classList.add("active");
	});

	delete_btn.addEventListener("click", (f) => {
	  f.preventDefault();
	  form2.classList.add("active");
	});

	document.querySelectorAll(".cancelbtn").forEach(btn => {
	    btn.addEventListener("click", () => {
	        const box = btn.closest(".box2, .box3");

	        if (box) {
	            box.classList.remove("active");

	            const form = box.querySelector("form");
	            if (form) form.reset();

	            const msg = box.querySelector(".message");
	            if (msg) {
	                const br = msg.nextElementSibling; // get the <br>

	                msg.remove(); // remove message

	                if (br && br.tagName === "BR") {
	                    br.remove(); // remove <br> too
	                }
	            }
	        }
	    });
	});
	</script>
</body>
</html>