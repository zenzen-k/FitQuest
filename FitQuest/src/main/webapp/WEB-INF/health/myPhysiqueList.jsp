<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!-- myPhysiqueList -->
<%@ include file="../common/top.jsp"%>
<%@ include file="../common/adminBootTop.jsp"%>
<%@ include file="myHealthTop.jsp"%>

<style>
	table{
		text-align: center;
		margin: auto;
	}
	td, tr{
		height: 40px;
		width: 40px;
	}
	.daySun{
		color: red;
	}
	.daySat{
		color: blue;
	}
	.dayOn:hover{
		background-color: #FAC710 ;
	}
	.dayOn:active{
		background-color: #f9a61a ;
	}
	.dayOn:visited{
		background-color: #FAC710 ;
	}
	.dayCheck{
		background-color: #FEF9E7;
	}
	.topMar{
		margin-top: 20px;
	}
	.inbodyBtnDiv{
		float: right;
	}
	.fe {
	    position: absolute;
	    right: 0px;
	    top: 15px;
	}
	.ie {
	    color: #aab7cf;
	    padding-right: 20px;
	    padding-bottom: 5px;
	    transition: 0.3s;
	    font-size: 16px;
	}
</style>

<script type="text/javascript" src="resources/js/jquery.js"></script>
<script>
	$(document).ready(function(){
		calenderLookup();
		getGraphAll();
	});

	function calenderLookup() {
		var sYear = $('#selectYear option:selected').val();
		var sMon = $('#selectMon option:selected').val();
		
		//alert(sYear);
		//alert(sMon);
		
		$.ajax({
			type : "POST",
			url : "myPhysiqueList.ht",
			data : ({'selectYear' : sYear, 'selectMon' : sMon}),
			dataType : "json",
			success : function (data) {
				$('#calenderTable').empty(); // calenderTable div 내용 비우기

				var msg = '<table><tr><td class="daySun">일</td><td>월</td><td>화</td><td>수</td><td>목</td><td>금</td><td class="daySat">토</td></tr>';
				
				for(var i=0; i<data.length -1; i++){
					if(i == 0){
						for(var j=0; j<data[i].date; j++){
							msg += '<td> </td>';
						}
					}
					
					if(data[i].date == 0){
						msg += '</tr><tr>';
					}
					
					var strDate = "";
					if(i+1 < 10){
						strDate = "0" + (i+1);
					}else{
						strDate = (i+1);
					}
					
					
					var dateL = data[data.length -1].dateList;
					
					if(dateL == 'noData'){
						if(data[i].date == 0){
							msg += "<td class='daySun dayOn ' onclick='dateClick("+(i+1)+")'>" + (i+1) + "</td>";
						}else if(data[i].date == 6){
							msg += "<td class='daySat dayOn ' onclick='dateClick("+(i+1)+")'>" + (i+1) + "</td>";
						}else{
							msg += "<td class='dayOn ' onclick='dateClick("+(i+1)+")'>" + (i+1) + "</td>";
						}
					}else{
						
						if(dateL.indexOf(strDate) != -1){
							if(data[i].date == 0){
								msg += "<td class='daySun dayOn dayCheck' onclick='dateClick("+(i+1)+")'>" + (i+1) + "</td>";
							}else if(data[i].date == 6){
								msg += "<td class='daySat dayOn dayCheck' onclick='dateClick("+(i+1)+")'>" + (i+1) + "</td>";
							}else{
								msg += "<td class='dayOn dayCheck' onclick='dateClick("+(i+1)+")'>" + (i+1) + "</td>";
							}
						}else{
							if(data[i].date == 0){
								msg += "<td class='daySun dayOn ' onclick='dateClick("+(i+1)+")'>" + (i+1) + "</td>";
							}else if(data[i].date == 6){
								msg += "<td class='daySat dayOn ' onclick='dateClick("+(i+1)+")'>" + (i+1) + "</td>";
							}else{
								msg += "<td class='dayOn ' onclick='dateClick("+(i+1)+")'>" + (i+1) + "</td>";
							}
						}
					}
					
				}// for
				
				msg += '</tr></table>';
				
				$("#calenderTable").append(msg);
			}
		}); // ajax
	}
	
	
	/* 날짜 상세 정보*/
	function dateClick(day){
		
		//alert(day);
		var sYear = $('#selectYear option:selected').val();
		var sMon = $('#selectMon option:selected').val();
		//var sday = day;
		
		$.ajax({
			type : "POST",
			url : "myPhysiqueDetail.ht",
			data : ({"selectDay" : day, "selectYear" : sYear, "selectMon" : sMon}),
			dataType : "json",
			success : function (data) {
				// alert(data);
				
				var msg = "";
				var phdate = "";
				//alert(sYear + "-" + sMon+ "-" day);
				
				if(data.returnData == 'idNull'){
					$('#detailDiv').empty();
					alert('로그인이 필요합니다.');
					location.href='login.mb';
				}else if(data.returnData == 'BeanNull'){
					$('#detailDiv').empty();
					msg = "<h5 align='center'>등록된 신체 정보가 없습니다.<input type='button' onclick='insertPhysique("+sYear+","+sMon+","+day+")' value='추가하기' class='btn btn-warning rounded-pill btn-sm' style='float:right;'></h5>";
				}else{
					$('#detailDiv').empty();
					msg += "<h5>" + data.phdate + "<input type='button' value='삭제' onclick='deletePhysique("+data.phnum+")' class='btn btn-warning rounded-pill btn-sm' style='float:right;'>";
					msg += "<input type='button' value='수정' onclick='updatePhysique("+data.phnum+")' class='btn btn-warning rounded-pill btn-sm' style='float:right; margin-right: 10;'></h5>";
					msg += '<div class="row" style="margin-top: 20px;">';
					msg += '<div class="col-lg-3 col-md-4 label ">이름</div>';
					msg += '<div class="col-lg-3 col-md-4">' + data.name + ' 님</div>';
					msg += '</div>';
					msg += '<div class="row" style="margin-top: 20px;">';
					msg += '<div class="col-lg-3 col-md-4 label ">신장</div>';
					msg += '<div class="col-lg-3 col-md-4">' + data.height + ' cm</div>';
					msg += '<div class="col-lg-3 col-md-4 label ">체중</div>';
					msg += '<div class="col-lg-3 col-md-4">' + data.weight + ' kg</div>';
					msg += '</div>';
					msg += '<div class="row" style="margin-top: 20px;">';
					msg += '<div class="col-lg-3 col-md-4 label ">BMI</div>';
					msg += '<div class="col-lg-3 col-md-4">' + data.bmi + '</div>';
					msg += '<div class="col-lg-3 col-md-4 label ">골격근량</div>';
					msg += '<div class="col-lg-3 col-md-4">' + data.skeletalmuscle + ' kg</div>';
					msg += '</div>';
					msg += '<div class="row" style="margin-top: 20px;">';
					msg += '<div class="col-lg-3 col-md-4 label ">체지방률</div>';
					msg += '<div class="col-lg-3 col-md-4">' + data.bodyfatper + ' %</div>';
					msg += '<div class="col-lg-3 col-md-4 label ">기초대사량</div>';
					msg += '<div class="col-lg-3 col-md-4">' + data.bmr + ' kcal</div>';
					msg += '</div><div class="topMar"><input type="hidden" id="phimage" name="phimage" value="'+data.phimage+'">';
					msg += '<input type="button" value="인바디 정보" onclick="showImg()" class="btn btn-outline-warning rounded-pill btn-sm inbodyBtnDiv"></div>';
				}
				
				$("#detailDiv").append(msg);
			}
			
		}); // ajax
	}
	
	function insertPhysique(y, m, d) {
		//alert(y + "," + m + "," + d);
		var phdate = y + "," + m + "," + d; 
		//alert(phdate);
		location.href="myPhysiqueInsert.ht?phdate=" + phdate;
	}
	
	function deletePhysique(phnum) {
		//alert(phnum);
		location.href="myPhysiqueDelete.ht?phnum=" + phnum;
	}
	
	function updatePhysique(phnum) {
		//alert(phnum);
		location.href="myPhysiqueUpdate.ht?phnum=" + phnum;
	}
	
	function showImg() {
		var phimage = $('#phimage').val();
		//alert(phimage);
		
		// undefined
		window.open('pop.ht?phimage=' + phimage,'팝업','width=500,height=700');
	}
	
	function getGraphAll(){
		
		var weightData = [];
		var skmuscleData = [];
		var bodyfatperData = [];
		var Date = [];
		
		
		$.ajax({
			url : "myPhysiqueGraph.ht",
			type : "GET",
			dataType : "json",
			success : function (data) {
				
				for(i=0; i<data.length; i++){
					weightData.push(data[i].weight);
					skmuscleData.push(data[i].skeletalmuscle);
					bodyfatperData.push(data[i].bodyfatper);
					Date.push(data[i].phdate);
				}
				
				new ApexCharts(document.querySelector("#lineChart"), {
					series: [{
						name: "체중(kg)",
						data: weightData
					}, {
						name: "골격근량(kg)",
						data: skmuscleData
					}, {
						name: "체지방률(%)",
						data: bodyfatperData
					}],
					chart: {
						height: 350,
						type: 'area',
						toolbar: {
							show: false
						},
					},
					markers: {
						size: 4
					},
					colors: ['#4154f1', '#2eca6a', '#ff771d'],
					fill: {
						type: "gradient",
						gradient: {
							shadeIntensity: 1,
							opacityFrom: 0.3,
							opacityTo: 0.4,
							stops: [0, 90, 100]
						}
					},
					dataLabels: {
						enabled: false
					},
					stroke: {
						curve: 'smooth',
						width: 2
					},
					xaxis: {
						categories: Date,
					}
				}).render();
			} //success
		}); //ajax
		
	} //getGraphAll
	
	function getGraphWeight(){
		
		var weightData = [];
		var Date = [];
		
		$.ajax({
			url : "myPhysiqueGraph.ht",
			type : "GET",
			dataType : "json",
			success : function (data) {
				
				for(i=0; i<data.length; i++){
					weightData.push(data[i].weight);
					Date.push(data[i].phdate);
				}

				
				new ApexCharts(document.querySelector("#lineChart"), {
					series: [{
						name: "체중(kg)",
						data: weightData
					}],
					chart: {
						height: 350,
						type: 'area',
						toolbar: {
							show: false
						},
					},
					markers: {
						size: 4
					},
					colors: ['#4154f1', '#2eca6a', '#ff771d'],
					fill: {
						type: "gradient",
						gradient: {
							shadeIntensity: 1,
							opacityFrom: 0.3,
							opacityTo: 0.4,
							stops: [0, 90, 100]
						}
					},
					dataLabels: {
						enabled: false
					},
					stroke: {
						curve: 'smooth',
						width: 2
					},
					xaxis: {
						categories: Date,
					}
				}).render();
			} //success
		}); //ajax
	} // getGraphWeight
	
	function getGraphSkmuscle(){
		var skmuscleData = [];
		var Date = [];
		
		$.ajax({
			url : "myPhysiqueGraph.ht",
			type : "GET",
			dataType : "json",
			success : function (data) {
				
				for(i=0; i<data.length; i++){
					skmuscleData.push(data[i].skeletalmuscle);
					Date.push(data[i].phdate);
				}
				
				new ApexCharts(document.querySelector("#lineChart"), {
					series: [{
						name: "골격근량(kg)",
						data: skmuscleData
					}],
					chart: {
						height: 350,
						type: 'area',
						toolbar: {
							show: false
						},
					},
					markers: {
						size: 4
					},
					colors: ['#4154f1', '#2eca6a', '#ff771d'],
					fill: {
						type: "gradient",
						gradient: {
							shadeIntensity: 1,
							opacityFrom: 0.3,
							opacityTo: 0.4,
							stops: [0, 90, 100]
						}
					},
					dataLabels: {
						enabled: false
					},
					stroke: {
						curve: 'smooth',
						width: 2
					},
					xaxis: {
						categories: Date,
					}
				}).render();
			} //success
		}); //ajax
	} // getGraphSkmuscle
	
	function getGraphBodyfatper(){
		var bodyfatperData = [];
		var Date = [];
		
		$.ajax({
			url : "myPhysiqueGraph.ht",
			type : "GET",
			dataType : "json",
			success : function (data) {
				
				for(i=0; i<data.length; i++){
					bodyfatperData.push(data[i].bodyfatper);
					Date.push(data[i].phdate);
				}
				
				new ApexCharts(document.querySelector("#lineChart"), {
					series: [{
						name: "체지방률(%)",
						data: bodyfatperData
					}],
					chart: {
						height: 350,
						type: 'area',
						toolbar: {
							show: false
						},
					},
					markers: {
						size: 4
					},
					colors: ['#4154f1', '#2eca6a', '#ff771d'],
					fill: {
						type: "gradient",
						gradient: {
							shadeIntensity: 1,
							opacityFrom: 0.3,
							opacityTo: 0.4,
							stops: [0, 90, 100]
						}
					},
					dataLabels: {
						enabled: false
					},
					stroke: {
						curve: 'smooth',
						width: 2
					},
					xaxis: {
						categories: Date,
					}
				}).render();
			} //success
		}); //ajax
	} // getGraphBodyfatper
	
	
	function graphAll() {
		//alert(1);
		$('#my-graph').empty();
		$('#my-graph').html('<h5 class="card-title">전체보기</h5><div id="lineChart"></div>');
		getGraphAll();
	}
	
	function graphW() {
		$('#my-graph').empty();
		$('#my-graph').html('<h5 class="card-title">체중 변화</h5><div id="lineChart"></div>');
		getGraphWeight();
	}
	
	function graphS() {
		$('#my-graph').empty();
		$('#my-graph').html('<h5 class="card-title">골격근량 변화</h5><div id="lineChart"></div>');
		getGraphSkmuscle();
	}
	
	function graphB() {
		$('#my-graph').empty();
		$('#my-graph').html('<h5 class="card-title">체지방률 변화</h5><div id="lineChart"></div>');
		getGraphBodyfatper();
	}
</script>

<%
	Date now = new Date();
%>

<body style="background-color: #FEF9E7">
	<div class="pagetitle">
		<h1>
			<i class="bi bi-list toggle-sidebar-btn"></i> 신체정보
		</h1>
		<nav>
			<ol class="breadcrumb">
				<li class="breadcrumb-item"><a href="health.ht">Home</a></li>
				<li class="breadcrumb-item active">신체정보</li>
			</ol>
		</nav>
	</div>

	<div class="row">
		<div class="col-lg-12">
			<!-- Default Card -->
			<div class="card">
				<div class="card-body">
					<h5 class="card-title">신체정보</h5>
					
					<div class="row">
					
					<div class="col-lg-5">
						
						<div style="margin: auto; text-align: center;">
							<select name="selectYear" id="selectYear">
								<c:forEach var="i" begin="<%=now.getYear() + 1890%>" end="<%=now.getYear() + 1900%>">
									<option value="${i}" <c:if test="${i == selectYear}">selected</c:if>>${i}</option>
								</c:forEach>
							</select> 년
							
							<select name="selectMon" id="selectMon">
								<c:forEach var="i" begin="1" end="12">
									<option value="${i}" <c:if test="${i == selectMon}">selected</c:if>>${i}</option>
								</c:forEach>
							</select> 월
							
							<input type="button" value="조회" onclick="calenderLookup()" class="btn btn-warning rounded-pill btn-sm">
						</div>
						
						<div id="calenderTable">
							<table>
								<tr>
									<td class="daySun">일</td>
									<td>월</td>
									<td>화</td>
									<td>수</td>
									<td>목</td>
									<td>금</td>
									<td class="daySat">토</td>
								</tr>
								<tr>
									<c:forEach var="i" items="${dateMap}" varStatus="status">
										<c:if test="${status.index == 0}">
											<c:forEach var="j" begin="0" end="${i.value - 1}">
												<td></td>
											</c:forEach>
										</c:if>
										<c:if test="${i.value == 0}">
											</tr>
											<tr>
										</c:if>
										
										<c:if test="${i.value == 0}">
											<td class='daySun dayOn <c:if test="${fn:contains(dateList, i.key)}">dayCheck</c:if>' onclick="dateClick('${i.key}')">${i.key}</td>
										</c:if>
										<c:if test="${i.value == 6}">
											<td class='daySat dayOn <c:if test="${fn:contains(dateList, i.key)}">dayCheck</c:if>' onclick="dateClick('${i.key}')">${i.key}</td>
										</c:if>
										<c:if test="${i.value != 0 and i.value != 6}">
											<td class='dayOn <c:if test="${fn:contains(dateList, i.key)}">dayCheck</c:if>' onclick="dateClick('${i.key}')">${i.key}</td>
										</c:if>
										
									</c:forEach>
								</tr>
							</table>
						</div>
						
					</div>
					
					
					<!-- 상세정보 -->
					<div class="col-lg-7">
						<div id="detailDiv">
							<div  style="text-align: center;">조회할 날짜를 클릭하세요</div>
						</div><!-- detailDiv -->
					</div><!-- 8 -->
					
					</div><!-- row -->
				</div>
			</div>
		</div>

		<div class="col-12">
			<!-- Default Card -->
			<div class="card">
			
				<!-- 버튼 -->
				 
				<div class="filter fe">
					<a class="icon ie" href="#" data-bs-toggle="dropdown"><i class="bi bi-three-dots"></i></a>
					<ul class="dropdown-menu dropdown-menu-end dropdown-menu-arrow">
						<li class="dropdown-header text-start">
							<h6>필터선택</h6>
						</li>
						<li><a class="dropdown-item" href="javascript:graphAll()">전체보기</a></li>
						<li><a class="dropdown-item" href="javascript:graphW()">체중 변화</a></li>
						<li><a class="dropdown-item" href="javascript:graphS()">골격근량 변화</a></li>
						<li><a class="dropdown-item" href="javascript:graphB()">체지방률 변화</a></li>
					</ul>
				</div>
				
				
				<div class="card-body" id="my-graph">
					<h5 class="card-title">전체보기</h5>
					<!-- chart -->
					<div id="lineChart"></div>
				</div>
			</div>
		</div>

	</div>
	<!-- row -->

</body>
<%@ include file="myHealthBottom.jsp"%>
<%@ include file="../common/adminBootBottom.jsp"%>
<%@ include file="../common/bottom.jsp"%>