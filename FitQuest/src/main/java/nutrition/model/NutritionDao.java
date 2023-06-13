package nutrition.model;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class NutritionDao {
	@Autowired
	SqlSessionTemplate sqlSessionTemplate;
	
	private String namespace = "nutrition.model.Nutrition";

	public List<String> getNutritionDate(Map<String, String> map) {
		List<String> dateList = new ArrayList<String>();
		dateList = sqlSessionTemplate.selectList(namespace + ".GetNutritionDate", map);
		return dateList;
	}
}
