<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DD TOWN - 재무정보</title>
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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/pages/finance.css">
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
        <section class="finance-hero">
            <div class="container">
                <h2>재무정보</h2>
                <p>DD TOWN의 투명한 재무 정보를 확인하실 수 있습니다.</p>
            </div>
        </section>

        <%-- 이 overview-cards 부분의 데이터는 컨트롤러에서 Model 객체로 전달받아 표시할 수 있습니다. --%>
        <%-- 예: model.addAttribute("revenue2023", 28500000000L); --%>
        <%-- 예: model.addAttribute("financialSummary", summaryVO); // FinancialSummaryVO 객체 전달 --%>
        <section class="finance-overview">
            <div class="container">
                <div class="overview-cards">
                    <div class="overview-card">
                        <h3>매출액</h3>
                        <%-- EL을 사용하여 컨트롤러에서 전달된 값을 표시, fmt:formatNumber로 숫자 포맷팅 --%>
                        <p class="number">₩ <fmt:formatNumber value="${financialSummary.revenue != null ? financialSummary.revenue : 285000000}" type="number"/></p>
                        <p class="description"><c:out value="${financialSummary.year != null ? financialSummary.year : '2024'}" />년 기준</p>
                    </div>
                    <div class="overview-card">
                        <h3>영업이익</h3>
                        <p class="number">₩ <fmt:formatNumber value="${financialSummary.operatingProfit != null ? financialSummary.operatingProfit : 320000000}" type="number"/></p>
                        <p class="description"><c:out value="${financialSummary.year != null ? financialSummary.year : '2024'}" />년 기준</p>
                    </div>
                    <div class="overview-card">
                        <h3>자본금</h3>
                        <p class="number">₩ <fmt:formatNumber value="${financialSummary.capitalStock != null ? financialSummary.capitalStock : 500000000}" type="number"/></p>
                        <p class="description"><c:out value="${financialSummary.year != null ? financialSummary.year : '2024'}" />년 기준</p>
                    </div>
                </div>
            </div>
        </section>

        <section class="finance-details">
            <div class="container">
                <div class="finance-tabs">
                    <button class="tab-button active" data-tab="income">손익계산서</button>
                    <button class="tab-button" data-tab="balance">대차대조표</button>
                    <button class="tab-button" data-tab="cash">현금흐름표</button>
                </div>

                <%-- 각 탭의 테이블 데이터는 실제로는 컨트롤러에서 List<FinancialStatementItemVO> 등으로 전달받아 <c:forEach>로 반복 처리해야 합니다. --%>
                <%-- 여기서는 HTML 구조를 유지하며, 숫자 부분에 <fmt:formatNumber>를 적용하는 예시를 보여드립니다. --%>
                <%-- 컨트롤러에서 model.addAttribute("incomeStatement", incomeDataList); 와 같이 전달했다고 가정 --%>
                <div class="tab-content active" id="income">
                    <h3>손익계산서</h3>
                    <div class="table-responsive">
                        <table class="finance-table">
                            <thead>
                                <tr>
                                    <th>구분</th>
                                    <th>2024년</th>
                                    <th>2023년</th>
                                    <th>2022년</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="item" items="${incomeStatement}">
                                    <tr class="${item.highlight ? 'highlight' : ''}">
                                        <td><c:out value="${item.categoryName}"/></td>
                                        <td><fmt:formatNumber value="${item.value2024}" type="number"/></td>
                                        <td><fmt:formatNumber value="${item.value2023}" type="number"/></td>
                                        <td><fmt:formatNumber value="${item.value2022}" type="number"/></td>
                                    </tr>
                                </c:forEach>
                                <%-- 데이터가 없을 경우를 위한 예시 (정적 데이터는 그대로 둠) --%>
                                <c:if test="${empty incomeStatement}">
                                    <tr>
                                        <td>매출액</td>
                                        <td><fmt:formatNumber value="285000000" type="number"/></td>
                                        <td><fmt:formatNumber value="228000000" type="number"/></td>
                                        <td><fmt:formatNumber value="185000000" type="number"/></td>
                                    </tr>
                                    <tr>
                                        <td>매출원가</td>
                                        <td><fmt:formatNumber value="152000000" type="number"/></td>
                                        <td><fmt:formatNumber value="125000000" type="number"/></td>
                                        <td><fmt:formatNumber value="102000000" type="number"/></td>
                                    </tr>
                                    <tr class="highlight">
                                        <td>영업이익</td>
                                        <td><fmt:formatNumber value="32000000" type="number"/></td>
                                        <td><fmt:formatNumber value="18000000" type="number"/></td>
                                        <td><fmt:formatNumber value="13000000" type="number"/></td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="tab-content" id="balance">
                    <h3>대차대조표</h3>
                    <div class="table-responsive">
                        <table class="finance-table">
                             <thead>
                                <tr>
                                    <th>구분</th>
                                    <th>2024년</th>
                                    <th>2023년</th>
                                    <th>2022년</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="item" items="${balanceSheet}">
                                     <tr class="${item.highlight ? 'highlight' : ''}">
                                        <td><c:out value="${item.categoryName}"/></td>
                                        <td><fmt:formatNumber value="${item.value2024}" type="number"/></td>
                                        <td><fmt:formatNumber value="${item.value2023}" type="number"/></td>
                                        <td><fmt:formatNumber value="${item.value2022}" type="number"/></td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty balanceSheet}">
                                    <tr>
                                        <td>자산총계</td>
                                        <td><fmt:formatNumber value="158000000" type="number"/></td>
                                        <td><fmt:formatNumber value="125000000" type="number"/></td>
                                        <td><fmt:formatNumber value="102000000" type="number"/></td>
                                    </tr>
                                    <tr class="highlight">
                                        <td>자본총계</td>
                                        <td><fmt:formatNumber value="750000000" type="number"/></td>
                                        <td><fmt:formatNumber value="570000000" type="number"/></td>
                                        <td><fmt:formatNumber value="470000000" type="number"/></td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="tab-content" id="cash">
                    <h3>현금흐름표</h3>
                    <div class="table-responsive">
                        <table class="finance-table">
                            <thead>
                                <tr>
                                    <th>구분</th>
                                    <th>2024년</th>
                                    <th>2023년</th>
                                    <th>2022년</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="item" items="${cashFlowStatement}">
                                     <tr class="${item.highlight ? 'highlight' : ''}">
                                        <td><c:out value="${item.categoryName}"/></td>
                                        <td><fmt:formatNumber value="${item.value2024}" type="number"/></td>
                                        <td><fmt:formatNumber value="${item.value2023}" type="number"/></td>
                                        <td><fmt:formatNumber value="${item.value2022}" type="number"/></td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty cashFlowStatement}">
                                    <tr>
                                        <td>영업활동현금흐름</td>
                                        <td><fmt:formatNumber value="280000000" type="number"/></td>
                                        <td><fmt:formatNumber value="150000000" type="number"/></td>
                                        <td><fmt:formatNumber value="100000000" type="number"/></td>
                                    </tr>
                                    <tr class="highlight">
                                        <td>현금및현금성자산증가</td>
                                        <td><fmt:formatNumber value="110000000" type="number"/></td>
                                        <td><fmt:formatNumber value="500000000" type="number"/></td>
                                        <td><fmt:formatNumber value="400000000" type="number"/></td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </section>

    </main>

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
                            <span>서울특별시 강남구 테헤란로 123 DD TOWN 빌딩</span>
                        </div>
                        <div class="contact-item">
                            <i class="fas fa-phone"></i>
                            <span>02-123-4567</span>
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
    <script src="${pageContext.request.contextPath}/resources/js/pages/finance.js"></script>
</body>
</html>
