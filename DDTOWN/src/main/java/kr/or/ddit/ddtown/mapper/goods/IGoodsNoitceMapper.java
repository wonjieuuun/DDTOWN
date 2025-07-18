package kr.or.ddit.ddtown.mapper.goods;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.goods.goodsNoticeVO;

@Mapper
public interface IGoodsNoitceMapper {

	public List<goodsNoticeVO> noticeList();

	public List<goodsNoticeVO> search(goodsNoticeVO notice);

	public goodsNoticeVO selectMainNotice();



}
