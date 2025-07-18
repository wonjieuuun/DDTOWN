<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DD TOWN - 기업 위치</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;400;500;700;900&family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
    <%-- CSS 파일 경로를 ${pageContext.request.contextPath}/resources 로 시작하도록 수정 --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common/reset.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common/variables.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common/layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/components/navigation.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/components/buttons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/components/footer.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/pages/location.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        /* 드롭다운 메뉴 스타일 (다른 JSP와 공통으로 사용될 수 있으므로, 별도 common.css 등으로 옮기는 것을 권장합니다) */
        .has-submenu { position: relative; }
        .has-submenu:hover .submenu { display: block; }
        .submenu { display: none; position: absolute; top: 100%; left: 0; background: white; min-width: 200px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); border-radius: 4px; padding: 8px 0; z-index: 1000; }
        .submenu li { padding: 0; }
        .submenu a { display: block; padding: 8px 16px; color: #333; text-decoration: none; transition: background-color 0.2s; }
        .submenu a:hover { background-color: #f5f5f5; }
        .footer-links .has-submenu .submenu { position: static; box-shadow: none; padding-left: 16px; margin-top: 8px; }
        .footer-links .has-submenu .submenu a { color: #fff; opacity: 0.8; }
        .footer-links .has-submenu .submenu a:hover { opacity: 1; background: none; }
    </style>
</head>
<body>
    <%-- 헤더 부분 --%>
    <header class="site-header">
        <div class="header-container container">
            <div class="logo">
                <h1><a href="${pageContext.request.contextPath}/corporate/main">DD TOWN</a></h1>
            </div>
            <nav class="main-nav">
                <button class="nav-toggle" aria-label="메뉴 열기/닫기">
                    <span class="hamburger"></span>
                </button>
                <ul>
                    <li class="has-submenu">
                        <a href="#">기업 정보</a>
                        <ul class="submenu">
                            <li><a href="${pageContext.request.contextPath}/corporate/finance">재무정보</a></li>
                            <li><a href="${pageContext.request.contextPath}/corporate/about">기업소개</a></li>
                            <li><a href="${pageContext.request.contextPath}/corporate/notice/list">기업 공지</a></li>
                            <li><a href="${pageContext.request.contextPath}/corporate/location">기업 위치</a></li>
                        </ul>
                    </li>
                    <li><a href="${pageContext.request.contextPath}/corporate/audition/schedule">오디션</a></li>
                    <li><a href="${pageContext.request.contextPath}/corporate/artist/profile">아티스트 프로필</a></li>
                    <li><a href="${pageContext.request.contextPath}/community/artist/main">아티스트 커뮤니티</a></li>
                </ul>
            </nav>
        </div>
    </header>

    <main>
        <section class="location-hero">
            <div class="container">
                <h2>기업 위치</h2>
                <p>DD TOWN의 본사 위치와 오시는 길을 안내해드립니다.</p>
            </div>
        </section>

        <section class="location-info">
            <div class="container">
                <div class="location-grid">
                    <div class="map-container">
                        <div id="staticMap" style="width:600px;height:500px;"></div> 
                    </div>
                    <div class="location-details">
                        <div class="address-info">
                            <h3>주소</h3>
                            <p><i class="fas fa-map-marker-alt"></i> <c:out value="${locationInfo.address != null ? locationInfo.address : '대전광역시 중구 계룡로 846'}"/></p>
                        </div>
                        <div class="transportation-info">
                            <h3>대중교통 이용안내</h3>
                            <div class="transport-item">
                                <h4><i class="fas fa-subway"></i> 지하철</h4>
                                <p><c:out value="${locationInfo.subwayInfo != null ? locationInfo.subwayInfo : '1호선 중앙로역 3번 출구에서 도보 5분'}"/></p>
                            </div>
                            <div class="transport-item">
                                <h4><i class="fas fa-bus"></i> 버스</h4>
                                <p><c:out value="${locationInfo.busStopInfo != null ? locationInfo.busStopInfo : '중앙로역 정류장 하차'}"/></p>
                                <ul>
                                    <c:if test="${empty locationInfo.busRoutes}">
                                        <li>간선버스: 101, 102, 103</li>
                                        <li>지선버스: 201, 202</li>
                                        <li>마을버스: 301</li>
                                    </c:if>
                                    <c:forEach var="busRoute" items="${locationInfo.busRoutes}">
                                        <li><c:out value="${busRoute.type}"/>: <c:out value="${busRoute.numbers}"/></li>
                                    </c:forEach>
                                </ul>
                            </div>
                        </div>
                        <div class="contact-info">
                            <h3>연락처</h3>
                            <p><i class="fas fa-phone"></i> <c:out value="${locationInfo.phone != null ? locationInfo.phone : '042-123-4567'}"/></p>
                            <p><i class="fas fa-envelope"></i> <c:out value="${locationInfo.email != null ? locationInfo.email : 'contact@ddtown.com'}"/></p>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </main>
    <!-- 카카오 지도 API : 정적 지도 -->
	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=2816d38a347f8c7797d3f6453ce307b9"></script>
	<script>
		var marker = {
		    position: new kakao.maps.LatLng(36.32508187471473, 127.40889586430282), 
		    text: 'DD TOWN' // text 옵션을 설정하면 마커 위에 텍스트를 함께 표시할 수 있습니다
		};

		var staticMapContainer  = document.getElementById('staticMap'), // 이미지 지도를 표시할 div
		    staticMapOption = { 
		        center: new kakao.maps.LatLng(36.32508187471473, 127.40889586430282), // 이미지 지도의 중심좌표
		        level: 3, // 이미지 지도의 확대 레벨
		        marker: marker // 이미지 지도에 표시할 마커
		    };

		// 이미지 지도를 생성합니다
		var staticMap = new kakao.maps.StaticMap(staticMapContainer, staticMapOption);
	</script>

    <footer class="site-footer">
        <div class="container">
            <div class="footer-container">
                <div class="footer-info">
                    <div class="footer-logo">DD TOWN</div>
                    <p class="footer-description">
                        DD TOWN은 창의성과 열정을 바탕으로 아티스트와 팬 모두에게 최고의 경험을 선사합니다. 
                        우리는 혁신적인 콘텐츠와 글로벌 네트워크를 통해 K-Culture의 미래를 만들어갑니다.
                    </p>
                    <div class="footer-contact">
                        <div class="contact-item">
                            <i class="fas fa-map-marker-alt"></i>
                            <span>대전광역시 중구 계룡로 846</span>
                        </div>
                        <div class="contact-item">
                            <i class="fas fa-phone"></i>
                            <span>042-123-4567</span>
                        </div>
                        <div class="contact-item">
                            <i class="fas fa-envelope"></i>
                            <span>contact@ddtown.com</span>
                        </div>
                    </div>
                </div>
                <div class="footer-links">
                    <h3>바로가기</h3>
                    <ul>
                        <li class="has-submenu">
                            <a href="#">기업 정보</a>
                            <ul class="submenu">
                                <li><a href="${pageContext.request.contextPath}/corporate/finance">재무정보</a></li>
                                <li><a href="${pageContext.request.contextPath}/corporate/about">기업소개</a></li>
                                <li><a href="${pageContext.request.contextPath}/corporate/notice/list">기업 공지</a></li>
                                <li><a href="${pageContext.request.contextPath}/corporate/location">기업 위치</a></li>
                            </ul>
                        </li>
                        <li><a href="${pageContext.request.contextPath}/corporate/audition/schedule">오디션</a></li>
                        <li><a href="${pageContext.request.contextPath}/corporate/artist/profile">아티스트 프로필</a></li>
                        <li><a href="${pageContext.request.contextPath}/community/artist/main">아티스트 커뮤니티</a></li>
                    </ul>
                </div>
            </div>
            <div class="footer-bottom">
                <p>&copy; 2025 DD TOWN Entertainment. All Rights Reserved.</p>
            </div>
        </div>
    </footer>

    <script src="${pageContext.request.contextPath}/resources/js/common/main.js"></script>
    <%-- 지도 API 사용 시 관련 스크립트 추가 --%>
    <%-- 예: <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=YOUR_APP_KEY"></script> --%>
    <%-- 예: <script src="${pageContext.request.contextPath}/resources/js/pages/location-map.js"></script> --%>
</body>
</html>