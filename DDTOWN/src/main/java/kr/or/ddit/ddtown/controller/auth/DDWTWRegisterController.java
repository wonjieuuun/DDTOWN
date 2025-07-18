package kr.or.ddit.ddtown.controller.auth;

import java.security.SecureRandom;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;
import java.util.regex.Pattern;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.ddtown.service.EmailService;
import kr.or.ddit.ddtown.service.auth.IUserService;
import kr.or.ddit.vo.user.MemberVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/auth")
public class DDWTWRegisterController {

	@Autowired
	private IUserService userService;
	@Autowired
	private EmailService mailService;
	
	private static final char[] rndAllCharacters = new char[]{
	        //number
	        '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
	        //uppercase
	        'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
	        'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
	        //lowercase
	        'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm',
	        'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
	        //special symbols
	        '@', '$', '!', '%', '*', '?', '&'
	};
	
	
	
	@GetMapping("/form")
	public String registerForm(Model model) {
		model.addAttribute("bodyText", "register-page");
		return "auth/register";
	}
	
	@ResponseBody
	@PostMapping("/idCheck")
	public ResponseEntity<String> idCheck(@RequestBody Map<String, String> param) {
		log.info("idCheck 실행!");
		String username = param.get("username");
		
		ServiceResult result = userService.idCheck(username);
		return new ResponseEntity<String>(result.toString(),HttpStatus.OK);
	}
	@ResponseBody
	@PostMapping("/nickCheck")
	public ResponseEntity<String> nickCheck(@RequestBody Map<String, String> param) {
		log.info("idCheck 실행!");
		String memNicknm = param.get("memNicknm");
		
		ServiceResult result = userService.nickCheck(memNicknm);
		return new ResponseEntity<String>(result.toString(),HttpStatus.OK);
	}
	@ResponseBody
	@PostMapping("/emailCheck")
	public ResponseEntity<String> emailCheck(@RequestBody Map<String, String> param) {
		log.info("idCheck 실행!");
		String peoEmail = param.get("peoEmail");
		
		ServiceResult result = userService.emailCheck(peoEmail);
		return new ResponseEntity<String>(result.toString(),HttpStatus.OK);
	}
	
	@Transactional
	@PostMapping("/signup.do")
	public String register(MemberVO memberVO, Model model, RedirectAttributes ra) {
		log.info("register->memberVO : {}",memberVO);
		String path = "";
		Map<String, String> errors = new HashMap<>();
		if(StringUtils.isBlank(memberVO.getUsername())) {
			errors.put("username", "아이디를 입력해주세요!");
		}
		if(StringUtils.isBlank(memberVO.getPassword())) {
			errors.put("password", "비밀번호를 입력해주세요!");
		}
		if(StringUtils.isBlank(memberVO.getPeoLastNm())) {
			errors.put("peoLastNm", "성을 입력해주세요!");
		}
		if(StringUtils.isBlank(memberVO.getPeoFirstNm())) {
			errors.put("peoFirstNm", "이름을 입력해주세요!");
		}
		if(StringUtils.isBlank(memberVO.getMemNicknm())) {
			errors.put("memNicknm", "닉네임을 입력해주세요!");
		}
		if(StringUtils.isBlank(memberVO.getPeoEmail())) {
			errors.put("peoEmail", "이메일을 입력해주세요!");
		}
		if(StringUtils.isBlank(memberVO.getPeoPhone())) {
			errors.put("peoPhone", "전화번호를 입력해주세요!");
		}
		if(errors.size() > 0) {
			model.addAttribute("error", errors);
			return "auth/register";
		}
		
		
		ServiceResult result = userService.register(memberVO);
		if(ServiceResult.OK.equals(result)) {
			ra.addFlashAttribute("msg", "회원가입되셨습니다. 로그인을 진행해주세요!");
			path = "redirect:/login";
		}else {
			model.addAttribute("memberVO",memberVO);
			path = "auth/register";
		}
		return path;
	}
	
	@GetMapping("/findId")
	public String findIdForm() {
		return "auth/findId";
	}
	
	@ResponseBody
	@PostMapping("/findId")
	public ResponseEntity<Map<String, String>> findId(@RequestBody MemberVO memberVO){
		log.info("findId -> memberVO : {}",memberVO);
		Map<String, String> map = new HashMap<>();
		ResponseEntity<Map<String, String>> entity = null;
		String username = userService.findId(memberVO);
		
		if(StringUtils.isNotBlank(username)) {
			map.put("Status", "SUCCESS");
			map.put("username", username);
			entity = new ResponseEntity<Map<String,String>>(map,HttpStatus.OK);
		}else {
			map.put("Status", "FAILED");
			entity = new ResponseEntity<Map<String,String>>(map,HttpStatus.OK);
		}
		
		return entity;
	}
	
	@GetMapping("/resetPw")
	public String resetPwForm() {
		return "auth/resetPw";
	}
	
	@Transactional
	@ResponseBody
	@PostMapping("/resetPw")
	public ResponseEntity<Map<String, String>> resetPw(@RequestBody MemberVO memberVO) throws Exception{
		log.info("resetPw -> memberVO : {}",memberVO);
		Map<String, String> map = new HashMap<>();
		MemberVO findMemberVO = userService.findPw(memberVO);
		log.info("findMemberVO :{}",findMemberVO);
		if(findMemberVO == null) {
			map.put("Status", "FAILED");
		}else {
			// 임시 비밀번호 만들기
			String tempPw = getRandomPw(8);
			// jsp 템플릿에 보낼 데이터 만들기
			Map<String, Object> modelData = new HashMap<>();
			modelData.put("name", findMemberVO.getPeoName());
			modelData.put("message", tempPw);
			modelData.put("companyName", "DDTOWN");
			modelData.put("contactEmail", "ddtownmaster@gmail.com");
			modelData.put("websiteUrl", "http://localhost:6688/");
			modelData.put("loginPageUrl", "http://localhost:6688/login");
			
			// 메일 전송
			mailService.sendEmailWithThymleafTemplete(findMemberVO.getPeoEmail(), "[DDTOWN] 임시 비밀번호 발급 안내", modelData);
			findMemberVO.setPassword(tempPw);
			log.info("findMemberVO :{}",findMemberVO);
			ServiceResult result = userService.updateTempPw(findMemberVO);
			if(ServiceResult.OK.equals(result)) {
				map.put("Status", "SUCCESS");
			}else {
				map.put("Status", "FAILED");
			}
		}
		return new ResponseEntity<Map<String,String>>(map,HttpStatus.OK);
	}

	private String getRandomPw(int length) {
		SecureRandom random = new SecureRandom();
		StringBuilder sb = new StringBuilder();
		
		int rndAllCharLength = rndAllCharacters.length;
		for(int i = 0; i<length; i++) {
			sb.append(rndAllCharacters[random.nextInt(rndAllCharLength)]);
		}
		String tempPw = sb.toString();
		
		String pattern = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}";
		if(!Pattern.matches(pattern, tempPw)) {
			return getRandomPw(length);
		}
		
		return tempPw;
	}
	
}
