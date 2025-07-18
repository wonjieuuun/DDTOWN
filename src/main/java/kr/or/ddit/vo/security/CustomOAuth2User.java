package kr.or.ddit.vo.security;

import java.util.Collection;
import java.util.HashMap;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.oauth2.core.user.DefaultOAuth2User;

import kr.or.ddit.vo.MemberVO;
import lombok.Getter;

@Getter
public class CustomOAuth2User extends DefaultOAuth2User{

	private MemberVO memberVO;
	
	public CustomOAuth2User(Collection<? extends GrantedAuthority> authorities, Map<String, Object> attributes,
			String nameAttributeKey) {
		super(authorities, attributes, nameAttributeKey);
	}

	public CustomOAuth2User(MemberVO memberVO) {
		super(memberVO.getAuthList().stream().map(auth -> new SimpleGrantedAuthority(auth.getAuthNm())).collect(Collectors.toList()),createAttributes(memberVO),"userId");
		this.memberVO = memberVO;
		
	}

	private static Map<String, Object> createAttributes(MemberVO memberVO) {
		Map<String, Object> attributes = new HashMap<>();
		attributes.put("userNo",memberVO.getMemNo());
		attributes.put("userId", memberVO.getMemId());
		attributes.put("userName", memberVO.getMemNicknm());
		
		return attributes;
	}

	
}
