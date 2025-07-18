package kr.or.ddit.ddtown;

import java.util.HashMap;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.service.IUserService;
import kr.or.ddit.vo.MemberVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/signup")
public class DDWTWRegisterController {

	@Autowired
	private IUserService userService;
	
	@GetMapping("/form")
	public String registerForm(Model model) {
		model.addAttribute("bodyText", "register-page");
		return "register";
	}
	
	@ResponseBody
	@PostMapping("/idCheck")
	public ResponseEntity<String> idCheck(@RequestBody Map<String, String> param) {
		log.info("idCheck 실행!");
		String memId = param.get("memId");
		
		ServiceResult result = userService.idCheck(memId);
		return new ResponseEntity<String>(result.toString(),HttpStatus.OK);
	}
	
	@PostMapping("/signup.do")
	public String register(MemberVO memberVO) {
		log.info("register->memberVO : {}",memberVO);
		String path = "";
		Map<String, String> errors = new HashMap<>();
		if(StringUtils.isBlank(memberVO.getMemId())) {
			errors.put("memId", "아이디를 입력해주세요!");
		}
		if(StringUtils.isBlank(memberVO.getMemPw())) {
			errors.put("memPw", "비밀번호를 입력해주세요!");
		}
		if(StringUtils.isBlank(memberVO.getMemLastNm())) {
			errors.put("memLastNm", "성을 입력해주세요!");
		}
		if(StringUtils.isBlank(memberVO.getMemFirstNm())) {
			errors.put("memFirstNm", "이름을 입력해주세요!");
		}
		if(StringUtils.isBlank(memberVO.getMemNicknm())) {
			errors.put("memNicknm", "닉네임을 입력해주세요!");
		}
		if(StringUtils.isBlank(memberVO.getMemEmail())) {
			errors.put("memEmail", "이메일을 입력해주세요!");
		}
		if(StringUtils.isBlank(memberVO.getMemTelno())) {
			errors.put("memTelno", "전화번호를 입력해주세요!");
		}
		
		
		ServiceResult result = userService.register(memberVO);
		if(ServiceResult.OK.equals(result)) {
			path = "redirect:/login";
		}else {
			path = "register";
		}
		return path;
	}
	
	
}
