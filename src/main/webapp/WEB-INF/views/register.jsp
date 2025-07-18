<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>회원가입</title>
<%@ include file="./modules/headerPart.jsp" %>
</head>
<body class="hold-transition ${bodyText }">
	<div class="register-box">
		<div class="card card-outline card-danger mt-4 mb-4" id="card-signup">
			<div class="card-header text-center">
				<a href="" class="h1"><b>DDIT</b>BOARD</a>
			</div>
			<div class="card-body">
				<p class="login-box-msg">회원가입</p>
				
				<form action="/signup/signup.do" method="post" id="signupForm">
					<sec:csrfInput/>
					<div class="input-group mb-3">
						<input type="text" class="form-control" id="memId" name="memId" placeholder="아이디를 입력해주세요"> 
						<span class="input-group-append">
							<button type="button" class="btn btn-secondary btn-flat" id="idCheckBtn">중복확인</button>
						</span>
						<span class="error invalid-feedback" style="display:block;">${errors.memId }</span>
					</div>
					<div class="input-group mb-3">
						<input type="text" class="form-control" id="memPw" name="memPw" placeholder="비밀번호를 입력해주세요">
						<span class="error invalid-feedback" style="display:block;">${errors.memPw }</span>
					</div>
					<div class="input-group mb-3">
						<div class="col">
							<input type="text" class="form-control" id="memLastNm" name="memLastNm" placeholder="성을 입력해주세요">
							<span class="error invalid-feedback" style="display:block;">${errors.memLastNm }</span>
						</div>
						<div class="col">
							<input type="text" class="form-control" id="memFirstNm" name="memFirstNm" placeholder="이름을 입력해주세요">
							<span class="error invalid-feedback" style="display:block;">${errors.memFirstNm }</span>
						</div>
					</div>
					<div class="input-group mb-3">
						<input type="text" class="form-control" id="memNicknm" name="memNicknm" placeholder="닉네임을 입력해주세요">
						<span class="input-group-append">
							<button type="button" class="btn btn-secondary btn-flat" id="nickCheckBtn">중복확인</button>
						</span>
						<span class="error invalid-feedback" style="display:block;">${errors.memNicknm }</span>
					</div>
					<div class="input-group mb-3">
						<input type="text" class="form-control" id="memEmail" name="memEmail" placeholder="이메일을 입력해주세요">
						<span class="input-group-append">
							<button type="button" class="btn btn-secondary btn-flat" id="emailCheckBtn">중복확인</button>
						</span>
						<span class="error invalid-feedback" style="display:block;">${errors.memEmail }</span>
					</div>
					<div class="input-group mb-3">
						<input type="text" class="form-control" id="memTelno" name="memTelno" placeholder="전화번호를 입력해주세요">
					</div>
					<div class="input-group mb-3">
						<input type="date" class="form-control" id="memBirth" name="memBirth" placeholder="생일을 입력해주세요">
					</div>
					<div class="row">
						<div class="col-8">
							<div class="icheck-primary">
								<input type="checkbox" id="memAgree" name="memAgree" value="Y">
								<label for="memAgree"> 개인정보 사용을 동의해주세요 <a href="#">개인정보방침</a></label>
							</div>
						</div>
						<div class="col-4">
							<button type="button" class="btn btn-dark btn-block" id="signupBtn">가입하기</button>
						</div>
						<button type="button" class="btn btn-secondary btn-block mt-4" onclick="javascript:location.href='/'">뒤로가기</button>
					</div>
				</form>
			</div>
		</div>
	</div>

	<script src="${pageContext.request.contextPath }/resources/plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
	<script src="${pageContext.request.contextPath }/resources/plugins/bs-custom-file-input/bs-custom-file-input.min.js"></script>
	<script src="${pageContext.request.contextPath }/resources/dist/js/adminlte.min.js"></script>
	
</body>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script type="text/javascript">
$(function(){
	
	// 아이디 중복확인 이벤트 영역
	let idCheckBtn = $("#idCheckBtn");		// 아이디 중복확인 버튼 Element
	let idCheckFlag = false;				// 중복확인 flag(true:중복체크 완료, false: 중복체크 미완료)
	
	// 우편번호 찾기 + 지도 생성
	let memAddress2 = $("#memAddress2");	// 상세주소 Element
	
	// 가입하기 영역
	let signupBtn = $("#signupBtn"); 		// 가입하기 버튼 Element
	let signupForm = $("#signupForm");		// 가입하기 Form Element
	
	// 아이디 중복확인 버튼 이벤트
	idCheckBtn.on("click",function(){
		let id = $("#memId").val();	// 입력한 아이디 값
		
		if(id == null || id == "") { // 아이디 입력이 비어있다면
			sweetAlert("error","아이디를 입력해주세요!");
			return false;
		}
		
		let data = {
				memId : id
		};
		
		$.ajax({
			url : "/signup/idCheck",
			type : "post",
			data : JSON.stringify(data),
			contentType : "application/json; charset=utf-8",
			beforeSend : function(xhr) {
		        xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
		    },
			success : function(res){
				let err = $(".error")[0];	// error 클래스를 가지고있는 element 중 id요소에 해당하는 Element
				if(res == "NOTEXIST"){	// 아이디 사용가능
					sweetAlert("success","사용가능한 아이디입니다.");
					$(err).html("사용가능한 아이디입니다!").css("color","green");
					idCheckFlag = true;
				}else{					// 중복된 아이디 사용 불가능
					sweetAlert("error","이미 사용 중인 아이디 입니다.");
					$(err).html("이미 사용 중인 아이디 입니다.").css("color","red");
					idCheckFlag = false;
				}
			}
			
		});
	});
	
	// 가입하기 버튼
	signupBtn.on("click",function(){
		let memId = $("#memId").val();		// 아이디 값
		let memPw = $("#memPw").val(); 		// 비밀번호 값
		let memFirstNm = $("#memFirstNm").val();	// 성 값
		let memLastNm = $("#memLastNm").val();	// 이름 값
		let memNicknm = $("#memNicknm").val();	// 이름 값
		let memEmail = $("#memEmail").val();	// 이름 값
		let memTelno = $("#memTelno").val();	// 이름 값
		let agreeFlag = false;				// 개인정보 동의 방침 flag(true:동의, false: 비동의)
		let memBirth = $("#memBirth").val();
		console.log(memBirth);
		// 아이디, 비밀번호, 이름 기본 유효성 검사
		if(memId == null || memId.trim() == ""){
			sweetAlert("error","아이디를 입력해주세요!");
			return false;
		}
		if(memPw == null || memPw.trim() == ""){
			sweetAlert("error","비밀번호를 입력해주세요!");
			return false;
		}
		if(memFirstNm == null || memFirstNm.trim() == ""){
			sweetAlert("error","이름을 입력해주세요!");
			return false;
		}
		if(memLastNm == null || memLastNm.trim() == ""){
			sweetAlert("error","성을 입력해주세요!");
			return false;
		}
		if(memNicknm == null || memNicknm.trim() == ""){
			sweetAlert("error","닉네임을 입력해주세요!");
			return false;
		}
		if(memEmail == null || memEmail.trim() == ""){
			sweetAlert("error","이메일을 입력해주세요!");
			return false;
		}
		if(memTelno == null || memTelno.trim() == ""){
			sweetAlert("error","전화번호를 입력해주세요!");
			return false;
		}
		if(memTelno.length < 10 || memTelno.length >= 12){
			sweetAlert("error","전화번호는 10~11자리입니다!");
			return false;			
		}
		let emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
		if(!emailPattern.test(memEmail)){
			sweetAlert("error","올바른 이메일 형식이 아닙니다!");
			return false;			
			
		}
		let memAgree = $("#memAgree:checked").val();
		if(memAgree == "Y"){	// 개인정보 동의 체크 함
			agreeFlag = true;			
		}
		// 개인정보 처리방침을 동의했습니까?
		// 아이디 중복체크를 이행하고 오셨습니까?
		// 오셨다구요? 그럼 가입하기를 진행하겠습니다.
		// 예? 안했다구요? 그럼 하기를 할 수 없습니다.
		if(agreeFlag){
			if(idCheckFlag){	// 중복체크 완료
				signupForm.submit();
			}else{				// 중복체크 미완료
				sweetAlert("error","아이디 중복체크를 해주세요!");
			}
		}else{
			sweetAlert("error","개인정보 동의를 체크해주세요!");
		}
	});
	
	
});

// 이미지 파일인지 체크 함수
function isImageFile(file){
	let ext = file.name.split(".").pop().toLowerCase();	// 파일명에서 확장자를 가져옵니다.
	return ($.inArray(ext,["jpg","jpeg","png","gif"]) === -1) ? false : true;
}

// 카카오 주소 API(주소 찾기)
function DaumPostcode() {
	new daum.Postcode({
		oncomplete: function(data) {
			// 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.
			
			// 각 주소의 노출 규칙에 따라 주소를 조합한다.
			// 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
			var addr = ''; // 주소 변수
			var extraAddr = ''; // 참고항목 변수
			
			//사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
			if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
			    addr = data.roadAddress;
			} else { // 사용자가 지번 주소를 선택했을 경우(J)
			    addr = data.jibunAddress;
			}
			
			// 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
			if(data.userSelectedType === 'R'){
			    // 법정동명이 있을 경우 추가한다. (법정리는 제외)
			    // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
			    if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
			        extraAddr += data.bname;
			    }
			    // 건물명이 있고, 공동주택일 경우 추가한다.
			    if(data.buildingName !== '' && data.apartment === 'Y'){
			        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
			    }
			} 
			
			// 우편번호와 주소 정보를 해당 필드에 넣는다.
			document.getElementById('memPostCode').value = data.zonecode;
			document.getElementById("memAddress1").value = addr;
			// 커서를 상세주소 필드로 이동한다.
			document.getElementById("memAddress2").focus();
		}
	}).open();
 }

</script>
</html>

