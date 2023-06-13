package review.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import review.model.ReviewBean;
import review.model.ReviewDao;

@Controller
public class ReviewDeleteController {
	private final String command = "deleteReview.mb";
	private final String getPage = "redirect:/viewMyReviewList.mb";
	@Autowired
	ReviewDao reviewDao;
	@RequestMapping(value = command)
	public String doAction(@RequestParam("renum") int renum) {
		ReviewBean reviewBean = reviewDao.getReviewByRenum(renum);
		int cnt = reviewDao.deleteReview(renum); //리뷰 삭제 시킴
		
		if(cnt > 0) { 
			System.out.println("리뷰 삭제 성공");
		}
		int reviewCount = reviewDao.getTrainerReviewCount(reviewBean.getTid()); //트레이너의 리뷰 수
		if(reviewCount == 0) { //만약에 초기 값을 넣는다. 리뷰 없는 상태로 설정하는것.
			reviewDao.insertBaseValue(reviewBean.getTid());
		}
		return getPage;
	}
}
