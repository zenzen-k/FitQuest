package health.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import health.model.HealthBean;
import health.model.HealthDao;
import health.model.HealthDateBean;
import health.model.HealthDateDao;
import member.model.MemberBean;
import oracle.net.aso.h;
import trainer.model.TrainerBean;
import trainer.model.TrainerDao;
import usage.model.UsageBean;
import usage.model.UsageDao;

@Controller
public class MyHealthInsertController {
	private final String command = "myHealthInsert.ht";
	private final String getPage = "myHealthInsertForm";
	private final String gotoPage = "redirect:/myHealthList.ht";
	
	@Autowired
	HealthDateDao healthDateDao;
	
	@Autowired
	HealthDao healthDao;
	
	@Autowired
	TrainerDao trainerDao;
	
	@Autowired
	UsageDao usageDao;
	
	
	/* form으로 이동 */
	@RequestMapping(value = command, method = RequestMethod.GET)
	public ModelAndView doAction(HttpSession session, HttpServletResponse response) {
		
		ModelAndView mav = new ModelAndView();
		
		MemberBean memberBean = (MemberBean)session.getAttribute("loginInfo");
		
		if(memberBean == null) { // 로그인 정보 없을 때
			session.setAttribute("destination", "redirect:/myHealthInsert.ht");
			try {
				response.getWriter().print("<script>alert('로그인이 필요합니다.');</script>");
				response.getWriter().flush();
			} catch (IOException e) {
				e.printStackTrace();
			}
			mav.setViewName("redirect:/loginForm.mb");
		} else { // 로그인 정보 존재할때
			
			// 유저가 가지고 있는 사용권을 통해 트레이너 조회
			List<UsageBean> ulist = usageDao.getTListByMid(memberBean.getId());
			List<TrainerBean> tlist = new ArrayList<TrainerBean>();
			
			System.out.println("ulist : " + ulist);
			if(ulist != null) { // 사용권 잇으면 데이터 넣기
				for(UsageBean ub : ulist) {
					System.out.println("ulist tid : " + ub.getTid());
					TrainerBean trainerBean = trainerDao.getTrainerMember(ub.getTid());
					
					System.out.println("trainerBean id : " + trainerBean.getId());
					System.out.println("trainerBean name : " + trainerBean.getName());
					tlist.add(trainerBean);
				}
			}
			
			mav.addObject("tlist", tlist);
			mav.setViewName(getPage);
		}
		return mav;
	}
	
	/* 추가하기 */
	@RequestMapping(value = command, method = RequestMethod.POST)
	public ModelAndView doAction(HttpSession session, HttpServletRequest request,
								HealthDateBean hdb) {
		ModelAndView mav = new ModelAndView();
		MemberBean memberBean = (MemberBean)session.getAttribute("loginInfo");
		
		System.out.println("date:" + hdb.getHdate());
		System.out.println("tid:" + hdb.getTid());
		
		
		HealthDateBean healthDateBean = healthDateDao.getHealthByHdate(hdb.getHdate());
		
		if(healthDateBean == null) { // 날짜가 없으면 insert
			hdb.setId(memberBean.getId());
			int cnt = healthDateDao.insertHealthDate(hdb);
			
			if(cnt == -1) {
				System.out.println("hdate 삽입 실패");
				mav.setViewName(getPage);
			} else {
				// 삽입 성공하면 해당 날짜 번호 시퀀스를 얻기 위해서 날짜를 다시 가져온다.
				healthDateBean = healthDateDao.getHealthByHdate(hdb.getHdate());
				
				insertHealthRequest(request, healthDateBean, hdb.getHdate());
				mav.setViewName(gotoPage); // 리스트
			}
		} else {
			insertHealthRequest(request, healthDateBean, hdb.getHdate());
			mav.setViewName(gotoPage); // 리스트
		}
		
		return mav;
	}// 추가

	
	// 여러개 운동 삽입 처리
	private void insertHealthRequest(HttpServletRequest request, HealthDateBean healthDateBean, String hdate) {
		
		String[] hname = request.getParameterValues("hname");
		String[] starthour = request.getParameterValues("starthour");
		String[] startminute = request.getParameterValues("startminute");
		String[] endhour = request.getParameterValues("endhour");
		String[] endminute = request.getParameterValues("endminute");
		String[] hcount = request.getParameterValues("hcount");
		String[] hset = request.getParameterValues("hset");
		
		for(int i = 0; i < hname.length; i++) {
			HealthBean healthBean = new HealthBean();
			
			healthBean.setHnum(healthDateBean.getHnum());
			healthBean.setHname(hname[i]);
			healthBean.setStarttime(hdate + " " + starthour[i] + ":" + startminute[i]);
			healthBean.setEndtime(hdate + " " + endhour[i] + ":" + endminute[i]);
			healthBean.setHcount(Integer.parseInt(hcount[i]));
			healthBean.setHset(Integer.parseInt(hset[i]));
			
			int cnt2 = healthDao.insertHealth(healthBean);
			System.out.println("cnt2 : " + cnt2);
		}
		
	}
	
}
