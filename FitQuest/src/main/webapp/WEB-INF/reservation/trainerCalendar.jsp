<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../common/top.jsp" %>
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/reservationCalendarCSS.css?after"/>
<script type="text/javascript">
	function openPopup(tid,date,time,people,rstate,rnum) { //complete 팝업창 설정
		// 팝업 창의 URL과 창의 속성을 설정
	 	var url = "trainerCalendarDetail.rv?tid="+tid+"&date="+date+"&time="+time+"&people="+people;
	 	var width = 900; // 팝업 창의 너비
		var height = 600; // 팝업 창의 높이
		var left = (window.screen.availWidth - width) / 2; // 화면 중앙에 위치하도록 좌표 계산
		var top = (window.screen.availHeight - height) / 2;
		
		var popup = window.open(url, "_blank", "width=" + width + ",height=" + height + ",left=" + left + ",top=" + top);
		// 팝업 창이 로드된 후에 닫기 버튼 추가
		popup.onload = function () {
			 var closeButton = popup.document.createElement("button");
			 closeButton.innerText = "닫기";
			 closeButton.classList.add("close-button");
			 closeButton.addEventListener("click", function () {
				popup.close(); // 팝업 창 닫기
			 });
		
			// 예약 상태가 true라면 예약 취소 버튼 추가(예약 확정은 되었지만 운동 완료하지 않은 상태) complete 테이블의 값은 오늘 이전의 예약일 경우 삭제되어 상관 없음
			if (rstate == "true") {
				var cancelButton = popup.document.createElement("button");
				cancelButton.innerText = "예약 취소";
				cancelButton.classList.add("close-button");
				cancelButton.addEventListener("click", function () {
					var confirmCancel = popup.confirm("예약을 취소하시겠습니까?");
				
					if (confirmCancel) {
						popup.alert("예약 취소 완료되었습니다.");
						popup.close(); // 팝업 창 닫기
						window.location.href = "trainerCancel.rv?tid="+tid+"&date="+date+"&time="+time+"&people="+people;
					}
			  });
			
				// 버튼 간격 조절
				cancelButton.style.marginRight = "10px";
				
				popup.document.body.appendChild(cancelButton);
				closeButton.focus();
			}
			
			popup.document.body.appendChild(closeButton);
			closeButton.focus();
			popup.scrollTo(0, 0);
		};
	}
</script>
<body style="background-color: #FEF9E7; text-align: center;"> 
<!-- 타이틀 폰트 -->
<div class="calendarTitle">
	<div class="calendarTitle-font">My PT</div>
</div> 
<div class="calendar-container">
   <!-- 년/월 바꾸기 -->
   <div class="changeCalendar">
      <!-- 이전년 -->
      <a class="calendar_year" href="trainerCalendar.rv?year=${today_info.search_year-1}&month=${today_info.search_month-1}">
         &lt;&lt;
      </a> 
      <!-- 이전달 -->
      <a class="calendar_month" href="trainerCalendar.rv?year=${today_info.before_year}&month=${today_info.before_month}">
         &lt;
      </a> 
      <span class="this_month">
         &nbsp;${today_info.search_year}. 
         <c:if test="${today_info.search_month<10}">0</c:if>${today_info.search_month}
      </span>
      <!-- 다음달 -->
      <a class="calendar_month" href="trainerCalendar.rv?year=${today_info.after_year}&month=${today_info.after_month}">
         &gt;
      </a> 
         <!-- 다음년 -->
      <a class="calendar_year" href="trainerCalendar.rv?year=${today_info.search_year+1}&month=${today_info.search_month-1}">
         &gt;&gt;
      </a>
   </div>
<!-- 버튼 -->
<div class="calendar-button-container">
   <div class="calendar-button-div">
  	  <div class="left">
      	<c:if test="${updateFlag == 'true'}"> 
	      	<input type="button" class="btn btn-warning m-right" onClick="location.href='trainerScheChoose.rv'" value="스케줄 수정">
      	</c:if>
      	<c:if test="${insertFlag == 'true'}">
	      	<input type="button" class="btn btn-warning" onClick="location.href='tScheduleInsert.rv'" value="스케줄 설정">
      	</c:if>
  	  </div>
      <div class="right">
      	<input type="button" class="btn btn-warning" onClick="location.href='trainerReservation.rv'" value="예약 신청 내역">
      	<c:if test="${not empty rList}">
      		<input type="button" class="btn btn-warning" onClick="location.href='trainerStateList.rv'" value="예약 내역">
        </c:if>
      </div>
   </div>
</div>
<!-- 달력  -->  
<table class="calendar-body">
   <tr class="day-area">
      <td class="day sun" width="14%">
         일
      </td>
      <td class="day" width="14%">
         월
      </td>
      <td class="day" width="14%">
         화
      </td>
      <td class="day" width="14%">
         수
      </td>
      <td class="day" width="14%">
         목
      </td>
      <td class="day" width="14%">
         금
      </td>
      <td class="day sat" width="14%">
         토
      </td>
   </tr>
<c:if test="${empty rList}">
   <tr>
	 <td colspan="7" class="calendar-none">
	   <div>
	    <span>예약 내역이 없습니다.</span>
	   </div>
	 </td>
   </tr>
</c:if>
<c:if test="${not empty rList}">
   <tr>
	<c:forEach var="dateList" items="${dateList}" varStatus="date_status">
         <c:choose>
           <c:when test="${date_status.index % 7 == 6}">
			 <c:if test="${dateList.value == 'today'}">
		       <td class="t-calendar-box">
		     </c:if>
		     <c:if test="${dateList.value != 'today'}">  
		       <td class="calendar-box">
		     </c:if>
		        <div class="calendar-margin"><div class="calendar-num sat">${dateList.date}</div></div>
		        <c:if test="${dateList.date <= date_status.last}">
				 <c:set var="nowDay" value="${today_info.search_year}-${today_info.search_month}-${dateList.date}"/>
		        
		        		<c:if test="${not empty cList}">
						    <c:forEach var="citem" items="${cList}">
						        <c:if test="${citem.cpdate == nowDay}">
						            <a href="#" onclick="openPopup('${citem.tid}','${citem.cpdate}','${citem.cptime}','${citem.cpeople}','true',0); return false;">
						                <div class="rstate-container-t">
						                    <div class="center">
						                        <img src="<%=request.getContextPath()%>/resources/Icon/reservaionFull-icon.png" width="34px" class="icon">
						                    </div> 
						                    <div>
						                        <span class="calender-text-s b">
						                            <c:if test="${citem.cpeople > 1}">
						                                단체 ${citem.cpeople}인
						                            </c:if>
						                            <c:if test="${citem.cpeople == 1}">
						                                개인 &nbsp;&nbsp;&nbsp;
						                            </c:if>
						                        </span> 
						                        <span class="calender-text-s">${citem.cptime}</span>
						                    </div>
						                </div>
						            </a>
						        </c:if>
						    </c:forEach>
						</c:if>
						
						<c:if test="${not empty rList}">
					    <c:set var="printRtime" value=""/>
					    <c:set var="printPeople" value=""/>
					    <c:forEach var="ritem" items="${rList}"> 
					        <c:set var="matchFound" value="false" />
					        
					        <c:forEach var="citem" items="${cList}">
					            <c:if test="${citem.cpdate == nowDay && citem.cptime == ritem.rtime}">
					                <c:set var="matchFound" value="true" />
					            </c:if>
					        </c:forEach>
					        
					        <c:if test="${ritem.rdate == nowDay && matchFound == 'false'}">
					            <c:if test="${ritem.rtime != printRtime || ritem.people != printPeople}">
					                <a href="#" onclick="openPopup('${ritem.tid}','${ritem.rdate}','${ritem.rtime}','${ritem.people}','${ritem.rstate}','${ritem.rnum}'); return false;">
					                    <div class="rstate-container-t">
					                        <div class="center">
					                            <img src="<%=request.getContextPath()%>/resources/Icon/reservaionNotFull-icon.png" width="34px" class="icon">
					                        </div> 
					                        <div>
					                            <span class="calender-text-s b">단체 ${ritem.people}인</span> 
					                            <span class="calender-text-s">${ritem.rtime}</span>
					                        </div>
					                    </div>
					                </a>
					                <c:set var="printRtime" value="${ritem.rtime}"/>
					                <c:set var="printPeople" value="${ritem.people}"/>
					            </c:if>
					        </c:if>
					    </c:forEach>
					</c:if>
			       </c:if>
			    </td>
			</c:when>
            
            <c:when test="${date_status.index%7==0}">
    </tr>
    <tr>
    		<c:if test="${dateList.value == 'today'}">
		       <td class="t-calendar-box">
		     </c:if>
		     <c:if test="${dateList.value != 'today'}">  
		       <td class="calendar-box">
		     </c:if>
		        <div class="calendar-margin"><div class="calendar-num sun">${dateList.date}</div></div>
		        <c:if test="${dateList.date <= date_status.last}">
		            <c:set var="nowDay" value="${today_info.search_year}-${today_info.search_month}-${dateList.date}"/>
		        		<c:if test="${not empty cList}">
						    <c:forEach var="citem" items="${cList}">
						        <c:if test="${citem.cpdate == nowDay}">
						            <a href="#" onclick="openPopup('${citem.tid}','${citem.cpdate}','${citem.cptime}','${citem.cpeople}','true',0); return false;">
						                <div class="rstate-container-t">
						                    <div class="center">
						                        <img src="<%=request.getContextPath()%>/resources/Icon/reservaionFull-icon.png" width="34px" class="icon">
						                    </div> 
						                    <div>
						                        <span class="calender-text-s b">
						                            <c:if test="${citem.cpeople > 1}">
						                                단체 ${citem.cpeople}인
						                            </c:if>
						                            <c:if test="${citem.cpeople == 1}">
						                                개인 &nbsp;&nbsp;&nbsp;
						                            </c:if>
						                        </span> 
						                        <span class="calender-text-s">${citem.cptime}</span>
						                    </div>
						                </div>
						            </a>
						        </c:if>
						    </c:forEach>
						</c:if>
						
						<c:if test="${not empty rList}">
					    <c:set var="printRtime" value=""/>
					    <c:set var="printPeople" value=""/>
					    <c:forEach var="ritem" items="${rList}"> 
					        <c:set var="matchFound" value="false" />
					        
					        <c:forEach var="citem" items="${cList}">
					            <c:if test="${citem.cpdate == nowDay && citem.cptime == ritem.rtime}">
					                <c:set var="matchFound" value="true" />
					            </c:if>
					        </c:forEach>
					        
					        <c:if test="${ritem.rdate == nowDay && matchFound == 'false'}">
					            <c:if test="${ritem.rtime != printRtime || ritem.people != printPeople}">
					                <a href="#" onclick="openPopup('${ritem.tid}','${ritem.rdate}','${ritem.rtime}','${ritem.people}','${ritem.rstate}','${ritem.rnum}'); return false;">
					                    <div class="rstate-container-t">
					                        <div class="center">
					                            <img src="<%=request.getContextPath()%>/resources/Icon/reservaionNotFull-icon.png" width="34px" class="icon">
					                        </div> 
					                        <div>
					                            <span class="calender-text-s b">단체 ${ritem.people}인</span> 
					                            <span class="calender-text-s">${ritem.rtime}</span>
					                        </div>
					                    </div>
					                </a>
					                <c:set var="printRtime" value="${ritem.rtime}"/>
					                <c:set var="printPeople" value="${ritem.people}"/>
					            </c:if>
					        </c:if>
					    </c:forEach>
					</c:if>
			        </c:if>
			    </td>
            </c:when>
      </c:choose> 
            
      <c:if test="${ date_status.index % 7 != 6 && date_status.index % 7 != 0 }">
	  <c:if test="${dateList.value == 'today'}">
        <td class="t-calendar-box">
      </c:if>
      <c:if test="${dateList.value != 'today'}">  
        <td class="calendar-box">
	  </c:if>
      	<div> 
           <c:forEach var="dayIndex" items="월,화,수,목,금" varStatus="status">
		  	<c:if test="${date_status.index%7 == status.count}">
		        <div class="calendar-margin"><div class="calendar-num">${dateList.date}</div></div>
		          <c:if test="${dateList.date <= date_status.last}">
			            <c:set var="nowDay" value="${today_info.search_year}-${today_info.search_month}-${dateList.date}"/>
		        
		        		<c:if test="${not empty cList}">
						    <c:forEach var="citem" items="${cList}">
						        <c:if test="${citem.cpdate == nowDay}">
						            <a href="#" onclick="openPopup('${citem.tid}','${citem.cpdate}','${citem.cptime}','${citem.cpeople}','true',0); return false;">
						                <div class="rstate-container-t">
						                    <div class="center">
						                        <img src="<%=request.getContextPath()%>/resources/Icon/reservaionFull-icon.png" width="34px" class="icon">
						                    </div> 
						                    <div>
						                        <span class="calender-text-s b">
						                            <c:if test="${citem.cpeople > 1}">
						                                단체 ${citem.cpeople}인
						                            </c:if>
						                            <c:if test="${citem.cpeople == 1}">
						                                개인 &nbsp;&nbsp;&nbsp;
						                            </c:if>
						                        </span> 
						                        <span class="calender-text-s">${citem.cptime}</span>
						                    </div>
						                </div>
						            </a>
						        </c:if>
						    </c:forEach>
						</c:if>
						
						<c:if test="${not empty rList}">
					    <c:set var="printRtime" value=""/>
					    <c:set var="printPeople" value=""/>
					    <c:forEach var="ritem" items="${rList}"> 
					        <c:set var="matchFound" value="false" />
					        
					        <c:forEach var="citem" items="${cList}">
					            <c:if test="${citem.cpdate == nowDay && citem.cptime == ritem.rtime}">
					                <c:set var="matchFound" value="true" />
					            </c:if>
					        </c:forEach>
					        
					        <c:if test="${ritem.rdate == nowDay && matchFound == 'false'}">
					            <c:if test="${ritem.rtime != printRtime || ritem.people != printPeople}">
					                <a href="#" onclick="openPopup('${ritem.tid}','${ritem.rdate}','${ritem.rtime}','${ritem.people}','${ritem.rstate}','${ritem.rnum}'); return false;">
					                    <div class="rstate-container-t">
					                        <div class="center">
					                            <img src="<%=request.getContextPath()%>/resources/Icon/reservaionNotFull-icon.png" width="34px" class="icon">
					                        </div> 
					                        <div>
					                            <span class="calender-text-s b">단체 ${ritem.people}인</span> 
					                            <span class="calender-text-s">${ritem.rtime}</span>
					                        </div>
					                    </div>
					                </a>
					                <c:set var="printRtime" value="${ritem.rtime}"/>
					                <c:set var="printPeople" value="${ritem.people}"/>
					            </c:if>
					        </c:if>
					    </c:forEach>
					</c:if>
			        </c:if>
				</c:if>
           	  </c:forEach>
	       </div>
	     </td>
       </c:if>
     </c:forEach>
</c:if>
</table>
</div>
</body>
<%@ include file="../common/bottom.jsp" %>