package kr.or.ddit.ddtown.service.goods;

import java.util.List;

import org.springframework.stereotype.Service;

import kr.or.ddit.vo.goods.goodsNoticeVO;
import kr.or.ddit.vo.goods.goodsVO;

public interface IGoodsService {
	
	public List<goodsVO> goodsList();
	

}
