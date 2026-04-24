<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Login</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/login/loginPage.css" />
</head>
<body>
	<div id="box1">
		<form action="${pageContext.request.contextPath}/login" method="post"
			id="box2">
			<label for="email">Email-ID:</label> <br> <br> <input
				type="text" id="email" name="email"
				value="<%= request.getAttribute("emailValue") != null ? request.getAttribute("emailValue") : "" %>"
				placeholder="Enter Your Email-ID" required /> <br> <br> <label
				for="password">Password:</label> <br> <br> <input
				type="password" id="password" name="password"
				placeholder="Enter Your Password" required /> <br> <br>

			<div id="box3">
				<input type="checkbox" id="checkbox" required />
				<p>
					I confirm that I have read and agree to the <a href="#">Terms
						and Conditions</a>, and that the server is properly installed and
					running.
				</p>
			</div>

			<br>
			<button type="submit">Login</button>
		</form>
	</div>
	<%
    String error = (String) request.getAttribute("error");
    if (error != null) {
    %>
	<script>
        alert('<%= error %>');
	</script>
	<%
    }
    %>

</body>
</html>