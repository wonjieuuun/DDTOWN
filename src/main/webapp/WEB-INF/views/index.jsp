<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Index</title>
	<%@ include file="./modules/headerPart.jsp" %>
</head>
<body>
	<sec:authorize access="isAnonymous()">
		<a href="/signup/form">회원가입하기</a>
		<a href="/login">로그인하기</a>
	</sec:authorize>
	<sec:authorize access="isAuthenticated()">
		<form action="/logout" method="post">
			<sec:csrfInput/>
			<button type="submit" class="btn btn-sm btn-primary">로그아웃하기</button>		
		</form>
	</sec:authorize>      
	
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL" crossorigin="anonymous"></script>
</body>
</html>