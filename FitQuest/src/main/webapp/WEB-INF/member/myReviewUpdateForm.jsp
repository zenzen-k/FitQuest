<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../common/top.jsp"%>
<%@ include file="../common/adminBootTop.jsp"%>
<%@ include file="../common/myMemberTop.jsp"%>
<style type = "text/css">
	h2{
		font-weight:normal !important;
		color: #444444 !important;
	}
	.rating {
    float:left;
}
.rating:not(:checked) > input {
    position:absolute;
    top:-9999px;
    clip:rect(0,0,0,0);
}

.rating:not(:checked) > label {
    float:right;
    width:1em;
    padding:0 .1em;
    overflow:hidden;
    white-space:nowrap;
    cursor:pointer;
    font-size:200%;
    line-height:1.2;
    color:#ddd;
    text-shadow:1px 1px #bbb, 2px 2px #666, .1em .1em .2em rgba(0,0,0,.5);
}

.rating:not(:checked) > label:before {
    content: '★ ';
}

.rating > input:checked ~ label {
    color: #FAC710;
    text-shadow:1px 1px #c60, 2px 2px #940, .1em .1em .2em rgba(0,0,0,.5);
}

.rating:not(:checked) > label:hover,
.rating:not(:checked) > label:hover ~ label {
    color: gold;
    text-shadow:1px 1px goldenrod, 2px 2px #B57340, .1em .1em .2em rgba(0,0,0,.5);
}

.rating > input:checked + label:hover,
.rating > input:checked + label:hover ~ label,
.rating > input:checked ~ label:hover,
.rating > input:checked ~ label:hover ~ label,
.rating > label:hover ~ input:checked ~ label {
    color: #ea0;
    text-shadow:1px 1px goldenrod, 2px 2px #B57340, .1em .1em .2em rgba(0,0,0,.5);
}

.rating > label:active {
    position:relative;
    top:2px;
    left:2px;
}
.form-group{
	margin-bottom: 20px;
}
.err{
	color:red;
	font-weight:bold;
	font-size: 10px;
}
	section{
		padding: 0px !important;
		}
	.pageTitle{
		margin-top: 50px;
		margin-bottom: 50px;
	}
</style>
<script>
	function checkRating(){
		if(reviewBean.rating.value == ""){
			alert("리뷰 별점 선택하세요.");
			return false;
		}
		if(reviewBean.rtitle.value == ""){
			alert("리뷰 제목 입력하세요.");
			return false;
		}
		if(reviewBean.rcontent.value == ""){
			alert("리뷰 내용 입력하세요.");
			return false;
		}
	}
</script>
<body style="background-color : #FEF9E7;">
<section id="blog" class="blog">
    <div class="pagetitle">
      <h1>리뷰 수정</h1>
    </div><!-- End Page Title -->
    
	<div class="container" data-aos="fade-up">

        <div class="row" style = "justify-contents: center;">
	      <div class ="col-lg-1"></div>  	
          <div class="col-lg-10 entries"  style = "padding: 0px;background-color: white;">
   			<article class="entry entry-single" style = "margin:0px;">
   			 <div class="col-lg-12">
			        <div class="col-lg-12 col-sm-12 hero-feature">
			        
			        	<div class="reply-form">
		                <h4>리뷰 내용 :</h4>
		                <p>*모든 내용을 작성하세요</p>
		                <form:form commandName = "reviewBean" action="updateMyReview.mb" method = "post">
		                	<input type = "hidden" name = "renum" value = "${reviewBean.renum }">
		                	<input type = "hidden" name = "mid" value = "${memberBean.id }">
		                	<input type = "hidden" name = "tid" value = "${trainerBean.id }">
		                	<input type = "hidden" name = "hasReview" value = "Y">
		                	<input type = "hidden" name = "report" value = "N">
		                  <div class="row">
		                    <div class="col-md-6 form-group">
		                      <input name="id" type="text" class="form-control" value = "작성자 : ${memberBean.id } 회원님" disabled>
		                    </div>
		                    <div class="col-md-6 form-group box">
		                    	<fieldset class="rating">
								    <input type="radio" id="star5" name="rating" value="5" 
								    <c:if test = "${reviewBean.rating eq 5 }">
								    checked
								    </c:if>
								    /><label for="star5">5 stars</label>
								    <input type="radio" id="star4" name="rating" value="4" 
								    <c:if test = "${reviewBean.rating eq 4 }">
								    checked
								    </c:if>
								    /><label for="star4">4 stars</label>
								    <input type="radio" id="star3" name="rating" value="3" 
								    <c:if test = "${reviewBean.rating eq 3 }">
								    checked
								    </c:if>
								    /><label for="star3">3 stars</label>
								    <input type="radio" id="star2" name="rating" value="2" 
								    <c:if test = "${reviewBean.rating eq 1 }">
								    checked
								    </c:if>
								    /><label for="star2">2 stars</label>
								    <input type="radio" id="star1" name="rating" value="1" 
								    <c:if test = "${reviewBean.rating eq 1 }">
								    checked
								    </c:if>
								    /><label for="star1">1 star</label>
			                    	<span style = "font-size: 20px;">별점 선택 : </span>
								</fieldset>
							</div>
		                  </div>
		                  <div class="row">
		                    <div class="col form-group">
		                      <input type="text" name = "rtitle" class="form-control" placeholder="${reviewBean.rtitle }">
							  <form:errors cssClass="err" path = "rtitle"/>
		                    </div>
		                  </div>
		                  <div class="row">
		                    <div class="col form-group">
		                      <textarea name="rcontent" class="form-control" placeholder="${reviewBean.rcontent }" rows="5" cols="50"></textarea>
							  <form:errors cssClass="err" path = "rcontent"/>
		                    </div>
		                  </div>
		                  <button type="submit" class="btn btn-warning" onClick = "return checkRating()">리뷰 남기기</button>
		                  <button type="reset" class="btn btn-primary">초기화</button>
		                </form:form>
		              </div>
			        </div>
			 </div>
			</article>
		 </div>
		 <div class ="col-lg-1"></div>
		</div>
	</div>
</section>
</body>
<%@ include file="../common/myMemberBot.jsp"%>
<%@ include file="../common/adminBootBottom.jsp"%>
<%@ include file="../common/bottom.jsp"%>