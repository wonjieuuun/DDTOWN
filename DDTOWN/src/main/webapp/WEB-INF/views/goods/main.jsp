<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DDTOWN 굿즈샵</title>
 	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/pages/goods.css">
</head>
<body>
    <header class="site-header">
        <div class="logo">
            <a href="${pageContext.request.contextPath}/goods/main">DDTOWN SQUARE</a>
        </div>
        <nav class="utility-nav">
            <c:choose>
                <c:when test="${sessionScope.isUserLoggedIn_server == true}">
                    <ul id="loggedInNav">
                        <li><a href="#" class="icon-btn" title="알림">🔔</a></li>
                        <li><a href="${pageContext.request.contextPath}/mypage.html" class="icon-btn" title="마이페이지">👤</a></li>
                        <li><a href="#" class="icon-btn" title="고객센터">👩‍💻</a></li>
                        <li><a href="${pageContext.request.contextPath}/logout" id="logoutBtn" class="auth-link">로그아웃</a></li>
                    </ul>
                </c:when>
                <c:otherwise>
                    <ul id="loggedOutNav">
                        <li><a href="${pageContext.request.contextPath}/login.html" class="auth-link">로그인</a></li>
                        <li><a href="${pageContext.request.contextPath}/signup.html" class="signup-link">회원가입</a></li>
                    </ul>
                </c:otherwise>
            </c:choose>
        </nav>
    </header>

    <nav class="main-navigation">
        <ul>
            <li><a href="${pageContext.request.contextPath}/goods/main">굿즈샵</a></li>
            <li>
                <a href="#">선호도 조사</a>
                <ul class="submenu">
                    <li><a href="${pageContext.request.contextPath}">인기 투표</a></li>
                </ul>
            </li>
            <li><a href="#">콘서트</a></li>
        </ul>
    </nav>

    <%-- 메인 공지사항 객체(notice)가 null이 아니고 비어있지 않은 경우에만 표시 --%>
    <c:if test="${not empty notice}">
        <div class="shop-notice-bar">
            ✨ ${notice.goodsNotiTitle}</hr> <a href="${notice.goodsNotiNo}">자세히 보기</a> ✨
        </div>
    </c:if>
    
        <nav class="artist-filter-bar">
            <button class="filter-btn active" data-artist-id="all">전체</button>
            <c:forEach var="artist" items="${artistList}">
                <button class="filter-btn" data-artist-id="${artist.id}">${artist.name}</button>
            </c:forEach>
        </nav>

        <section class="product-list-section">
            <div class="product-grid-header">
                <h2>전체 상품</h2>
                <div class="sort-options">
                    <select id="sortProducts">
                        <option value="newest">신상품순</option>
                        <option value="popularity">인기순</option>
                        <option value="priceLowHigh">낮은가격순</option>
                        <option value="priceHighLow">높은가격순</option>
                    </select>
                </div>
            </div>

            <%--
                백엔드(서버)에서는 상품 객체 목록을 제공해야 합니다.
                예시: List<Product> productList = ...;
                         // Product 객체는 id, artistId, artistName, name, imageUrl, price를 가집니다.
                         request.setAttribute("productList", productList);
            --%>
            
            <div class="product-grid" id="productGrid">
                <c:forEach items="${goodsList}" var="goods" >
                    <a href="${pageContext.request.contextPath}/goods_detail?productId=${goods.goodsNo}" class="product-item" data-artist="${goods.artGroupNo}"> <%--상품 정보 가져오기 --%>
                        <div class="product-image-wrapper">
                           <%--  <img src="${not empty goods.fileGroupNo ? goods.fileGroupNo : 'https://via.placeholder.com/300x300/E6E6FA/000000?text=No+Image'}" alt="${goods.goodsNm}"> --%>
                        </div>
                        <div class="product-info">
                            <div>
                                <span class="product-artist-tag">${goods.artGroupNo}</span>
                                <h3 class="product-name">${goods.goodsNm}</h3>
                            </div>
                            <div class="product-price">
                                <fmt:formatNumber value="${goods.goodsPrice}" type="number" />
                                <span class="currency">원</span>
                            </div>
                        </div>
                    </a>
                </c:forEach>
            </div>
        </section>
    </div>

    <%--
        백엔드(서버)에서는 cartItemCount와 wishlistItemCount를 제공해야 합니다.
        예시: request.setAttribute("cartItemCount", 3); // Integer 타입
                 request.setAttribute("wishlistItemCount", 1); // Integer 타입
    --%>
    <c:set var="cartCount" value="${not empty cartItemCount ? cartItemCount : 0}" />
    <c:set var="wishCount" value="${not empty wishlistItemCount ? wishlistItemCount : 0}" />

    <nav class="floating-nav">
        <a href="${pageContext.request.contextPath}/cart.html" class="floating-btn" id="floatingCartBtn" title="장바구니">
            🛒
            <span class="item-count-badge" id="cartItemCount" style="display: ${cartCount > 0 ? 'flex' : 'none'};">${cartCount}</span>
        </a>
        <a href="${pageContext.request.contextPath}/wishlist.html" class="floating-btn" id="floatingWishlistBtn" title="찜목록">
            ❤️
            <span class="item-count-badge" id="wishlistItemCount" style="display: ${wishCount > 0 ? 'flex' : 'none'};">${wishCount}</span>
        </a>
    </nav>

    <script>
    /*    // 로그인 상태 관리 (localStorage 부분은 서버 사이드 세션 관리를 보완할 수 있습니다.)
        const loggedOutNav = document.getElementById('loggedOutNav');
        const loggedInNav = document.getElementById('loggedInNav');
        const logoutBtn = document.getElementById('logoutBtn');

        // 초기 네비게이션 디스플레이는 sessionScope.isUserLoggedIn_server를 기반으로 JSP에서 처리됩니다.
        // 이 JS는 주로 로그아웃 클릭 시 리다이렉트 전에 클라이언트 사이드 UI를 업데이트합니다.
        let isUserLoggedInClient = JSON.parse(localStorage.getItem('isUserLoggedIn')) || false;

        function updateClientNavVisibility() {
            // 이 함수는 서버가 모든 네비게이션 상태를 완벽하게 렌더링하고,
            // 다른 동적 요소들이 순수하게 localStorage 플래그에 의존하지 않는다면 단순화될 수 있습니다.
            const serverLoggedIn = <c:out value="${sessionScope.isUserLoggedIn_server == true ? true : false}" />;
            if (serverLoggedIn) {
                if(loggedOutNav) loggedOutNav.style.display = 'none';
                if(loggedInNav) loggedInNav.style.display = 'flex';
                localStorage.setItem('isUserLoggedIn', JSON.stringify(true));
            } else {
                if(loggedOutNav) loggedOutNav.style.display = 'flex';
                if(loggedInNav) loggedInNav.style.display = 'none';
                localStorage.setItem('isUserLoggedIn', JSON.stringify(false));
            }
        }

        if (logoutBtn) {
            logoutBtn.addEventListener('click', function(event) {
                // 선택 사항: 실제 서버 로그아웃 처리 전에 클라이언트 측 변경
                isUserLoggedInClient = false;
                localStorage.setItem('isUserLoggedIn', JSON.stringify(isUserLoggedInClient));
                if(loggedOutNav) loggedOutNav.style.display = 'flex';
                if(loggedInNav) loggedInNav.style.display = 'none';
                // href 속성이 서버 사이드 로그아웃을 처리합니다.
            });
        }
        // 다른 JS 로직을 위해 필요하다면 서버 기반으로 초기 클라이언트 상태를 설정하기 위해 호출합니다.
        // 또는 순수하게 서버에서 렌더링된 초기 상태에 의존합니다.
        // updateClientNavVisibility(); // localStorage 플래그가 다른 JS 기능에 즉시 중요한 경우 주석 해제

        // 검색 기능
        const searchInput = document.getElementById('shopSearchInput');
        const searchBtn = document.getElementById('shopSearchBtn');
        const productGrid = document.getElementById('productGrid');
        // JSP가 아이템들을 렌더링한 후 allProducts가 채워지도록 합니다.
/*         let allProducts = Array.from(productGrid.querySelectorAll('.product-item')); */

/*         function filterProducts() {
            const searchTerm = searchInput.value.toLowerCase();
            const activeArtistFilter = document.querySelector('.artist-filter-bar .filter-btn.active');
            // artistFilterValue가 올바르게 가져와지는지 확인합니다 (예: data-artist-id).
            const artistFilterValue = activeArtistFilter ? activeArtistFilter.dataset.artistId : 'all';

            allProducts.forEach(product => {
                const productName = product.querySelector('.product-name').textContent.toLowerCase();
                // 상품 아이템은 이제 JSP로부터 data-artist="${product.artistId}"를 가집니다.
                const productArtistIdentifier = product.dataset.artist ? product.dataset.artist.toLowerCase() : '';
                
                // 검색어가 상품명 또는 아티스트 ID(문자열)를 포함하는지 확인합니다.
                const matchesSearch = productName.includes(searchTerm) || productArtistIdentifier.includes(searchTerm); 

                // 아티스트 매칭을 위한 수정된 로직
                const matchesArtist = (artistFilterValue === 'all' || productArtistIdentifier === artistFilterValue.toLowerCase());

                if (matchesSearch && matchesArtist) {
                    product.style.display = 'flex';
                } else {
                    product.style.display = 'none';
                }
            });
        }

        if(searchBtn) searchBtn.addEventListener('click', filterProducts);
        if(searchInput) searchInput.addEventListener('keyup', function(event) {
            if (event.key === 'Enter') filterProducts();
        }); */

        // 아티스트 필터 기능
/*         const filterButtons = document.querySelectorAll('.artist-filter-bar .filter-btn');
        filterButtons.forEach(button => {
            button.addEventListener('click', function() {
                filterButtons.forEach(btn => btn.classList.remove('active'));
                this.classList.add('active');
                filterProducts(); // 아티스트 변경 시 상품 다시 필터링
            });
        }); */

        // 장바구니/찜목록 아이템 수 업데이트 (초기값은 JSP에서 설정)
        // 이 함수는 나중에 AJAX를 통해 카운트가 업데이트될 경우 사용될 수 있습니다.
/*         function updateFloatingCounts(cartCount, wishCount) {
            const cartBadge = document.getElementById('cartItemCount');
            const wishBadge = document.getElementById('wishlistItemCount');
            if (cartBadge) {
                cartBadge.textContent = cartCount;
                cartBadge.style.display = cartCount > 0 ? 'flex' : 'none';
            }
            if (wishBadge) {
                wishBadge.textContent = wishCount;
                wishBadge.style.display = wishCount > 0 ? 'flex' : 'none';
            }
        } */

        // 초기 카운트는 이제 JSP에 의해 스팬(span)에 직접 렌더링됩니다.
        // 예시 JS 호출: updateFloatingCounts(3, 1);는 JSP가 초기 상태를 처리하므로 제거되었습니다.

        // 정렬 기능
        const sortSelect = document.getElementById('sortProducts');
        if (sortSelect) {
            sortSelect.addEventListener('change', function() {
                const sortBy = this.value;
                // 일부 항목이 동적으로 추가/제거된 경우 allProducts를 다시 가져오거나,
                // DOM 변경 시 allProducts가 항상 최신 상태인지 확인합니다.
                // 현재로서는 페이지 로드 후 정적이라고 가정하거나, 재필터링이 가시성을 처리한다고 가정합니다.
                let sortedProducts = [...productGrid.querySelectorAll('.product-item')]; // 현재 표시되거나 숨겨진 아이템들을 가져옵니다.

                switch(sortBy) {
                    case 'newest':
                        // 최신순으로 정렬하려면 일반적으로 서버에서 다시 가져오거나 날짜 데이터가 있어야 합니다.
                        // 현재로서는, 기본값이 최신순이라면 원래 순서로 되돌리는 것을 의미할 수 있습니다.
                        // 가장 간단한 클라이언트 측 방법: 다른 데이터가 없는 경우 원래 DOM 순서를 기준으로 정렬합니다.
                        // 이를 위해서는 `allProducts`가 원본, 초기 목록이어야 합니다.
                        // 단순화를 위해, 원본 서버 순서를 포함하는 `allProducts` 배열을 정렬합니다.
                        sortedProducts = [...allProducts]; // 재정렬을 위해 전체 원본 목록을 사용합니다.
                        break;
                    /* case 'popularity':
                        alert('인기순 정렬은 서버 데이터 또는 추가적인 상품 데이터가 필요합니다.');
                        // 인기 데이터가 포함되지 않는 한 클라이언트 측 변경 없음.
                        return; // 조기 종료 또는 현재 순서 유지 */
                    case 'priceLowHigh':
                        sortedProducts.sort((a, b) => {
                            const priceA = parseInt(a.querySelector('.product-price').textContent.replace(/[^0-9]/g, ''));
                            const priceB = parseInt(b.querySelector('.product-price').textContent.replace(/[^0-9]/g, ''));
                            return priceA - priceB;
                        });
                        break;
                    case 'priceHighLow':
                        sortedProducts.sort((a, b) => {
                            const priceA = parseInt(a.querySelector('.product-price').textContent.replace(/[^0-9]/g, ''));
                            const priceB = parseInt(b.querySelector('.product-price').textContent.replace(/[^0-9]/g, ''));
                            return priceB - priceA;
                        });
                        break;
                }
                productGrid.innerHTML = ''; // 현재 그리드 비우기
                sortedProducts.forEach(product => productGrid.appendChild(product)); // 정렬된 상품 추가
                filterProducts(); // 정렬된 목록에 현재 검색 및 아티스트 필터 다시 적용
            });
        }

        // 페이지 로드 시 정렬 및 필터링을 위해 `allProducts`가 올바르게 초기화되었는지 확인합니다.
        // JSP가 상품 목록을 완전히 렌더링한 후에 이 작업이 필요할 수 있습니다.
   //     document.addEventListener('DOMContentLoaded', () => {
            /* allProducts = Array.from(productGrid.querySelectorAll('.product-item')); */
            // URL 매개변수 또는 저장된 상태를 기반으로 초기 필터를 적용해야 하는 경우:
            // filterProducts(); 
//        });

    </script>
</body>
</html>