package kr.or.ddit.ddtown.controller.inquiry;

import java.lang.ProcessBuilder.Redirect;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.security.SecurityProperties.User;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.ddtown.service.inquiry.InquiryService;
import kr.or.ddit.vo.inquiry.InquiryCodeVO;
import kr.or.ddit.vo.inquiry.InquiryVO;
import kr.or.ddit.vo.security.CustomOAuth2User;
import kr.or.ddit.vo.security.CustomUser;
import kr.or.ddit.vo.user.MemberVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/inquiry")
public class InquiryController {

	@Autowired
	private InquiryService inquiryService;
	
	@GetMapping("/list")
	public ResponseEntity<Map<Object, Object>> inquiryMain(Model model) {
		Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        MemberVO memberVO = null;
        if(principal instanceof CustomUser) {
            memberVO = ((CustomUser) principal).getMemberVO();
        }else if(principal instanceof CustomOAuth2User) {
            memberVO = ((CustomOAuth2User) principal).getMemberVO();
        }
		
		List<InquiryVO> list = inquiryService.getList(memberVO);
		log.info("list 정보 : " + list);
		
		String fullName = memberVO.getPeoLastNm() + memberVO.getPeoFirstNm();
		
		List<InquiryCodeVO> codeList = inquiryService.getCodeList();
		
		Map<Object, Object> map = new HashMap<>();
		map.put("list", list);
		map.put("name", fullName);
		map.put("codeList", codeList);
		
		return new ResponseEntity<Map<Object, Object>>(map,HttpStatus.OK);
	}
	
	// 상세데이터 가져오기
	@GetMapping("/getData/{inqNo}")
	public ResponseEntity<InquiryVO> inquiryDetail(@PathVariable int inqNo){
		log.info("inqNo : " + inqNo);
		
		InquiryVO vo = inquiryService.getDetail(inqNo);
		
		log.info("vo : " + vo);
		
		return new ResponseEntity<InquiryVO>(vo,HttpStatus.OK);
	}
	
		
	// 1:1 문의 등록
	@PostMapping("/insert")
	public Map<String, Object> inquiryInsertData(InquiryVO inquiryVO) {
		
		log.info("1:1문의 등록 실행");
		log.info("VO : " + inquiryVO);
		
		// 접속중인 사용자 정보
		Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        MemberVO memberVO = null;
        if(principal instanceof CustomUser) {
            memberVO = ((CustomUser) principal).getMemberVO();
        }else if(principal instanceof CustomOAuth2User) {
            memberVO = ((CustomOAuth2User) principal).getMemberVO();
        }
		
        inquiryVO.setMemUsername(memberVO.getMemUsername());
        
        ServiceResult result = inquiryService.insertData(inquiryVO);
        
        
        Map<String, Object> map = new HashMap<>();
        map.put("status", result);
		
		return map;
	}
	
	@GetMapping("/updateData/{inqNo}")
	public ResponseEntity<Map<Object, Object>> updateData(@PathVariable int inqNo) {
		
		Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        MemberVO memberVO = null;
        if(principal instanceof CustomUser) {
            memberVO = ((CustomUser) principal).getMemberVO();
        }else if(principal instanceof CustomOAuth2User) {
            memberVO = ((CustomOAuth2User) principal).getMemberVO();
        }
		
        String fullName = memberVO.getPeoLastNm() + memberVO.getPeoFirstNm();
        
		InquiryVO vo = inquiryService.getDetail(inqNo);
		
		List<InquiryCodeVO> codeList = inquiryService.getCodeList();
		
		Map<Object, Object> map = new HashMap<>();
		
		map.put("vo", vo);
		map.put("codeList", codeList);
		map.put("name", fullName);
		
		return new ResponseEntity<Map<Object,Object>>(map, HttpStatus.OK);
	}
	
	@PostMapping("/updateForm")
	public Map<String, Object> updateForm(InquiryVO vo,RedirectAttributes red) {
		ServiceResult result = null;
		
		log.info("수정요청중...");
		log.info("vo : " + vo);
		
		Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        MemberVO memberVO = null;
        if(principal instanceof CustomUser) {
            memberVO = ((CustomUser) principal).getMemberVO();
        }else if(principal instanceof CustomOAuth2User) {
            memberVO = ((CustomOAuth2User) principal).getMemberVO();
        }
		
        vo.setMemUsername(memberVO.getMemUsername());
        
		result = inquiryService.updateData(vo);
		
		Map<String, Object> map = new HashMap<>();
		map.put("status", result);
		map.put("value", vo.getInqNo());
		
		return map;
	}
	
	@PostMapping("/delete/{inqNo}")
	public Map<String, Object> deleteForm(@PathVariable int inqNo){
		
		ServiceResult result = null;
		
		result = inquiryService.deleteData(inqNo);
		
		Map<String, Object> map = new HashMap<>();
		map.put("status", result);
		
		return map;
	}
	
}
