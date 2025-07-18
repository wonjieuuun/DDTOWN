package kr.or.ddit.service;

import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.mapper.IUserMapper;
import kr.or.ddit.vo.MemberVO;

@Service
public class UserServiceImpl implements IUserService {

	@Autowired
	private IUserMapper userMapper;
	
	@Autowired
	private BCryptPasswordEncoder passwordEncoder;
	
	@Override
	public ServiceResult idCheck(String memId) {
		ServiceResult result = null;
		int status = userMapper.idCheck(memId);
		if(status > 0) {
			result = ServiceResult.EXIST;
		}else {
			result = ServiceResult.NOTEXIST;
		}
		
		return result;
	}

	@Transactional
	@Override
	public ServiceResult register(MemberVO memberVO) {
		ServiceResult result = null;
		MemberVO newMemberVO = new MemberVO();
		BeanUtils.copyProperties(memberVO, newMemberVO);
		String encodedPw = passwordEncoder.encode(memberVO.getMemPw());
		newMemberVO.setMemPw(encodedPw);
		int status = userMapper.register(newMemberVO);
		if(status > 0) {
			userMapper.registerAuth(newMemberVO.getMemNo());
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}
		return result;
	}
}
