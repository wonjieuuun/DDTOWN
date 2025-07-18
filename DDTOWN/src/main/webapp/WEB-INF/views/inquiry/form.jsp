<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>문의 수정</title> <%-- 제목 변경 --%>
<%@ include file="../modules/headerPart.jsp" %> <%-- 실제 경로로 수정 필요 --%>
<style>
    html, body {
        height: 100%;
    }
    .wrapper {
        min-height: 100%;
        display: flex;
        flex-direction: column;
    }
    .content-wrapper.no-layout {
        margin-left: 0 !important;
        min-height: 100vh;
        flex-grow: 1;
        background-color: #f4f6f9;
    }
    .page-main-title {
        font-size: 2.2rem;
        font-weight: 600;
        color: #333;
    }
    /* 상세 페이지에서 사용된 .card-title은 폼에서는 보통 label로 대체되므로, 필요시 label 스타일 추가 */
    label {
        font-weight: 600 !important; /* AdminLTE 기본 label보다 조금 더 강조 */
    }
    /* 상세 보기용 스타일은 폼에서는 직접 사용되지 않으므로 주석 처리 또는 제거 가능 */
    /*
    .content-area-text {
        min-height: 100px;
        white-space: pre-wrap;
        word-break: break-all;
        background-color: #f8f9fa;
    }
    .answer-area-text {
        min-height: 100px;
        white-space: pre-wrap;
        word-break: break-all;
        background-color: #e9ecef;
    }
    */
</style>
</head>
<body class="hold-transition">
<div class="wrapper">

    <div class="content-wrapper no-layout">
        <section class="content pt-5 pb-4"> <%-- 하단 패딩 약간 조정 --%>
            <div class="container-fluid">
                <div class="row">
                    <div class="col-12 text-center mb-4">
                        <h1 class="page-main-title">문의 수정</h1> <%-- 제목 변경 --%>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-10 offset-md-1">
                        <form id="inquiryUpdateForm" method="post"> <%-- 폼 태그 시작 --%>
                            <sec:csrfInput /> <%-- Spring Security CSRF 토큰 --%>
                            <input type="hidden" id="updateInqNo" name="inqNo"> <%-- 문의번호 (hidden) --%>

                            <div class="card card-outline card-primary shadow-sm">
                                <div class="card-header">
                                    <h3 class="card-title" style="font-size: 1.2rem; font-weight: 600;">기존 문의 정보</h3>
                                    <%-- 상세 페이지에서 가져온 날짜, 유형 등은 참고용으로 표시하거나 폼 필드로 전환 --%>
                                    <div class="card-tools">
                                         <span id="updateStatus" class="badge badge-warning"></span> <%-- 수정 시 상태는 보통 답변대기 --%>
                                    </div>
                                </div>
                                <div class="card-body">
                                    <div class="form-group">
                                        <label for="updateInqType">문의 유형</label>
                                        <select class="form-control" id="updateInqType" name="inqTypeCode" required>
                                            <%-- 옵션은 JavaScript로 로드되거나 서버에서 직접 생성 --%>
                                            <%-- 예: <option value="CODE1">상품 문의</option> --%>
                                        </select>
                                    </div>

                                    <div class="form-group">
                                        <label for="updateInqTitle">문의 제목</label>
                                        <input type="text" class="form-control" id="updateInqTitle" name="inqTitle" placeholder="제목을 입력하세요" required>
                                    </div>
                                    
                                    <div class="form-group">
                                        <label for="updateRegDate">작성일</label>
                                        <input type="text" class="form-control" id="updateRegDate" name="regDate" readonly>
                                    </div>


                                    <div class="form-group">
                                        <label for="updateInqContent">문의 내용</label>
                                        <textarea class="form-control" id="updateInqContent" name="inqContent" rows="10" placeholder="문의하실 내용을 자세하게 작성해주세요." required></textarea>
                                    </div>
                                    <p class="text-muted small">문의 내용에 개인정보(주민번호, 카드번호 등)가 포함되지 않도록 주의해주세요.</p>

                                    <%-- 답변 내용은 수정 폼에서는 보통 보여주지 않거나, 참고용으로만 표시 --%>
                                    <%-- 만약 답변이 있는 상태에서 수정하는 시나리오라면 아래 주석 해제 --%>
                                    <%--
                                    <div id="answerSectionUpdate" style="display:none;">
                                        <hr>
                                        <h5><i class="fas fa-reply text-success mr-2"></i>관리자 답변</h5>
                                        <div class="p-3 rounded bg-light">
                                            <p id="updateAnsContent" class="mb-0"></p>
                                        </div>
                                    </div>
                                    --%>

                                </div><%-- /.card-body --%>
		                        <div class="card-footer text-right">
		                            <button type="button" class="btn btn-secondary" onclick="history.back()"><i class="fas fa-times mr-1"></i> 취소</button>
		                            <button type="button" class="btn btn-primary" id="updateBtn"><i class="fas fa-check mr-1"></i> 수정 완료</button>
		                        </div>
                            </div>
                        </form> <%-- 폼 태그 끝 --%>
                    </div>
                </div>
            </div>
        </section>
    </div>
    
</div>

<script type="text/javascript">
$(document).ready(function() {
    const currentUrl = location.href;
    const sliceUrl = currentUrl.split("/");
    // 수정 폼의 경우 URL에서 inqNo를 가져오는 방식이 다를 수 있습니다. 
    // 예를 들어 /inquiry/update/{inqNo} 형태라면, 마지막 요소가 inqNo가 됩니다.
    const inqNo = sliceUrl[sliceUrl.length -1];

    // CSRF 토큰 (폼 안에 <sec:csrfInput />가 있으므로 AJAX submit 시에는 FormData 사용 권장)
    const csrfHeaderName = "${_csrf.headerName}";
    const csrfToken = "${_csrf.token}";

    function dateFormat(jsonDate){
        if (!jsonDate) return "";
        let date = new Date(jsonDate);
        let month = date.getMonth() + 1;
        let day = date.getDate();
        month = month >= 10 ? month : '0' + month;
        day = day >= 10 ? day : '0' + day;
        // 시간 부분은 수정 폼에서 표시할 필요가 없다면 생략 가능
        // let hour = date.getHours();
        // let minute = date.getMinutes();
        // hour = hour >= 10 ? hour : '0' + hour;
        // minute = minute >= 10 ? minute : '0' + minute;
        // return date.getFullYear() + '-' + month + '-' + day + ' ' + hour + ':' + minute;
        return date.getFullYear() + '-' + month + '-' + day;
    }

    // 문의 유형 코드 목록을 불러와 select에 채우는 함수 (예시)
    function loadInquiryTypes(selectedTypeCode, codeListFromServer) {
        const typeSelect = $("#updateInqType");
        typeSelect.empty(); // 기존 옵션 제거
        // typeSelect.append('<option value="">문의 유형을 선택하세요</option>'); // 기본 옵션

        if (codeListFromServer && codeListFromServer.length > 0) {
             codeListFromServer.forEach(function(code) {
                let option = new Option(code.description, code.commCodeDetNo);
                typeSelect.append(option);
            });
        }
        // 기존 문의 유형 선택
        if (selectedTypeCode) {
            typeSelect.val(selectedTypeCode);
        }
    }


    // 수정할 기존 문의 데이터를 불러와 폼에 채우는 함수
    function loadInquiryDataForUpdate(){
        $("#updateInqNo").val(inqNo); // hidden input에 inqNo 설정

        $.ajax({
            url : "/inquiry/updateData/" + inqNo, // 기존 데이터 가져오는 URL
            type : "get",
            contentType : "application/json; charset=utf-8",
            success : function(res){
                console.log("Load data for update:", res);
                $("#updateInqTitle").val(res.vo.inqTitle);
                $("#updateInqContent").val(res.vo.inqContent); // textarea는 val()로 값 설정
                $("#updateRegDate").val(dateFormat(res.vo.inqRegDate));
                $("#updateStatus").html(res.vo.statDetailCode.description);

                // 상태 표시 (수정 페이지에서는 보통 '답변대기' 상태로 고정되거나, 수정 중임을 알림)
                // const statusBadge = $("#updateStatus");
                // statusBadge.html(res.statDetailCode.description);
                // if(res.statDetailCode.description === '답변대기'){
                //     statusBadge.removeClass('badge-success').addClass('badge-warning');
                // } else { // 답변완료건은 원칙적으로 수정 불가하나, 정책에 따라 다름
                //     statusBadge.removeClass('badge-warning').addClass('badge-success');
                //     // 답변완료된 문의는 수정 못하게 필드 disable 처리 등 필요
                //     // $("#updateInqTitle").prop("disabled", true);
                //     // $("#updateInqContent").prop("disabled", true);
                //     // $("#updateInqType").prop("disabled", true);
                //     // $("button[type='submit']").prop("disabled", true).html("수정 불가");
                // }

                // 문의 유형 로드 및 선택
                // 실제로는 codeList도 res에 포함되거나 별도 AJAX로 가져와야 함
                // 아래는 res.codeList가 있고, res.typeDetailCode.commCodeDetNo가 선택된 코드라고 가정
                loadInquiryTypes(res.typeDetailCode ? res.typeDetailCode.commCodeDetNo : null, res.codeList);


                // 관리자 답변이 있는 경우 (참고용으로 표시)
                // if(res.ansContent != null){
                //     $("#updateAnsContent").html(res.ansContent.replace(/\n/g, '<br>'));
                //     $("#answerSectionUpdate").show();
                // }
            },
            error : function(error,status, xhr){
                console.log("Error loading data for update: ", error.status, xhr.responseText);
                Swal.fire({
                    icon: 'error',
                    title: '데이터 로드 실패',
                    text: '수정할 문의 정보를 불러오는데 실패했습니다.'
                });
            }
        });
    }

    // 폼 제출 처리
    
    $("#updateBtn").on("click",function(){
    	
    	if($("#updateInqType").val() === ""){
    		Swal.fire('입력 오류', '문의 유형을 선택해주세요.', 'warning');
            return false;
    	}
    	
    	if($("#updateInqTitle").val().trim() === ""){
    		Swal.fire('입력 오류', '문의 제목을 입력해주세요.', 'warning');
            $("#updateInqTitle").focus();
            return false;
    	}
    	
    	if ($("#updateInqContent").val().trim() === "") {
            Swal.fire('입력 오류', '문의 내용을 입력해주세요.', 'warning');
            $("#updateInqContent").focus();
            return false;
        }
    	
    	Swal.fire({
    		title: '문의내용을 수정하시겠습니까?',
    		icon: 'question',
    		showCancelButton: true,
    		confirmButtonColor: '#3085d6',
    		cancelButtonColor: '#d33',
    		confirmButtonText: '네, 수정합니다!',
    		cancelButtonText: '아니오'
    	}).then((result) => {
    		if(result.isConfirmed){
    			let data = new FormData();
    			data.append("inqNo",inqNo);
        		data.append("inqTitle",$("#updateInqTitle").val());
        		data.append("inqContent",$("#updateInqContent").val());
        		data.append("inqTypeCode",$("#updateInqType").val());
        		
        		$.ajax({
        			url : "/inquiry/updateForm",
        			type : "post",
        			data : data,
        			processData : false,
        			contentType : false,
        			success : function(res){
        				if(res.status == "OK"){
        					Swal.fire({
        						icon : 'success',
        						title : '수정 완료!',
        						text : '문의 내용이 성공적으로 수정되었습니다.',
        						timer: 1500,
        						showConfirmButton: false
        					}).then(()=>{
        						location.href = "/inquiry/detail/"+inqNo;
        					});
        				}else{
        					Swal.fire('수정 실패', res.message || '문의 수정에 실패했습니다.', 'error');
        				}
        			},
        			error: function(xhr, status, error){
        				console.log("Update error : ", xhr.responseText);
        				Swal.fire('요청 오류', '문의 수정 중 오류가 발생했습니다.','error');
        			},
        			beforeSend : function(xhr) {
        		        xhr.setRequestHeader('${_csrf.headerName}', '${_csrf.token}');
        		    }
        		});
    		}
    	})
    });
        

    loadInquiryDataForUpdate(); // 페이지 로드 시 데이터 로드
});
</script>
</body>
</html>