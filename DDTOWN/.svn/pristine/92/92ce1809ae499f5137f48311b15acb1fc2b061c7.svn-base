package kr.or.ddit.mapper;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.MemberAuthVO;
import kr.or.ddit.vo.MemberVO;

@Mapper
public interface IUserMapper {

	public int idCheck(String memId);

	public int register(MemberVO memberVO);

	public void registerAuth(int memNo);
	
}
