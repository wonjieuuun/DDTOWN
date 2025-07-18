package kr.or.ddit.security.mapper;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.MemberAuthVO;
import kr.or.ddit.vo.MemberVO;

@Mapper
public interface ISecMemberMapper {

	public MemberVO readByUserInfo(String username);

	public void insertByOAuth2(MemberVO memberVO);

	public void insertAuthByOAuth2(MemberAuthVO memberAuthVO);

	public MemberVO selectByMemIdOAuth2(MemberVO memberVO);

}
