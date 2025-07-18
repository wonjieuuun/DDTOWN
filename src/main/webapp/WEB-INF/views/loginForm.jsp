<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h1>Login</h1>
	<hr/>
	
	<c:if test="${not empty error }">
		<h5>error : ${error }</h5>
	</c:if>
	
	<c:if test="${not empty logout }">
		<h5>logout : ${logout }</h5>
	</c:if>
	
	<form action="/login" method="post">
		<sec:csrfInput/>
		username : <input type="text" name="username" /> <br/>
		userpassword : <input type="text" name="password" /> <br/>
		<input type="checkbox" name="remember-me"/>아이디 저장 <br/>
		<input type="submit" value="로그인" /> <br/>
	</form>
	<div>
		<h2>소셜로그인</h2>
		<a href="/oauth2/authorization/google"> 
			<img src="https://developers.google.com/identity/images/g-logo.png" alt="Google 로그인" style="width: 20px; height: 20px; vertical-align: middle;">
			Google로 로그인
		</a>
		<a href="/oauth2/authorization/kakao">
            <img src="https://developers.kakao.com/assets/img/about/logos/kakaolink/kakaolink_btn_medium.png" alt="카카오 로그인" style="width: 20px; height: 20px; vertical-align: middle;">
            카카오로 로그인
        </a>
		
	</div>
</body>
</html>