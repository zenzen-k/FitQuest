package product.model;

import java.util.ArrayList;
import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class ProductDao {
	private final String namespace = "product.model.Product";
	@Autowired
	SqlSessionTemplate sqlSessionTemplate;
	public List<ProductBean> getProductListById(String id) {
		List<ProductBean> pList = new ArrayList<ProductBean>();
		pList = sqlSessionTemplate.selectList(namespace + ".GetProductListById", id);
		return pList;
	}
	public String getIdByPnum(int pnum) {
		String id = sqlSessionTemplate.selectOne(namespace + ".GetIdByPnum", pnum);
		return id;
	}
	public ProductBean getProductByPnum(int pnum) {
		ProductBean productBean = sqlSessionTemplate.selectOne(namespace + ".GetProductByPnum", pnum);
		return productBean;
	}
	public int deleteProduct(int pnum) {
		int cnt = sqlSessionTemplate.delete(namespace+ ".DeleteProduct", pnum);
		return cnt;
	}
	public int updateProduct(ProductBean productBean) {
		int cnt = sqlSessionTemplate.update(namespace + ".UpdateProduct", productBean);
		return cnt;
	}
	public int insertProduct(ProductBean productBean) {
		int cnt = sqlSessionTemplate.insert(namespace + ".InsertProduct", productBean);
		return cnt;
	}
}
