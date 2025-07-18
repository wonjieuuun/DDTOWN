package kr.or.ddit.ddtown.service.auth;

import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.ddtown.mapper.IUserMapper;
import kr.or.ddit.vo.user.MemberVO;

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
		String encodedPw = passwordEncoder.encode(memberVO.getPassword());
		newMemberVO.setPassword(encodedPw);
		newMemberVO.setMemRegPath("MRP003");
		int status = userMapper.registerPeople(newMemberVO);
		if(status > 0) {
			status = userMapper.registerMember(newMemberVO);
			if(status > 0) {
				userMapper.registerAuth(newMemberVO.getUsername());				
				result = ServiceResult.OK;
			}else {
				result = ServiceResult.FAILED;				
			}
		}else {
			result = ServiceResult.FAILED;
		}
		return result;
	}

	@Override
	public ServiceResult nickCheck(String memNicknm) {
		ServiceResult result = null;
		int status = userMapper.nickCheck(memNicknm);
		if(status > 0) {
			result = ServiceResult.EXIST;
		}else {
			result = ServiceResult.NOTEXIST;
		}
		
		return result;
	}

	@Override
	public ServiceResult emailCheck(String memEmail) {
		ServiceResult result = null;
		int status = userMapper.emailCheck(memEmail);
		if(status > 0) {
			result = ServiceResult.EXIST;
		}else {
			result = ServiceResult.NOTEXIST;
		}
		
		return result;
	}

	@Override
	public String findId(MemberVO memberVO) {
		return userMapper.findId(memberVO);
	}

	@Override
	public MemberVO findPw(MemberVO memberVO) {
		return userMapper.findPW(memberVO);
	}

	@Override
	public ServiceResult updateTempPw(MemberVO memberVO) {
		ServiceResult result = null;
		String tempPw = passwordEncoder.encode(memberVO.getPassword());
		memberVO.setPassword(tempPw);
		int status = userMapper.updateTempPw(memberVO);
		if(status > 0) {
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}
		return result;
	}
}
