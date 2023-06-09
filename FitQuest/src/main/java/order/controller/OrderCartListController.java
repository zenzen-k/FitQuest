package order.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import gym.model.GymBean;
import gym.model.GymDao;
import member.model.MemberBean;
import member.model.MemberDao;
import product.model.MyCartList;
import product.model.MyShoppingBean;
import product.model.ProductBean;
import product.model.ProductDao;
import review.model.ReviewDao;
import trainer.model.TrainerBean;
import trainer.model.TrainerDao;

@Controller
public class OrderCartListController {
	private final String command = "cartList.od";
	private final String getPage = "myCartList";
	@Autowired
	MemberDao memberDao;
	@Autowired
	ProductDao productDao;
	@Autowired
	TrainerDao trainerDao;
	@Autowired
	GymDao gymDao;
	@Autowired
	ReviewDao reviewDao;

	@RequestMapping(value = command)
	public String doAction(HttpSession session, Model model,
						   HttpServletResponse response) {
		MemberBean memberBean1 = (MemberBean)session.getAttribute("loginInfo"); 
		response.setContentType("text/html; charset=utf-8");
		if(memberBean1 == null) {
			session.setAttribute("destination", "redirect:/viewMyOrderList.od");
			try {
				response.getWriter().print("<script>alert('로그인이 필요합니다.');</script>");
				response.getWriter().flush();
			} catch (IOException e) {
				e.printStackTrace();
			}
			return "forward:/login.mb";
		} else if(!memberBean1.getMtype().equals("generic")){
			try {
				response.getWriter().print("<script>alert('비정상적인 접근입니다.');</script>");
				response.getWriter().flush();
			} catch (IOException e) {
				e.printStackTrace();
			}
			return "forward:/main.go";
		}
		ArrayList<MyShoppingBean> sList = new ArrayList<MyShoppingBean>();
		MyCartList cartList = (MyCartList)session.getAttribute("cartList");
		if(cartList != null) {
			List<Integer> pnumList = cartList.getOrderList();
			int totalAmount = 0;
			int minPrice = 9999;
			int maxPrice = 0;
			int minpnum = 0;
			int maxpnum = 0;
			for(int pnum : pnumList) {
				String tid = productDao.getIdByPnum(pnum);
				TrainerBean trainerBean = trainerDao.getTrainer(tid);
				MemberBean memberBean = memberDao.selectMemberById(tid);
				GymBean gymBean = gymDao.selectGym(trainerBean.getGnum());
				ProductBean productBean = productDao.getProductByPnum(pnum);
				String hasReview = reviewDao.getHasReviewById(tid);
				double rating = 0.0;
				if(hasReview.equals("Y")) {
					rating = reviewDao.getAverageReviewScore(tid);
				}
				MyShoppingBean msBean = new MyShoppingBean();
				msBean.setTid(tid);
				msBean.setTname(memberBean.getName());
				msBean.setActivity(trainerBean.getActivity());
				msBean.setPurpose(trainerBean.getPurpose());
				msBean.setTimage(trainerBean.getTimage());
				msBean.setGname(gymBean.getGname());
				msBean.setGaddr1(gymBean.getGaddr1());
				msBean.setGaddr2(gymBean.getGaddr2());
				msBean.setPnum(productBean.getPnum());
				msBean.setPrice(productBean.getPrice());
				msBean.setMonths(productBean.getMonths());
				msBean.setPcount(productBean.getPcount());
				msBean.setPtype(productBean.getPtype());
				msBean.setPeople(productBean.getPeople());
				msBean.setRating(rating);
				msBean.setHasReview(hasReview);
				sList.add(msBean);
				totalAmount += productBean.getPrice();
				
				int currPrice = (int)(((double)productBean.getPrice()/(double)productBean.getPcount())*10000);
				
				System.out.println("getPrice : " + productBean.getPrice());
				System.out.println("getPcount : " + productBean.getPcount());
				System.out.println("currPrice : " + currPrice);
				if(currPrice > maxPrice) {
					minpnum = productBean.getPnum();
					maxPrice = currPrice;
				} 
				if(currPrice < minPrice) {
					maxpnum = productBean.getPnum();
					minPrice = currPrice;
				}
			}
			model.addAttribute("sList", sList);
			session.setAttribute("sList", sList);
			model.addAttribute("totalAmount", totalAmount);
			model.addAttribute("minPrice", minPrice);
			model.addAttribute("maxPrice", maxPrice);
			model.addAttribute("maxpnum", maxpnum);
			model.addAttribute("minpnum", minpnum);
		}
		return getPage;
	}
}
