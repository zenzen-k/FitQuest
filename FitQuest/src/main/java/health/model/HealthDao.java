package health.model;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class HealthDao {
	@Autowired
	SqlSessionTemplate sqlSessionTemplate;
	private String namespace = "health.model.Health";
	
	
	public List<HealthBean> getOneHealth(int hnum) {
		List<HealthBean> timelist = new ArrayList<HealthBean>();
		timelist = sqlSessionTemplate.selectList(namespace + ".GetOneHealth", hnum);
		return timelist;
	}


	public int insertHealth(HealthBean healthBean) {
		int cnt = -1;
		cnt = sqlSessionTemplate.insert(namespace + ".InsertHealth", healthBean);
		return cnt;
	}


	public int deleteHealth(Map<String, String> map) {
		int cnt = -1;
		cnt = sqlSessionTemplate.delete(namespace + ".DeleteHealth", map);
		return cnt;
	}


	public void deleteHealthByHnum(int hnum) {
		sqlSessionTemplate.delete(namespace + ".DeleteHealthByHnum", hnum);
		
	}


	

}
