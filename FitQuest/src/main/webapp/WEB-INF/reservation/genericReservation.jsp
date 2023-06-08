<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../common/top.jsp" %>
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/reservationCalendarCSS.css">

<script type="text/javascript" src="resources/js/jquery.js" ></script>
<script type="text/javascript">
	$(document).ready(function(){
		
	});
	function reservationCheck(date,time,year,month){
		if (confirm('예약 하시겠습니까?')) { //확인
			location.href='reservationInsert.rv?date='+date+'&time='+time+'&year='+year+'&month='+month;
		    alert('예약 완료되었습니다.');
		} else { //취소
		    alert('예약 취소되었습니다.');
		}
	}
</script>

<br><br>
<center>
<form action="" method="GET">
<script type="text/javascript">showCalendar(nowd,nowm,nowy);</script>

<!-- 타이틀 폰트 -->
<div class="calendarTitle">
	<div class="calendarTitle-font">예약</div>
	<div class="calendarSubtitle-font">김려원 트레이너님 스케줄</div>
</div> 


<div class="calendar" >
   <!-- 년/월 바꾸기 -->
   <div class="changeCalendar">
      <!-- 이전년 -->
      <a class="calendar_year" href="genericReservation.rv?year=${today_info.search_year-1}&month=${today_info.search_month-1}">
         &lt;&lt;
      </a> 
      <!-- 이전달 -->
      <a class="calendar_month" href="genericReservation.rv?year=${today_info.before_year}&month=${today_info.before_month}">
         &lt;
      </a> 
      <span class="this_month">
         &nbsp;${today_info.search_year}. 
         <c:if test="${today_info.search_month<10}">0</c:if>${today_info.search_month}
      </span>
      <!-- 다음달 -->
      <a class="calendar_month" href="genericReservation.rv?year=${today_info.after_year}&month=${today_info.after_month}">
         &gt;
      </a> 
         <!-- 다음년 -->
      <a class="calendar_year" href="genericReservation.rv?year=${today_info.search_year+1}&month=${today_info.search_month-1}">
         &gt;&gt;
      </a>
   </div>
<!-- 달력  -->  
<table class="calendar_body">
<thead>
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
</thead>
<tbody>
   <tr>
	<c:forEach var="dateList" items="${dateList}" varStatus="date_status">
         <c:choose>
         
         	<c:when test="${not empty tsyear}">  
           		<td class="calendar-box">
					<div class="calendar-margin"><div class="calendar-num">${dateList.date}</div></div>
					<c:forEach var="i" begin="0" end="${fn:length(tsyear)-1}">
						<c:if test="${tsyear[i] == today_info.search_year && tsmonth[i] == today_info.search_month && tsday[i] == dateList.date}">
							<div class="reservation-area">
							<img src="<%=request.getContextPath()%>/resources/Icon/impossible.png" width="20px">
							<span class="calender-text">휴무</span>
							</div>
						</c:if>
					</c:forEach>
			   	</td>
            </c:when>
            
            <c:when test="${date_status.index%7==6}">
               <td class="calendar-box">
     				<div class="calendar-margin"><div class="calendar-num sat">${dateList.date}</div></div>
    				<c:forEach var="day" items="${tsdayArr}">
		               <c:if test="${day eq '토'}">  
		               		<c:if test="${dateList.date <= date_status.last}">
		                  
		                  	<c:forEach var="time" items="${tstimeArr}">
		                  	<div class="reservation-area">
		                  	<img src="<%=request.getContextPath()%>/resources/Icon/possible.png" width="20px">
		                  	<a href="" class="calender-text" onClick="reservationCheck('${dateList.date}','${time}','${today_info.search_year}','${today_info.search_month}')">
		                    	<span>${time}</span>
		                    </a>
	                     	</div>
	                     	</c:forEach>
	                     	
	                     	</c:if>
		               </c:if>
		            </c:forEach>
               </td>
            </c:when>
            
            <c:when test="${date_status.index%7==0}">
    </tr>
    <tr>
		      <td class="calendar-box">
     				<div class="calendar-margin"><div class="calendar-num sun">${dateList.date}</div></div>
    				<c:forEach var="day" items="${tsdayArr}">
		               <c:if test="${day eq '일'}">
		               		<c:if test="${dateList.date <= date_status.last}">
		                  
		                  	<c:forEach var="time" items="${tstimeArr}">
		                  	<div class="reservation-area"> 
		                  	<img src="<%=request.getContextPath()%>/resources/Icon/possible.png" width="20px">
		                     <a href="" class="calender-text" onClick="reservationCheck('${dateList.date}','${time}','${today_info.search_year}','${today_info.search_month}')">
		                     <span>${time}</span> 
		                     </a>
	                     	</div>
	                     	</c:forEach>
	                     	
	                     	</c:if>
		               </c:if>
		            </c:forEach>
               </td>
            </c:when>
            
      <c:otherwise>
	  <td class="calendar-box">
      	<div> 
		<c:choose>
           <c:when test="${date_status.index%7==1}">
         	  <div class="calendar-margin"><div class="calendar-num">${dateList.date}</div></div>
    				<c:forEach var="day" items="${tsdayArr}">
		               <c:if test="${day eq '월'}">
		                  	<c:if test="${dateList.date <= date_status.last}">
		                  	
		                  	<c:forEach var="time" items="${tstimeArr}">
		                  	<div class="reservation-area"> 
		                  	<img src="<%=request.getContextPath()%>/resources/Icon/possible.png" width="20px">
		                     <a href="" class="calender-text" onClick="reservationCheck('${dateList.date}','${time}','${today_info.search_year}','${today_info.search_month}')">
		                     <span>${time}</span>
		                     </a>
	                     	</div>
	                     	</c:forEach>
	                     	
	                     	</c:if>
		               </c:if>
		            </c:forEach>
           </c:when>
           <c:when test="${date_status.index%7==2}">
         	  <div class="calendar-margin"><div class="calendar-num">${dateList.date}</div></div>
    				<c:forEach var="day" items="${tsdayArr}">
		               <c:if test="${day eq '화'}">
             		 	    <c:if test="${dateList.date <= date_status.last}">
		                  
		                  	<c:forEach var="time" items="${tstimeArr}">
		                  	<div class="reservation-area"> 
		                  	<img src="<%=request.getContextPath()%>/resources/Icon/possible.png" width="20px">
		                     <a href="" class="calender-text" onClick="reservationCheck('${dateList.date}','${time}','${today_info.search_year}','${today_info.search_month}')">
		                     <span>${time}</span>
		                     </a>
	                     	</div>
	                     	</c:forEach>
	                     	
	                     	</c:if>
		               </c:if>
		            </c:forEach>
           </c:when>
           <c:when test="${date_status.index%7==3}">
         	  <div class="calendar-margin"><div class="calendar-num">${dateList.date}</div></div>
    				<c:forEach var="day" items="${tsdayArr}">
		               <c:if test="${day eq '수'}">
		               		<c:if test="${dateList.date <= date_status.last}">
		                  
		                  	<c:forEach var="time" items="${tstimeArr}">
		                  	<div class="reservation-area"> 
		                  	<img src="<%=request.getContextPath()%>/resources/Icon/possible.png" width="20px">
			                    <a href="" class="calender-text" onClick="reservationCheck('${dateList.date}','${time}','${today_info.search_year}','${today_info.search_month}')">
			                    <span>${time}</span>
			                    </a>
	                     	</div>
	                     	</c:forEach>
	                     	
	                     	</c:if>
		               </c:if>
		            </c:forEach>
           </c:when>
           <c:when test="${date_status.index%7==4}">
         	  <div class="calendar-margin"><div class="calendar-num">${dateList.date}</div></div>
    				<c:forEach var="day" items="${tsdayArr}">
		               <c:if test="${day eq '목'}">
		               		<c:if test="${dateList.date <= date_status.last}">
		                  
		                  	<c:forEach var="time" items="${tstimeArr}">
		                  	<div class="reservation-area"> 
			                  	<img src="<%=request.getContextPath()%>/resources/Icon/possible.png" width="20px">
			                    <a href="" class="calender-text" onClick="reservationCheck('${dateList.date}','${time}','${today_info.search_year}','${today_info.search_month}')">
			                    <span>${time}</span>
			                    </a>
	                     	</div>
	                     	</c:forEach>
	                     	
	                     	</c:if>
		               </c:if>
		            </c:forEach>
           </c:when>
           <c:when test="${date_status.index%7==5}">
         	  <div class="calendar-margin"><div class="calendar-num">${dateList.date}</div></div>
    				<c:forEach var="day" items="${tsdayArr}">
		               <c:if test="${day eq '금'}">
							<c:if test="${dateList.date <= date_status.last}">
									                  	
		                  	<c:forEach var="time" items="${tstimeArr}">
		                  	<div class="reservation-area"> 
		                  	<img src="<%=request.getContextPath()%>/resources/Icon/possible.png" width="20px">
		                     <a href="" class="calender-text" onClick="reservationCheck('${dateList.date}','${time}','${today_info.search_year}','${today_info.search_month}')">
		                     <span>${time}</span>
		                     </a>
	                     	</div>
	                     	</c:forEach>
	                     	
	                     	</c:if>
		               </c:if>
		            </c:forEach>
           </c:when>
     	</c:choose>
     	
     	
       </div>
      </td>
      </c:otherwise>
      </c:choose>
	</c:forEach>
</tbody>
</table>
</div>
</form>
</center>

<%@ include file="../common/bottom.jsp" %>