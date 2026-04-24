<!doctype html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<link rel="stylesheet" href="layout.css" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}${cssPage}" />
<style>
body {
	
}
</style>
</head>
<body>
	<div id="layout">
		<h1 id="heading">Student Records Manager</h1>

		<div>
			<ul class="sidebar">
				<li>
					<!-- prettier-ignore --> <a class="sidebar_nav"
					style="border-top: 0"
					href="${pageContext.request.contextPath}/layout?page=home">Home</a>
				</li>
				<li><a class="sidebar_nav"
					href="${pageContext.request.contextPath}/layout?page=student">Student
						Management</a></li>
				<li><a class="sidebar_nav"
					href="${pageContext.request.contextPath}/layout?page=course">Course
						Management</a></li>
				<li><a class="sidebar_nav"
					href="${pageContext.request.contextPath}/layout?page=attendance">Attendance
						Management</a></li>
				<li><a class="sidebar_nav"
					href="${pageContext.request.contextPath}/layout?page=marks">Results</a>
				</li>

				<li><a class="sidebar_nav" href="#" id="log_sb">Logout</a></li>
			</ul>
		</div>

		<div id="content">
			<jsp:include page="${contentPage}"></jsp:include>
		</div>
	</div>
	<div id="logout_container">
		<div id="logout_box">
			<b>
				<p>
					Are you sure you would <br /> like to logout for this site.
				</p>
			</b> <br />
			<div id="btn_box">
				<form action="layout" method="post" style="display:inline;" >
					<button class="layout_btn" type="submit" name="action" value="logout">Logout</button>
					</form>
					<button class="layout_btn" id="cancel">Cancel</button>
				
			</div>
		</div>
	</div>
	<script>
	const log_sb = document.querySelector("#log_sb");
	const cancel = document.querySelector("#cancel");
	const log_cont = document.querySelector("#logout_container");
	
	log_sb.addEventListener("click", (f) => {
        f.preventDefault();
        log_cont.classList.add("active");
      });
	cancel.addEventListener("click", (f) => {
        f.preventDefault();
        log_cont.classList.remove("active");
        
        function logout() {
       
            fetch('layout', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: 'action=logout'
            }).then(() => {
                window.location.href = 'login';
            });
        }
      });
	</script>
</body>
</html>
