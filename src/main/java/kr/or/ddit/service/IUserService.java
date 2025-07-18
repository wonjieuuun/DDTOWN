package kr.or.ddit.service;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.vo.MemberVO;

public interface IUserService {

	public ServiceResult idCheck(String memId);

	public ServiceResult register(MemberVO memberVO);

}
