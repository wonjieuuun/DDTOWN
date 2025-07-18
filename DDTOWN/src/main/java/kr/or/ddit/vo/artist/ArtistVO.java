package kr.or.ddit.vo.artist;

import java.util.Date;

import lombok.Data;

@Data
public class ArtistVO {
	
	private int artNo;
	private int artGroupNo;
	private String memUsername;
	private String artNm;
	private String artContent;
	private Date artRegDate;
	private Date artModDate;
	private String artProfileImg;
	
}
