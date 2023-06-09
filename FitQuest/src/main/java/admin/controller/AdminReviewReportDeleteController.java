package admin.controller;

import java.io.IOException;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import member.model.MemberBean;
import review.model.ReviewBean;
import review.model.ReviewDao;

@Controller
public class AdminReviewReportDeleteController {
	private final String command = "/adminReviewReportDelete.ad";
	private final String gotoPage = "redirect:/adminReviewReportList.ad";
	
	@Autowired
	ReviewDao reviewDao;
	
	@RequestMapping(command)
	public String delete(HttpSession session, @RequestParam("renum") int renum, HttpServletResponse response) {
		response.setContentType("text/html; charset=utf-8");
		session.setAttribute("destination", gotoPage);
		if(session.getAttribute("loginInfo") != null) {
			MemberBean memberBean = (MemberBean)session.getAttribute("loginInfo");
			if(memberBean.getId().equals("admin")) {
				ReviewBean reviewBean = reviewDao.getReviewByRenum(renum);
				int cnt = reviewDao.deleteReview(renum);
				if(cnt != -1) {
					System.out.println("처리 완료");
					int reviewCount = reviewDao.getTrainerReviewCount(reviewBean.getTid()); //트레이너의 리뷰 수
					if(reviewCount == 0) { //만약에 초기 값을 넣는다. 리뷰 없는 상태로 설정하는것.
						reviewDao.insertBaseValue(reviewBean.getTid());
					}
					return gotoPage;
				}
				else {
					System.out.println("처리 실패");
				}
			}
			else {
				try {
					response.getWriter().print("<script>alert('관리자 로그인이 필요합니다.');</script>");
					response.getWriter().flush();
				} catch (IOException e) {
					e.printStackTrace();
				}
				return "forward:/login.mb";
			}
		}
		else  {
			try {
				response.getWriter().print("<script>alert('로그인이 필요합니다.');</script>");
				response.getWriter().flush();
			} catch (IOException e) {
				e.printStackTrace();
			}
			return "forward:/login.mb";
		}
		return gotoPage;
	}
	
}
