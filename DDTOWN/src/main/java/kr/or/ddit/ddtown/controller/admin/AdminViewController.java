package kr.or.ddit.ddtown.controller.admin;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/admin")
public class AdminViewController {
	
	@GetMapping("/main")
	public String Main() {
		return "admin/main";
	}
	
	@GetMapping("/inquiry/main")
	public String adminInquiryListMain() {
		
		log.info("관리자 1:1문의 리스트 요청중...");
		
		return "admin/faq_inquiry/inquiryMain";
	} 
	
}
