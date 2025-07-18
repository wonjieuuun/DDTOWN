<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <%-- Assuming product object is set in request scope --%>
    <title>DDTOWN 굿즈샵 - ${empty product.name ? "상품 상세" : product.name}</title>
    <link rel="stylesheet" href="../2.main/mainservice_common.css">
    <link rel="stylesheet" href="../2.main/mainservice_home.css">
    <link rel="stylesheet" href="goods_shop.css">
</head>
<body class="product-detail-page-body">
    <header class="site-header">
        <div class="logo">
            <a href="../2.main/artist_community_main.html">DDTOWN SQUARE</a>
        </div>
        <nav class="utility-nav">
            <ul id="loggedOutNav">
                <li><a href="../login.html" class="auth-link">로그인</a></li>
                <li><a href="../signup.html" class="signup-link">회원가입</a></li>
            </ul>
            <ul id="loggedInNav" style="display: none">
                <li><a href="#" class="icon-btn" title="알림">🔔</a></li>
                <li><a href="../mypage.html" class="icon-btn" title="마이페이지">👤</a></li>
                <li><a href="#" class="icon-btn" title="고객센터">👩‍💻</a></li>
                <li><a href="#" id="logoutBtn" class="auth-link">로그아웃</a></li>
            </ul>
        </nav>
    </header>

    <nav class="main-navigation">
        <ul>
            <li><a href="goods_shop.html">굿즈샵</a></li>
            <li>
                <a href="#">선호도 조사</a>
                <ul class="submenu">
                    <li><a href="#">인기 투표</a></li>
                </ul>
            </li>
            <li><a href="#">콘서트</a></li>
        </ul>
    </nav>

    <div class="detail-container">
        <c:if test="${not empty product}">
            <div class="product-main-info-wrapper">
                <section class="product-image-gallery">
                    <div class="product-main-image-detail">
                        <img src="${not empty product.mainImageUrl ? product.mainImageUrl : 'https://via.placeholder.com/550x550/E6E6FA/000000?text=Album+Main'}" alt="상품 메인 이미지" id="mainProductImageDetail">
                    </div>
                    <div class="product-thumbnail-images-detail">
                        <c:forEach var="thumb" items="${product.thumbnailUrls}" varStatus="loop">
                            <img src="${thumb.url}" alt="썸네일 ${loop.count}" class="${loop.first ? 'active' : ''}" onclick="changeDetailMainImage('${thumb.url}', '550x550', this)">
                        </c:forEach>
                        <%-- Fallback if no thumbnails --%>
                        <c:if test="${empty product.thumbnailUrls}">
                            <img src="https://via.placeholder.com/70x70/E6E6FA/000000?text=Thumb1" alt="썸네일 1" class="active" onclick="changeDetailMainImage(this.src, '550x550', this)">
                            <img src="https://via.placeholder.com/70x70/D8BFD8/000000?text=Thumb2" alt="썸네일 2" onclick="changeDetailMainImage(this.src, '550x550', this)">
                        </c:if>
                    </div>
                </section>

                <section class="product-purchase-info">
                    <div class="product-category">${not empty product.category ? product.category : "카테고리"}</div>
                    <div class="artist-tag">${not empty product.artistTag ? product.artistTag : "아티스트"}</div>
                    <h1 class="product-name-detail">${not empty product.name ? product.name : "상품명 없음"}</h1>
                    <p class="product-short-description">${not empty product.shortDescription ? product.shortDescription : "상품 설명이 없습니다."}</p>

                    <div class="product-price-detail-area">
                        <%-- Initial price set to 0, will be updated by JS if an option is selected --%>
                        <div class="product-price-detail" id="productPrice">0<span class="currency">원</span></div>
                        <div class="shipping-info-summary">배송비 3,000원 (50,000원 이상 구매 시 무료)</div>
                    </div>

                    <div class="product-options-detail">
                        <div class="option-group">
                            <label for="productOption">옵션 선택</label>
                            <select id="productOption" name="productOption" onchange="updatePrice()">
                                <option value="">옵션을 선택해주세요</option>
                                <c:forEach var="option" items="${product.optionsList}">
                                    <option value="${option.value}" data-price="${option.price}"><c:out value="${option.displayText}"/> - <fmt:formatNumber value="${option.price}" type="number" groupingUsed="true" />원</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="quantity-selector">
                            <label for="quantityDetail">수량</label>
                            <button id="decreaseQtyBtn">-</button>
                            <input type="number" id="quantityDetail" name="quantityDetail" value="1" min="1" readonly>
                            <button id="increaseQtyBtn">+</button>
                        </div>
                    </div>

                    <div class="total-price-summary">
                        <span class="total-label">총 상품금액:</span>
                        <%-- Initial total price set to 0 --%>
                        <span class="total-amount" id="totalProductPriceDetail">0원</span>
                    </div>

                    <div class="product-actions-detail">
                        <button class="btn-action-detail wishlist" id="addToWishlistBtnDetail">❤️ 찜하기</button>
                        <button class="btn-action-detail cart" id="addToCartBtnDetail">장바구니</button>
                        <button class="btn-action-detail order" id="orderNowBtnDetail">바로 주문</button>
                    </div>
                </section>
            </div>

            <div class="product-info-tabs-container">
                <nav class="product-info-tabs">
                    <a href="#" class="tab-link active" data-tab-target="productDescription">상품 상세</a>
                    <a href="#" class="tab-link" data-tab-target="shippingGuide">배송/교환/환불 안내</a>
                </nav>
                <div class="product-info-content">
                    <div id="productDescription" class="tab-pane active">
                        <h4>상품 정보</h4>
                        <p>${not empty product.longDescription ? product.longDescription : "상세 상품 정보가 없습니다."}</p>
                        <c:if test="${not empty product.detailImageUrl}">
                            <img src="${product.detailImageUrl}" alt="상품 상세 이미지">
                        </c:if>
                        <c:if test="${empty product.detailImageUrl}">
                             <img src="https://via.placeholder.com/700x400/f0f0f0/333?text=상품+상세+이미지+없음" alt="상품 상세 이미지 없음">
                        </c:if>
                        <%-- You can add more dynamic content here if needed --%>
                    </div>
                    <div id="shippingGuide" class="tab-pane">
                        <h4>배송/교환/환불 안내</h4>
                        <p><strong>배송 안내</strong><br> - 기본 배송비는 3,000원이며, 50,000원 이상 구매 시 무료배송입니다.<br> - 주문일로부터 평균 2~5 영업일 이내 발송됩니다. (예약 상품 제외)</p>
                        <p><strong>교환/환불 안내</strong><br> - 상품 수령 후 7일 이내에 신청 가능합니다.<br> - 단순 변심의 경우 왕복 배송비가 부과됩니다.<br> - 상품 불량 및 오배송의 경우 배송비는 판매자 부담입니다.</p>
                    </div>
                </div>
            </div>
        </c:if>
        <c:if test="${empty product}">
            <p style="text-align: center; padding: 50px;">상품 정보를 불러올 수 없습니다.</p>
        </c:if>
    </div>

    <nav class="floating-nav">
        <a href="goods_cart.html" class="floating-btn" title="장바구니">
            🛒
            <span class="item-count-badge" id="cartItemCount" style="display: none;">0</span>
        </a>
        <a href="goods_wishlist.html" class="floating-btn" title="찜목록">
            ❤️
            <span class="item-count-badge" id="wishlistItemCount" style="display: none;">0</span>
        </a>
    </nav>

<%--     Replaced fetch with JSP include for the footer
    <jsp:include page="../2.main/footer.html" /> --%>

    <script>
        // 로그인 상태 관리 ( 그대로 유지 )
/*         const loggedOutNav = document.getElementById('loggedOutNav');
        const loggedInNav = document.getElementById('loggedInNav');
        const logoutBtn = document.getElementById('logoutBtn');
        let isUserLoggedIn = JSON.parse(localStorage.getItem('isUserLoggedIn')) || false;

        function updateNav() {
            if (isUserLoggedIn) {
                loggedOutNav.style.display = 'none';
                loggedInNav.style.display = 'flex';
            } else {
                loggedOutNav.style.display = 'flex';
                loggedInNav.style.display = 'none';
            }
        }

        if (logoutBtn) {
            logoutBtn.addEventListener('click', function(event) {
                event.preventDefault();
                isUserLoggedIn = false;
                localStorage.setItem('isUserLoggedIn', JSON.stringify(isUserLoggedIn));
                // In a real scenario, you might want to call a server logout endpoint here
                updateNav();
                // Optionally redirect to home or login page
                // window.location.href = '../login.html'; 
            });
        }
        updateNav(); */

        // 썸네일 이미지 변경 (Added 'element' parameter to easily manage active class)
/*         function changeDetailMainImage(newSrc, mainSize, clickedElement) {
            const mainImage = document.getElementById('mainProductImageDetail');
            if (mainImage) {
                // Assuming newSrc is already the correct URL for the main image, 
                // or needs transformation like placeholder.
                // If newSrc from thumb is transformable:
                mainImage.src = newSrc.replace(/(\d+x\d+)/, mainSize);
                // If thumb.url passed to this function is already the intended main image url for that thumb,
                // then simply: mainImage.src = newSrc;

                document.querySelectorAll('.product-thumbnail-images-detail img').forEach(thumb => {
                    thumb.classList.remove('active');
                });
                if(clickedElement) {
                    clickedElement.classList.add('active');
                }
            }
        } */
        
        // 페이지 로드 시 첫번째 썸네일에 active 클래스 추가 (if dynamic thumbnails exist)
        // This is now handled by JSP: class="${loop.first ? 'active' : ''}"

        // 옵션 선택에 따른 가격 업데이트
/*         function updatePrice() {
            const optionSelect = document.getElementById('productOption');
            const selectedOption = optionSelect.options[optionSelect.selectedIndex];
            const quantityInput = document.getElementById('quantityDetail');
            const quantity = quantityInput ? parseInt(quantityInput.value) : 1;
            const productPriceEl = document.getElementById('productPrice');
            const totalProductPriceDetailEl = document.getElementById('totalProductPriceDetail');

            if (selectedOption && selectedOption.value && selectedOption.dataset.price) {
                const price = parseInt(selectedOption.dataset.price);
                if (productPriceEl) {
                    productPriceEl.innerHTML = price.toLocaleString() + '<span class="currency">원</span>';
                }
                if (totalProductPriceDetailEl) {
                    totalProductPriceDetailEl.textContent = (price * quantity).toLocaleString() + '원';
                }
            } else {
                if (productPriceEl) {
                    productPriceEl.innerHTML = '0<span class="currency">원</span>';
                }
                if (totalProductPriceDetailEl) {
                    totalProductPriceDetailEl.textContent = '0원';
                }
            }
        } */

        // 수량 조절 및 총 가격 업데이트
/*         const quantityInput = document.getElementById('quantityDetail');
        const decreaseQtyBtn = document.getElementById('decreaseQtyBtn');
        const increaseQtyBtn = document.getElementById('increaseQtyBtn');
        
        function updateTotalProductPriceFromQuantity() {
            const optionSelect = document.getElementById('productOption');
            if (!optionSelect) return;
            const selectedOption = optionSelect.options[optionSelect.selectedIndex];
            const quantity = quantityInput ? parseInt(quantityInput.value) : 1;
            const totalProductPriceDetailEl = document.getElementById('totalProductPriceDetail');
            
            if (totalProductPriceDetailEl && selectedOption && selectedOption.value && selectedOption.dataset.price) {
                const price = parseInt(selectedOption.dataset.price);
                totalProductPriceDetailEl.textContent = (price * quantity).toLocaleString() + '원';
            } else if (totalProductPriceDetailEl) {
                 totalProductPriceDetailEl.textContent = '0원';
            }
        }

        if (decreaseQtyBtn && quantityInput) {
            decreaseQtyBtn.addEventListener('click', () => {
                let currentQty = parseInt(quantityInput.value);
                if (currentQty > 1) {
                    quantityInput.value = currentQty - 1;
                    updateTotalProductPriceFromQuantity();
                }
            });
        }

        if (increaseQtyBtn && quantityInput) {
            increaseQtyBtn.addEventListener('click', () => {
                let currentQty = parseInt(quantityInput.value);
                quantityInput.value = currentQty + 1; // Add max quantity check if needed
                updateTotalProductPriceFromQuantity();
            });
        } */

        // 하단 상세 정보 탭 기능
/*         const detailInfoTabs = document.querySelectorAll('.product-info-tabs .tab-link');
        const detailInfoTabPanes = document.querySelectorAll('.product-info-content .tab-pane');
        detailInfoTabs.forEach(tab => {
            tab.addEventListener('click', function(event) {
                event.preventDefault();
                detailInfoTabs.forEach(t => t.classList.remove('active'));
                this.classList.add('active');
                const targetPaneId = this.getAttribute('data-tab-target');
                detailInfoTabPanes.forEach(pane => {
                    // pane.classList.remove('active'); // Using display none/block instead
                    pane.style.display = 'none'; 
                    if (pane.id === targetPaneId) {
                        // pane.classList.add('active');
                        pane.style.display = 'block';
                    }
                });
            });
        });
         // Ensure the initially active tab content is displayed
        document.addEventListener('DOMContentLoaded', function() {
            detailInfoTabPanes.forEach(pane => {
                if (!pane.classList.contains('active')) {
                    pane.style.display = 'none';
                } else {
                    pane.style.display = 'block';
                }
            });
        }); */


        // 장바구니, 찜하기 버튼 기능
/*         const addToCartBtnDetail = document.getElementById('addToCartBtnDetail');
        if(addToCartBtnDetail) {
            addToCartBtnDetail.addEventListener('click', () => {
                const optionSelect = document.getElementById('productOption');
                if (!optionSelect || !optionSelect.value) {
                    alert('옵션을 선택해주세요.');
                    return;
                }
                // Add actual cart logic here (e.g., AJAX call to server)
                alert('장바구니에 추가되었습니다! (실제 기능은 서버 연동 필요)');
                // For demonstration, redirecting. In a real app, you might update a cart icon or just show a message.
                // window.location.href = 'goods_cart.html'; 
            });
        }

        const addToWishlistBtnDetail = document.getElementById('addToWishlistBtnDetail');
        if(addToWishlistBtnDetail) {
            addToWishlistBtnDetail.addEventListener('click', () => {
                 const optionSelect = document.getElementById('productOption'); // Optional: check if an option needs to be selected for wishlist
                // Add actual wishlist logic here (e.g., AJAX call to server)
                alert('찜 목록에 추가되었습니다! (실제 기능은 서버 연동 필요)');
                // window.location.href = 'goods_wishlist.html';
            });
        } */

        // 바로 주문 버튼 클릭
/*         const orderNowBtnDetail = document.getElementById('orderNowBtnDetail');
        if(orderNowBtnDetail) {
            orderNowBtnDetail.addEventListener('click', function() {
                const optionSelect = document.getElementById('productOption');
                if (!optionSelect || !optionSelect.value) {
                    alert('옵션을 선택해주세요.');
                    return;
                }
                // Add actual order logic here (e.g., collect data and submit to order page/API)
                alert('바로 주문 페이지로 이동합니다. (실제 주문 처리 필요)');
                // This would typically gather selected option, quantity, etc. and POST to an order processing servlet or redirect with params.
                // For now, simple redirection:
                // window.location.href = 'goods_order.html'; 
            });
        }
 */
        // Initialize price display on page load based on default selection
        // updatePrice(); // Call this if you want the price to reflect the default selected option (placeholder or first actual option)
        // The initial prices are now set to 0 by JSP, matching the "옵션을 선택해주세요" state.
    </script>
</body>
</html>