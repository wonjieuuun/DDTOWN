package kr.or.ddit.ddtown.controller.goods;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.or.ddit.ddtown.service.goods.IGoodsNoticeService;
import kr.or.ddit.vo.goods.goodsNoticeVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;


@Slf4j
@Controller
@RequestMapping("/goodsnotice")
public class goodsNoticeListController {
	
	@Autowired
	private IGoodsNoticeService service;
	
	@GetMapping("/list")
	public String noticeList(Model model) {
		List<goodsNoticeVO> noticeList = service.noticeList();
		
		model.addAttribute("noticeList", noticeList);
		return "goods/noticeList";
	}
	
	@PostMapping("/search")
	public String noticeSearch(goodsNoticeVO notice, Model model) {
		log.info("검색 실행 중");
		log.info("notice" + notice);
		List<goodsNoticeVO> noticeList = service.search(notice);
		
		model.addAttribute("notice", notice);
		model.addAttribute("noticeList", noticeList);
		
		return "goods/noticeList";
	}
	

}
