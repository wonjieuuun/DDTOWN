package kr.or.ddit.ddtown.mapper.goods;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.goods.goodsNoticeVO;
import kr.or.ddit.vo.goods.goodsVO;

@Mapper
public interface IGoodsMapper {

	public List<goodsVO> goodsList();

}
