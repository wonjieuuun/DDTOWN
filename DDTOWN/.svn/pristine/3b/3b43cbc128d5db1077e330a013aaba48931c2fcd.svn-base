package kr.or.ddit.security;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserService;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;

import kr.or.ddit.security.mapper.ISecMemberMapper;
import kr.or.ddit.vo.MemberAuthVO;
import kr.or.ddit.vo.MemberVO;
import kr.or.ddit.vo.security.CustomOAuth2User;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class CustomOAuth2UserService implements OAuth2UserService<OAuth2UserRequest, OAuth2User> {

	@Autowired
	private ISecMemberMapper memberMapper;
	
	@Override
	public OAuth2User loadUser(OAuth2UserRequest userRequest) throws OAuth2AuthenticationException {
		DefaultOAuth2UserService dOauth2 = new DefaultOAuth2UserService();
		OAuth2User oAuth2User = dOauth2.loadUser(userRequest);
		String registrationId = userRequest.getClientRegistration().getRegistrationId();
		
		Map<String, Object> map = oAuth2User.getAttributes();
		Set<String> keySet = map.keySet();
		Iterator<String> ite_key = keySet.iterator();
		while(ite_key.hasNext()) {
			String key = ite_key.next();
			log.info("key : {} , value : {}",key,map.get(key));
		}
		
		  
		MemberVO memberVO = new MemberVO(); 
		MemberAuthVO memberAuthVO = new MemberAuthVO();
		List<MemberAuthVO> memberAuthList = new ArrayList<>(); 
		memberAuthList.add(memberAuthVO);
		memberAuthVO.setAuthNm("ROLE_MEMBER");
		memberVO.setAuthList(memberAuthList);
		
		String userId = null;
		String nickname = null;
		
		if("google".equals(registrationId)) {
			userId = map.get("sub").toString();
			nickname = map.get("name").toString();
		}
		else if("kakao".equals(registrationId)) {
			Map<String, Object> kakaoAccount = (Map<String, Object>) map.get("kakao_account");
			Map<String, Object> kakaoProfile = (Map<String, Object>) kakaoAccount.get("profile");
			userId = map.get("id").toString();
			nickname = (String) kakaoProfile.get("nickname");
		}
		  
		memberVO.setMemId(userId);
		memberVO.setMemNicknm(nickname); 
		  
		MemberVO existingUser = memberMapper.selectByMemIdOAuth2(memberVO);
		if(existingUser == null) { 
			memberMapper.insertByOAuth2(memberVO);
			memberAuthVO.setMemNo(memberVO.getMemNo());
			memberMapper.insertAuthByOAuth2(memberAuthVO); 
		}else { 
			memberVO = existingUser; 
			}
		  
		return memberVO == null ? null : new CustomOAuth2User(memberVO);
				 
	}
}
