package health.model;

import org.hibernate.validator.constraints.NotBlank;

public class HealthDateBean {

	private int hnum;
	private String id;
	@NotBlank(message = "운동 날짜 필수 입력")
	private String hdate;
	private String playtime;
	private String tid;
	private String tname;
	private String tactivity;
	private String ptype;

	public String getPtype() {
		return ptype;
	}

	public void setPtype(String ptype) {
		this.ptype = ptype;
	}

	public int getHnum() {
		return hnum;
	}

	public void setHnum(int hnum) {
		this.hnum = hnum;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getHdate() {
		return hdate;
	}

	public void setHdate(String hdate) {
		this.hdate = hdate;
	}

	public String getPlaytime() {
		return playtime;
	}

	public void setPlaytime(String playtime) {
		this.playtime = playtime;
	}

	public String getTid() {
		return tid;
	}

	public void setTid(String tid) {
		this.tid = tid;
	}

	public String gettname() {
		return tname;
	}

	public void settname(String tname) {
		this.tname = tname;
	}

	public String gettactivity() {
		return tactivity;
	}

	public void settactivity(String tactivity) {
		this.tactivity = tactivity;
	}

}
