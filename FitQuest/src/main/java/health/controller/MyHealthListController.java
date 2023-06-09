package health.controller;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import health.model.HealthDao;
import health.model.HealthDateBean;
import health.model.HealthDateDao;
import member.model.MemberBean;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import trainer.model.TrainerBean;
import trainer.model.TrainerDao;
import usage.model.UsageBean;
import usage.model.UsageDao;

@Controller
public class MyHealthListController {
	private final String command = "myHealthList.ht";
	private final String getPage = "myHealthList";
	
	@Autowired
	HealthDao healthDao;
	
	@Autowired
	HealthDateDao healthDateDao;
	
	@Autowired
	TrainerDao trainerDao;
	
	@Autowired
	UsageDao usageDao;
	
	// 운동 목록 불러오기
	@RequestMapping(value = command, method = RequestMethod.GET)
	public ModelAndView doAction(HttpSession session, HttpServletResponse response) {
		response.setContentType("text/html; charset=UTF-8");
		ModelAndView mav = new ModelAndView();
		
		MemberBean memberBean = (MemberBean)session.getAttribute("loginInfo");
		session.setAttribute("menubar", "myHealth");
		session.setAttribute("topmenu", "healthList");
		
		
		// 로그인 정보 확인
		if(memberBean == null) { 
			session.setAttribute("destination", "redirect:/myHealthList.ht");
			try {
				response.getWriter().print("<script>alert('로그인이 필요합니다.');location.href='login.mb'</script>");
				response.getWriter().flush();
			} catch (IOException e) {
				e.printStackTrace();
			}
			//mav.setViewName(gotoPage);
		}else {
			String mid = memberBean.getId();
			
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("id", mid);
			
			// 운동 날짜 불러옴
			List<HealthDateBean> hdlist = healthDateDao.getMyHealthDateList(map);
			
			List<HealthDateBean> tlist = healthDateDao.getTrainerList(mid);
		  
			mav.addObject("tlist", tlist);
			mav.addObject("hdlist", hdlist);
			mav.setViewName(getPage);
		}
		return mav;
	} // doAction - list
	
	
	@RequestMapping(value = command, method = RequestMethod.POST, produces = "application/text; charset=utf8")
	@ResponseBody
	public String doAction(HttpSession session, HttpServletResponse response,
								@RequestParam(value="tid") String tid) {

		response.setContentType("text/html; charset=UTF-8");
		
		System.out.println("hi");
		
		ModelAndView mav = new ModelAndView();
		JSONArray jsArr = new JSONArray();
		MemberBean memberBean = (MemberBean)session.getAttribute("loginInfo");
		
		// 로그인 정보 확인
		if(memberBean == null) { 
			session.setAttribute("destination", "redirect:/myHealthList.ht");
			try {
				response.getWriter().print("<script>alert('로그인이 필요합니다.');location.href='login.mb'</script>");
				response.getWriter().flush();
			} catch (IOException e) {
				e.printStackTrace();
			}
			//mav.setViewName(gotoPage);
		}else {
			String mid = memberBean.getId();
			
			System.out.println("id:" + mid + ", tid:" + tid);
			
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("id", mid);
			map.put("tid", tid);
			
			List<HealthDateBean> hdlist = healthDateDao.getMyHealthDateList(map);
			
			int i = 0;
			for(HealthDateBean hdb : hdlist) {
				JSONObject jsObject = new JSONObject();
				jsObject.put("id", hdb.getId());
				jsObject.put("hdate", hdb.getHdate());
				jsObject.put("hnum", hdb.getHnum());
				jsObject.put("tid", hdb.getTid());
				jsObject.put("tactivity", hdb.gettactivity());
				jsObject.put("tname", hdb.gettname());
				jsObject.put("playtime", hdb.getPlaytime());
				jsArr.add(i, jsObject);
				i++;
			}
		}	
		return jsArr.toString();
	}
}