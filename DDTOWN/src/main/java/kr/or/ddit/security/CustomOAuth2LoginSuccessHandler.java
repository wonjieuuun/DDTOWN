package kr.or.ddit.security;

import java.io.IOException;
import java.util.Collection;
import java.util.Iterator;
import java.util.Map;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.web.WebAttributes;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.web.savedrequest.HttpSessionRequestCache;
import org.springframework.security.web.savedrequest.RequestCache;
import org.springframework.security.web.savedrequest.SavedRequest;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.or.ddit.vo.security.CustomOAuth2User;
import kr.or.ddit.vo.user.MemberVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
public class CustomOAuth2LoginSuccessHandler implements AuthenticationSuccessHandler  {

	private RequestCache requestCache = new HttpSessionRequestCache();
	
	@Override
	public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication) throws IOException, ServletException {
		log.info("소셜로그인 성공 핸들러 실행!!!!");
		CustomOAuth2User user = (CustomOAuth2User) authentication.getPrincipal();
		Map<String, Object> attributes = user.getAttributes();
		Iterator<String> ite_attr = attributes.keySet().iterator();
		while(ite_attr.hasNext()) {
			String attr = ite_attr.next();
			log.info("소셜로그인 성공 핸들러 user.getAttributes() -> key : {} , value : {}",attr,attributes.get(attr));
		}
		
		Collection<GrantedAuthority> authList = (Collection<GrantedAuthority>) authentication.getAuthorities();
		for(GrantedAuthority auth : authList) {
			log.info("소셜로그인 성공 핸들러 authList -> auth : {}",auth.getAuthority());
		}
		
		Collection<GrantedAuthority> userAuthList = (Collection<GrantedAuthority>)user.getAuthorities();
		for(GrantedAuthority auth : userAuthList) {
			log.info("소셜로그인 성공 핸들러 userAuthList -> auth : {}",auth.getAuthority());
		}
		MemberVO userVO = user.getMemberVO();
		log.info("소셜로그인 성공 핸들러 MemberVO -> {}",userVO);		
		
		clearAuthenticationAttribute(request);
		
		SavedRequest saveRequest = requestCache.getRequest(request, response);
		String targetUrl = "/";
		
		if(saveRequest != null) {
			log.info("saveRequest.getRedirectUrl() : {}",saveRequest.getRedirectUrl());
			String url = saveRequest.getRedirectUrl();
			if(!isUndesirableTarget(url)) {
				targetUrl = url;
				requestCache.removeRequest(request, response);
			}else {
				requestCache.removeRequest(request, response);
			}
		}
		log.info("소셜로그인 성공 핸들러 url -> {}",targetUrl);
		response.sendRedirect(targetUrl);
	
	}

	private boolean isUndesirableTarget(String url) {
		if(url == null) {
			return true;
		}
		return url.contains("/.well-known/") || url.contains("/.favicon.ico");
	}

	private void clearAuthenticationAttribute(HttpServletRequest request) {
		HttpSession session = request.getSession(false);
		if(session == null) {
			return;
		}
		log.info("session 예외 제거실행!");
		session.removeAttribute(WebAttributes.AUTHENTICATION_EXCEPTION);
	}

}
