<%
/******************************************
   name :  /entry/entry_list.jsp
   auth :  elTOV
   date :  2018.02.23
   desc :  
*******************************************/
%>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="com.shoes.comm.CommUtil" %>
<%@ page import="com.shoes.admin.kiosk.KioskMgr" %>
<%@ page import="com.shoes.admin.kiosk.KioskInfo" %>
<%@ page import="com.shoes.admin.entry.EntryMgr" %>
<%@ page import="com.shoes.admin.entry.EntryInfo" %>
<%@ include file="../include/config.jsp" %>
<%@ include file="../include/config_date.jsp" %>
<%@ include file="../include/logincheck.jsp" %>
<%@ include file="../include/config_cate.jsp" %>

<%

request.setCharacterEncoding("UTF-8");

NumberFormat mc = NumberFormat.getNumberInstance();

CommUtil cutil = new CommUtil();

String entry_pageno = cutil.getCheckNull(request.getParameter("entry_pageno"));
String entry_pagesize = cutil.getCheckNull(request.getParameter("entry_pagesize"));
String kiosk_pageno = cutil.getCheckNull(request.getParameter("kiosk_pageno"));
String kiosk_pagesize = cutil.getCheckNull(request.getParameter("kiosk_pagesize"));

int i = 0, i_page = 1, j = 0;
int i_pagesize = 5;
int i_totalcount = 0, i_pagecount = 10;

int k = 0, k_page = 1;
int k_pagesize = 5;
int k_kiosk_totalcount = 0, k_pagecount = 10;

if(entry_pagesize.equals("")) entry_pagesize = "5";
if(kiosk_pagesize.equals("")) kiosk_pagesize = "5";

if(!entry_pageno.equals("")) try{ i_page = Integer.parseInt(entry_pageno); }catch(Exception e){ i_page = 1; }
if(!entry_pagesize.equals("")) try{ i_pagesize = Integer.parseInt(entry_pagesize); }catch(Exception e){ i_pagesize = 5; }
if(!kiosk_pageno.equals("")) try{ k_page = Integer.parseInt(kiosk_pageno); }catch(Exception e){ k_page = 1; }
if(!kiosk_pagesize.equals("")) try{ k_pagesize = Integer.parseInt(kiosk_pagesize); }catch(Exception e){ k_pagesize = 5; }


String gl_page_main_code = "ENTRY";
String gl_page_sub_code = "";


//페이징 처리 변수
String id_for_kiosklist = "kiosk";
String id_for_entrylist = "entry";

//통계 데이터 적용 데이터 변수
String entry_all_text = "";
String entry_all_value = "";
String entry_today_text = "";
String entry_today_value = "";
String entry_gender_text = "";
String entry_gender_value = "";
String entry_age_text = "";
String entry_age_value = "";
String entry_day_value = "";
String chart_entry_id = "";

//kiosk entry 적용 배열 변수
String entry_list = "";
String kiosk_list = "";
String status_list = "";

//당첨자 뽑는 변수
String entry_sch_eday = "";

//당첨자 테이블 사용 배열
int [] arr_size = {1,2,3,35,4,45,5,55,6,65,7,75,8,85,9,95,10,105,11,115,12,125,13,14};
//String [] arr_size_title = {"1","2","3","3.5","4","4.5","5","5.5","6","6.5","7","7.5","8","8.5","9","9.5","10","10.5","11","11.5","12","12.5","13","14"};

KioskMgr amgr = new KioskMgr();
EntryMgr emgr = new EntryMgr();
KioskInfo ainfo = new KioskInfo();
EntryInfo einfo = new EntryInfo();
EntryInfo ginfo = new EntryInfo();
EntryInfo finfo = new EntryInfo();

ArrayList kiosklist = new ArrayList();
ArrayList <EntryInfo> entryList= new ArrayList<EntryInfo>();
ArrayList <EntryInfo> entryAllStatis= new ArrayList<EntryInfo>();
ArrayList <EntryInfo> entryTodayStatis= new ArrayList<EntryInfo>();
ArrayList <EntryInfo> kiosk_entryList= new ArrayList<EntryInfo>();

entryAllStatis = emgr.getEntryAllStatis();
entryTodayStatis = emgr.getEntryTodayStatis();
i_totalcount = emgr.getEntryListCnt();
k_kiosk_totalcount = emgr.getKioskListCnt();
i_pagecount = (int)((i_totalcount - 1)/i_pagesize) + 1;
k_pagecount = (int)((k_kiosk_totalcount - 1)/k_pagesize) + 1;
entryList = emgr.getEntryList(i_page,i_pagesize);
kiosklist = emgr.getKioskList(k_page,k_pagesize);
kiosk_entryList = emgr.getKioskEntryList();

for(int q = 0; q < 1; q++){
	einfo = entryList.get(0);
	chart_entry_id = einfo.getEntry_id();
}
ginfo = emgr.getEntryGenderStatis(chart_entry_id);
finfo = emgr.getEntryAgeStatis(chart_entry_id);

%>

<%

//성별 통계 데이터
entry_gender_text += "'MALE'" + "," + "'FEMALE'" ;
entry_gender_value += ginfo.getM_cnt() + "," + ginfo.getF_cnt() ;

//나이대별 통계 데이터
entry_age_text += "'10'" + "," + "'20'" + "," + "'30'" + "," + "'40'" + "," + "'50'" ;
entry_age_value += finfo.getTen_cnt() + "," + finfo.getTwenty_cnt() + "," + finfo.getThirty_cnt() + "," + finfo.getForty_cnt() + "," + finfo.getFifty_cnt() ;

//전체 통계 데이터
for(int h = 0; h < entryAllStatis.size(); h++){
	einfo = entryAllStatis.get(h);
	
	if(h == entryAllStatis.size()-1){
		entry_all_text += "'" + einfo.getEntry_name() + "'" ;
		entry_all_value += einfo.getTotal_cnt() ;
	}else{
		entry_all_text += "'" + einfo.getEntry_name() + "'" + ",";
		entry_all_value += einfo.getTotal_cnt() + ",";
	}
}

//오늘 통계 데이터
for(int t = 0; t < entryTodayStatis.size(); t++){
	einfo = entryTodayStatis.get(t);

	if(einfo.getTotal_cnt().equals("0")){
		continue;
	}

	if(t == entryTodayStatis.size()-1){
		entry_today_text += "'" + einfo.getEntry_name() + "'" ;
		entry_today_value += einfo.getTotal_cnt() ;
	}else{
		entry_today_text += "'" + einfo.getEntry_name() + "'" + ",";
		entry_today_value += einfo.getTotal_cnt() + ",";
	}
}

%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="description" content="">
  <meta HTTP-EQUIV="CACHE-CONTROL" CONTENT="NO-CACHE">
  <meta name="author" content="ThemeBucket">  
  <title><%=gl_top_title_admin%></title>
  <!--Core CSS -->
  <link href="../include/js/bs3/css/bootstrap.min.css" rel="stylesheet">
  <link href="../include/js/jquery-ui/jquery-ui-1.10.1.custom.min.css" rel="stylesheet">
  <link href="../include/css/bootstrap-reset.css" rel="stylesheet">
  <link href="../include/font-awesome/css/font-awesome.css" rel="stylesheet">
  <!-- Custom styles for this template -->
  <link href="../include/css/style.css" rel="stylesheet">
  <link href="../include/css/style-responsive.css" rel="stylweesheet"/>

  <script src="../include/js/commlang.js"></script><!--언어팩-->
  <script src="../include/js/jquery.js"></script><!--j쿼리-->
  <script src="../include/js/jquery-ui/jquery-ui-1.10.1.custom.min.js"></script> <!--j쿼리ui-->
  <script src="../include/js/bs3/js/bootstrap.min.js"></script> <!--부트스트랩-->
  <script src="../include/js/jquery.dcjqaccordion.2.7.js"></script> <!--매뉴 효과--> 
  <script src="../include/js/jquery.nicescroll.js"></script> <!--매뉴 효과-->
  <script src="../include/js/jquery.scrollTo/jquery.scrollTo.js"></script>  <!--스크롤 기능-->
  <script src="../include/js/scripts.js"></script>  <!--함수를 빼놓은 부분-->
  <script src="../include/js/mobile/jquery.ui.touch-punch.js"></script>  <!--모바일에서의 모션을 감지하는 스크립트-->	
  <!--달력, 통합함수-->
  <script src="../include/js/eltov/graphMethod.js"></script>
  <link rel="stylesheet" href="../include/js/datepic/BeatPicker.min.css" type="text/css">
  <script src="../include/js/datepic/BeatPicker.min.js"></script>
  <!--select 박스-->
  <link href="../include/js/iCheck/skins/minimal/minimal.css" rel="stylesheet">
  <link href="../include/js/iCheck/skins/flat/blue.css" rel="stylesheet">
  <script src="../include/js/iCheck/jquery.icheck.js"></script> 
  <!--뷰 fancybox(2015버전)-->
  <link rel="stylesheet" href="../include/js/fancy/jquery.fancybox.css?v=2.1.5" type="text/css" media="screen" />
  <script type="text/javascript" src="../include/js/fancy/jquery.fancybox.pack.js?v=2.1.5"></script>

  <!--on-off버튼-->
  <script src="../include/js/bootstrap-switch.js"></script>
  <link rel="stylesheet" href="../include/css/bootstrap-switch.css" /> 
  <link href="../include/js/iCheck/skins/flat/green.css" rel="stylesheet"/>

  <!--그래프 js-->
  <script src="../include/js/eltov/graphMethod_shin.js"></script> <!--신세계 전용 파일-->
  <script src="../include/js/chart/Chart.js"></script>
  <script src="../include/js/chart/Chart.Bar.js"></script>
  <script src="../include/js/chart/Chart.Line.js"></script>
  <script src="../include/js/chart/Chart.PolarArea.js"></script>
  <script src="../include/js/chart/Chart.Radar.js"></script>
  <script src="../include/js/chart/Chart.HorizontalBar.js"></script>
  <script src="../include/js/chart/Chart.Doughnut.js"></script>
  <script src="../include/js/chart/morris.js"></script>
  <script src="../include/js/chart/raphael-min.js"></script>
  <script src="../include/js/eltov/html2canvas.js"></script>
</head>
<body>

<script>
  //시작과 동시에 로딩화면 보여주는 부분
  $(window).load(function(){
      setTimeout(function(){
          $('#loading').hide();
      },<%=gl_loading_time%>);
  });
</script>

<div id="loading">
  <img id="loading-image" src="../images/loading.gif" alt="Loading..." />
</div>

<section id="container">
<!--header start-->
<%@ include file="../include/commtop.jsp" %>
<!--header end-->

<!--left start-->
<%@ include file="../include/commleft.jsp" %>
<!--left end-->

<!--main content start-->
<section id="main-content">
  <section class="wrapper">
    <div class="col-md-12">

      <!--리스트 영역 시작-->
      <section class="panel">
        <header class="panel-heading">
          <span class="fa fa-play-circle-o" style="color:;"></span>&nbsp;
          <strong>Device List</strong>
        </header>
        <div class="panel-body">
          <div class="col-md-12">
            <table id="dataTalbe" class="table table-striped" style="border:1px solid #DDDDDD">
              <thead>
                <tr class="eve">
                  <th style="width:5%">No</th>
                  <th style="width:10%">Status</th>
				  <th style="width:20%">Open</th>
                  <th style="width:30%">Name</th>
                  <th style="width:30%">Entry</th>
                  <th>&nbsp;</th>
                </tr>
              </thead>
              <tbody>
			    <form name="frmkioskupdate" method="post" action="entry_action.jsp" enctype="multipart/form-data">
		   	    <input type="hidden" value="" id="kiosk_id" name="kiosk_id">
			    <input type="hidden" id="entry_id" value="" name="entry_id">
			    <input type="hidden" id="status_id" value="" name="entry_status">
			    <input type='hidden' value='KIOSKUPDATE'  name="mode"/>
				<input type='hidden' value='' id='open_status_id'  name="open_status"/>
				
<%
for(i=0; i<kiosklist.size(); i++){
    ainfo = (KioskInfo)kiosklist.get(i);
%>
				<input type="hidden" value="" id="kiosk_id<%=ainfo.getKiosk_id()%>" >
				<input type="hidden" id="entry_id<%=ainfo.getKiosk_id()%>" value="" >
                <tr class="oddo" style="background-color:#FDFDFD;">
                  <td style="vertical-align:middle;"><%=(i + 1)%></td>
                  <td style="vertical-align:middle;"><input type="checkbox" name="kiosk_status" id="status_id<%=ainfo.getKiosk_id()%>" class="switch-small" checked data-on-label="Nomarl" data-off-label="Entry" /></td>
<!-- 				  체크박스 시작				   -->
				  <td style="vertical-align:middle;">
				  <div class="row" style="vertical-align:middle;">
					<div class="col-md-4" style="width:100%;">
					  <div class="minimal single-row">
						<div class="checkbox">
						  <span style="display: inline-block">
							<label style="display:inline-block;float:left;padding-top:1px">&nbsp;</label>
							<input type="checkbox" id="open_checkbox_id<%=ainfo.getKiosk_id()%>" value="" <%=(ainfo.getOpen_status().equals("O"))?"checked":""%>>
						  </span>
						</div>
					  </div>
					</div>
				  </div>
				  </td>
<!-- 				  체크박스 종료				   -->
                  <td style="vertical-align:middle;"><%=cutil.getCheckEditValue(ainfo.getKiosk_name())%></td>            
				  <td>
				    <select id="entry_select<%=ainfo.getKiosk_id()%>" value="<%=cutil.getCheckNull(ainfo.getEntry_name())%>" class="form-control" aria-controls="dynamic-table" style="cursor:pointer">
					  <option value="0">=============</option>
<%
for(j=0; j<kiosk_entryList.size(); j++){
    einfo = kiosk_entryList.get(j);
%>      
                      <option value="<%=einfo.getEntry_id()%>"><%=einfo.getEntry_name()%></option>
                    
<%
}
%>
					</select>
                  </td>
                  <td style="vertical-align:middle;">
                    <button type="button" class="btn btn-warning btn-xs tooltips" onclick="setKioskUpdateCheck(<%=ainfo.getKiosk_id()%>)">Save</button>
                  </td>
                </tr>
				</form>
<%
	if(ainfo.getEntry_id().equals("") || ainfo.getEntry_id().equals("0")){
		entry_list += "0" + ",";
	}else{
		entry_list += ainfo.getEntry_id() + ",";
	}
	if(ainfo.getKiosk_id().equals("")){
		kiosk_list += kiosk_list + ",";
	}else{
		kiosk_list += ainfo.getKiosk_id() + ",";
	}
	if(ainfo.getKiosk_sect().equals("")){
		status_list += status_list + ",";
	}else{
		status_list += ainfo.getKiosk_sect() + ",";
	}
}
%>
              </tbody>
            </table>
          </div> 
		<!--페이징 시작 -->
        <div class="col-md-2" style="text-align:left;">
          <span style="color:#999999;font-size:12px;">Total</span> <strong><%=k_kiosk_totalcount%></strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          <span style="color:#999999;font-size:12px;">Page</span> <strong><%=k_page%></strong>/<strong><%=k_pagecount%></strong>
        </div>

	    <div class="col-md-10" style="text-align:right;padding-bottom:7px;">
	      <%=cutil.getListEntryPage(k_page,k_pagesize,k_pagecount,"",id_for_kiosklist)%>
	    </div>
		<!--페이징 종료 -->
        </div>
      </section>

      <!--리스트 영역 종료-->
      <br><br>
      <!--리스트 영역 시작-->
      <section class="panel">
        <header class="panel-heading">
          <span class="fa fa-play-circle-o" style="color:;"></span>&nbsp;
          <strong>Entry List</strong>
          <span style="float:right;"><button type="button" class="btn btn-danger btn-xs tooltips" onclick="setShowCreateModal()">Create</button></span>
        </header>
        <div class="panel-body">
          <div class="col-md-12">
            <table id="dataTalbe2" class="table table-striped" style="border:1px solid #DDDDDD">
              <thead>
                <tr class="eve">
                  <th style="width:5%">No</th>
                  <th style="width:10%">Status</th>
                  <th style="width:40%">Name</th>
                  <th style="width:20%">Period</th>
                  <th style="width:10%">Count</th>
                  <th>&nbsp;</th>
                </tr>
              </thead>
              <tbody>
<%
for(i=0; i<entryList.size(); i++){
    einfo = entryList.get(i);

%>
				<form id="frmsetwinner" action="entry_win.jsp">
				<input type="hidden" id="winner_id" value="<%=einfo.getWinner_choice()%>" name="winner_choice">
				<input type="hidden" id="winner_entry_id" value="" name="entry_id">
				</form>
                <tr class="oddo" style="background-color:#FDFDFD;">
                  <td><%=(i + 1)%></td>
                  <td>진행</td>
                  <td><%=einfo.getEntry_name()%></td>
                  <td><%=einfo.getSch_sday().substring(0,4) + "." + einfo.getSch_sday().substring(4,6) + "." + einfo.getSch_sday().substring(6,8) %> ~ <%=einfo.getSch_eday().substring(0,4) + "." + einfo.getSch_eday().substring(4,6) + "." + einfo.getSch_eday().substring(6,8) %></td>
                  <td><%=einfo.getTotal_cnt()%></td>
                  <td>
                    <button type="button" class="btn btn-warning btn-xs tooltips" onclick="setShowInfoModal(<%=einfo.getEntry_id()%>)" >Information</button>
                    <button type="button" id="winner_btn" style="" class="btn btn-success btn-xs tooltips" onclick="setWinEntry(<%=einfo.getEntry_id()%>)">WinnerDraw</button>
					<button type="button" id="winner_list_btn" style="display:none;" class="btn btn-success btn-xs tooltips" onclick="getWinEntryList(<%=einfo.getEntry_id()%>)">WinnerList</button>
                  </td>
                </tr>

<%
entry_sch_eday = einfo.getSch_eday().substring(0,4) + einfo.getSch_eday().substring(4,6) + einfo.getSch_eday().substring(6,8);
}
%>
              </tbody>
            </table>
          </div> 
		<!--페이징 시작 -->
<!--         <div class="col-md-2" style="text-align:left;"> -->
<!--           <span style="color:#999999;font-size:12px;">Total</span> <strong><%=i_totalcount%></strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; -->
<!--           <span style="color:#999999;font-size:12px;">Page</span> <strong><%=i_page%></strong>/<strong><%=i_pagecount%></strong> -->
<!--         </div> -->
<!-- 	    <div class="col-md-10" style="text-align:right;padding-bottom:7px;"> -->
<!-- 	      <%=cutil.getListEntryPage(i_page,i_pagesize,i_pagecount,"",id_for_entrylist)%> -->
<!-- 	    </div> -->
		<!--페이징 종료 -->
        </div>
      </section>

      <!--리스트 영역 종료-->
    </div>

    <div class="col-md-6">
      <section class="panel">
        <header class="panel-heading">
          <span class="fa fa-play-circle-o" style="color:;"></span>&nbsp;
          <strong>Entries by Gender</strong> 
        </header>
        <div class="panel-body" style="">
          <div id='guide01' class='guide-shin'> </div>
          <canvas id='chart01' class='chart-js-shin' height="250" width="300" style="width: 300px; height: 250px;"></canvas>
        </div>
      </section>
    </div>

    <div class="col-md-6">
      <section class="panel">
        <header class="panel-heading">
          <span class="fa fa-play-circle-o" style="color:;"></span>&nbsp;
          <strong>Entries by Age</strong> 
        </header>
        <div class="panel-body" style="">
          <div id='guide02' class='guide-shin'> </div>
          <canvas id='chart02' class='chart-js-shin' height='250px'> </canvas>
        </div>
      </section>
    </div>

<!--     <div class="col-md-12"> -->
<!--       <section class="panel"> -->
<!--         <header class="panel-heading"> -->
<!--           <span class="fa fa-play-circle-o" style="color:;"></span>&nbsp; -->
<!--           <strong>날짜별 응모횟수</strong>  -->
<!--         </header> -->
<!--         <div class="panel-body" style="height:360px"> -->
<!-- 		  <div style="font-size:20px;"id='id_month'></div> -->
<!--           <div id='guide03' class='guide-shin'> </div> -->
<!--           <canvas id='chart03' class='chart-js-shin' height='350px' width='650px'> </canvas> -->
<!--         </div> -->
<!--       </section> -->
<!--     </div> -->

  </section>
</section>
<!--main content end-->

<!--right start-->
<%@ include file="../include/commright.jsp" %>
<!--right end-->

</section>

<!--entry 등록 팝업-->
<div>
<form name="frmwrite" method="post" action="entry_action.jsp" enctype="multipart/form-data">
  <div id='myModal' class='modal fade' tabindex='-1' role='dialog' aria-hidden='true'>
    <div class='modal-dialog'>
      <div class='modal-content'>
        <div class='modal-header'>
          <button class='close' data-dismiss='modal' aria-hidden='true'>&times;</button>
          <h5 class='modal-title'><span class="fa fa-github-alt"></span>&nbsp;&nbsp;<strong>Entry Register</strong></h5>
        </div>
		
        <div class='modal-body row'>
		  <input type="hidden" id="id_mode" name="mode" value="">
		  <div id='showDetails' ></div>
<!--           <div class='col-md-6 img-modal'> -->
<!--             <p class='mtop10'><strong>File Name : </strong><span class='junkname'></span></p> -->
<!--             <p><strong>File Type : </strong><span class='junkext'></span></p> -->
<!--           </div> -->
          <div class='col-md-12'>
            <div class='form-group'>
              <label>Entry name</label>
              <input id='id_entry_name_1' name="con_name" value='Please enter the EntryName' onkeydown='myKeyDown(this)' class='form-control'>
            </div>
                       
            <div class='form-group'>
              <label>Entry Date</label>
                <div class="row" style="margin-bottom:10px;" >
                  <div class="col-md-12">
                    <div class="input-group date">
                      <input type="text" name="sch_sday" value="" size="5" class="form-control" readonly="reeadonly" data-beatpicker="true" data-beatpicker-id="myPicker" data-beatpicker-module="today,clear" style="cursor:pointer;background-color:#ffffff;text-align:center;" id="id_sch_sday_1" />
                        <span class="input-group-addon" style="background:#1FB5AD">
                          <span class="fa fa-minus" style="color:white"></span>
                        </span>
                      <input type="text" name="sch_eday" value="" size="5" class="form-control" readonly="reeadonly" data-beatpicker="true" data-beatpicker-id="myPickers" data-beatpicker-module="today,clear" style="cursor:pointer;background-color:#ffffff;text-align:center;"  id="id_sch_eday_1"/>
					  <span class="input-group-addon" style="background:#1FB5AD;">
                        <span class="fa" style="color:white">OpenDate</span>
                      </span>
                      <input type="text" name="sch_oday" value="" size="5" class="form-control" readonly="reeadonly" data-beatpicker="true" data-beatpicker-id="myPickers" data-beatpicker-module="today,clear" style="cursor:pointer;background-color:#ffffff;text-align:center;"  id="id_sch_oday_1"/>
                    </div> 
                  </div>
                </div>
            </div>
            <div class='row'> </div>

			<div class='form-group'>
			  <span class='input-group size'> </span>
			  <div>
			    <label>Name</label>
			    <input class="form-control" value="Please enter the Name" type="text" id="id_shoes_name_1" name="shoes_name" onkeydown='myKeyDown(this)'>
			  </div>	
            </div>
			
			<div class='form-group'>
		      <span class='input-group size'> </span>
			  <div>
			    <label>Price</label>
			    <input class="form-control" value="Please enter the Price" type="text" id="id_shoes_price_1" name="shoes_price" onkeydown='myKeyDown(this)'>
			  </div>
			</div>

	  	    <div class='form-group'>
			  <span class='input-group size'> </span>
		      <div>
		        <label>Explan</label>
		        <input class="form-control" value="Please enter the Explan" type="text" id="id_shoes_explan_1" name="shoes_explan" onkeydown='myKeyDown(this)'>
	          </div>
		    </div>

			<!-- 슈즈리스트 시작 -->
			<div class='form-group'>
			<label>Amount</label>
<!-- 			  <label style='color:#01DF3A'>Shoes Size List <img src="../images/common/details_open.png" onclick="setDetailTable(this)" style="cursor:pointer"></label> -->
              <table id="dataTalbe3" class="table table-striped" style="border:1px solid #DDDDDD;" >
                <thead>
                  <tr class="eve">
                    <th style="width:10%">Size 1</th>
                    <th style="width:10%">Size 2</th>
                    <th style="width:10%">Size 3</th>
                    <th style="width:10%">Size 3.5</th>
                    <th style="width:10%">Size 4</th>
                    <th style="width:10%">Size 4.5</th>
                    <th style="width:10%">Size 5</th>
                    <th style="width:10%">Size 5.5</th>
                  </tr>
                </thead>
                <tbody>
                  <tr class="oddo" style="background-color:#FDFDFD; height:50px;">
                    <td style="vertical-align:middle;"><div style="width:100%; float:left;"><input value="0" name="shoes_amount_1" id="id_shoes_amount_1_1" class="form-control"style="width:100%;" onkeydown='myKeyDown(this)'></div></th>
                    <td style="vertical-align:middle;"><div style="width:100%; float:left;"><input value="0" name="shoes_amount_2"id="id_shoes_amount_1_2"class="form-control"style="width:100%;" onkeydown='myKeyDown(this)'></div></th>
                    <td style="vertical-align:middle;"><div style="width:100%; float:left;"><input value="0" name="shoes_amount_3"id="id_shoes_amount_1_3"class="form-control"style="width:100%;" onkeydown='myKeyDown(this)'></div></th>
                    <td style="vertical-align:middle;"><div style="width:100%; float:left;"><input value="0" name="shoes_amount_35"id="id_shoes_amount_1_35"class="form-control"style="width:100%;" onkeydown='myKeyDown(this)'></div></th>
                    <td style="vertical-align:middle;"><div style="width:100%; float:left;"><input value="0" name="shoes_amount_4"id="id_shoes_amount_1_4"class="form-control"style="width:100%;" onkeydown='myKeyDown(this)'></div></th>
                    <td style="vertical-align:middle;"><div style="width:100%; float:left;"><input value="0" name="shoes_amount_45"id="id_shoes_amount_1_45"class="form-control"style="width:100%;" onkeydown='myKeyDown(this)'></div></th>
                    <td style="vertical-align:middle;"><div style="width:100%; float:left;"><input value="0" name="shoes_amount_5"id="id_shoes_amount_1_5"class="form-control"style="width:100%;" onkeydown='myKeyDown(this)'></div></th>
                    <td style="vertical-align:middle;"><div style="width:100%; float:left;"><input value="0" name="shoes_amount_55"id="id_shoes_amount_1_55"class="form-control"style="width:100%;" onkeydown='myKeyDown(this)'></div></th>
				  </tr>
                </tbody>
              </table>
            </div>

            <div class='form-group'>
              <table id="dataTalbe3" class="table table-striped" style="border:1px solid #DDDDDD;" >
                <thead>
                  <tr class="eve">
					<th style="width:10%">Size 6</th>
                    <th style="width:10%">Size 6.5</th>
                    <th style="width:10%">Size 7</th>
                    <th style="width:10%">Size 7.5</th>
                    <th style="width:10%">Size 8</th>
                    <th style="width:10%">Size 8.5</th>
                    <th style="width:10%">Size 9</th>
                    <th style="width:10%">Size 9.5</th>
                  </tr>
                </thead>
                <tbody>
                  <tr class="oddo" style="background-color:#FDFDFD; height:50px;">
				    <td style="vertical-align:middle;"><div style="width:100%; float:left;"><input value="0" name="shoes_amount_6" id="id_shoes_amount_1_6" class="form-control"style="width:100%;" onkeydown='myKeyDown(this)'></div></th>
                    <td style="vertical-align:middle;"><div style="width:100%; float:left;"><input value="0" name="shoes_amount_65"id="id_shoes_amount_1_65"class="form-control"style="width:100%;" onkeydown='myKeyDown(this)'></div></th>
                    <td style="vertical-align:middle;"><div style="width:100%; float:left;"><input value="0" name="shoes_amount_7"id="id_shoes_amount_1_7"class="form-control"style="width:100%;" onkeydown='myKeyDown(this)'></div></th>
                    <td style="vertical-align:middle;"><div style="width:100%; float:left;"><input value="0" name="shoes_amount_75"id="id_shoes_amount_1_75"class="form-control"style="width:100%;" onkeydown='myKeyDown(this)'></div></th>
                    <td style="vertical-align:middle;"><div style="width:100%; float:left;"><input value="0" name="shoes_amount_8"id="id_shoes_amount_1_8"class="form-control"style="width:100%;" onkeydown='myKeyDown(this)'></div></th>
                    <td style="vertical-align:middle;"><div style="width:100%; float:left;"><input value="0" name="shoes_amount_85"id="id_shoes_amount_1_85"class="form-control"style="width:100%;" onkeydown='myKeyDown(this)'></div></th>
                    <td style="vertical-align:middle;"><div style="width:100%; float:left;"><input value="0" name="shoes_amount_9"id="id_shoes_amount_1_9"class="form-control"style="width:100%;" onkeydown='myKeyDown(this)'></div></th>
                    <td style="vertical-align:middle;"><div style="width:100%; float:left;"><input value="0" name="shoes_amount_95"id="id_shoes_amount_1_95"class="form-control"style="width:100%;" onkeydown='myKeyDown(this)'></div></th>
                  </tr>
                </tbody>
              </table>
            </div>

			<div class='form-group'>
              <table id="dataTalbe3" class="table table-striped" style="border:1px solid #DDDDDD;" >
                <thead>
                  <tr class="eve">
				    <th style="width:10%">Size 10</th>
					<th style="width:10%">Size 10.5</th>
                    <th style="width:10%">Size 11</th>
                    <th style="width:10%">Size 11.5</th>
                    <th style="width:10%">Size 12</th>
                    <th style="width:10%">Size 12.5</th>
                    <th style="width:10%">Size 13</th>
                    <th style="width:10%">Size 14</th>
                  </tr>
                </thead>
                <tbody>
                  <tr class="oddo" style="background-color:#FDFDFD; height:50px;">
				    <td style="vertical-align:middle;"><div style="width:100%; float:left;"><input value="0" name="shoes_amount_10" id="id_shoes_amount_1_10" class="form-control"style="width:100%;" onkeydown='myKeyDown(this)'></div></th>
                    <td style="vertical-align:middle;"><div style="width:100%; float:left;"><input value="0" name="shoes_amount_105"id="id_shoes_amount_1_105"class="form-control"style="width:100%;" onkeydown='myKeyDown(this)'></div></th>
                    <td style="vertical-align:middle;"><div style="width:100%; float:left;"><input value="0" name="shoes_amount_11"id="id_shoes_amount_1_11"class="form-control"style="width:100%;" onkeydown='myKeyDown(this)'></div></th>
                    <td style="vertical-align:middle;"><div style="width:100%; float:left;"><input value="0" name="shoes_amount_115"id="id_shoes_amount_1_115"class="form-control"style="width:100%;" onkeydown='myKeyDown(this)'></div></th>
                    <td style="vertical-align:middle;"><div style="width:100%; float:left;"><input value="0" name="shoes_amount_12"id="id_shoes_amount_1_12"class="form-control"style="width:100%;" onkeydown='myKeyDown(this)'></div></th>
                    <td style="vertical-align:middle;"><div style="width:100%; float:left;"><input value="0" name="shoes_amount_125"id="id_shoes_amount_1_125"class="form-control"style="width:100%;" onkeydown='myKeyDown(this)'></div></th>
                    <td style="vertical-align:middle;"><div style="width:100%; float:left;"><input value="0" name="shoes_amount_13"id="id_shoes_amount_1_13"class="form-control"style="width:100%;" onkeydown='myKeyDown(this)'></div></th>
                    <td style="vertical-align:middle;"><div style="width:100%; float:left;"><input value="0" name="shoes_amount_14"id="id_shoes_amount_1_14"class="form-control"style="width:100%;" onkeydown='myKeyDown(this)'></div></th>
                  </tr>
                </tbody>
              </table>
            </div>
<!-- 슈즈리스트 끝  -->

            <div class='form-group' style="margin:15px;">
              <span class='btn btn-primary btn-file'>
                 Select Main File <input type='file' id="id_file1" class='files' name="file_main">
              </span>
              <span class='addon1'> </span>
            </div>
            <div class='col-md-12'>
              <div class='pull-right'>
                <button id='img-change' class='btn btn-primary' type='button' onclick="setCreateEntry();">Create</button>
              </div>
            </div>
          </div>
      </div>
    </div>
  </div>
</form>
</div>


<!--entry 정보 팝업-->
<div>
<form name="frmupdate" method="post" action="entry_action.jsp" enctype="multipart/form-data">
  <div id='entryInfoModal' class='modal fade' tabindex='-1' role='dialog' aria-hidden='true' >
    <div class='modal-dialog'>
      <div class='modal-content'>
        <div class='modal-header'>
          <button class='close' data-dismiss='modal' aria-hidden='true'>&times;</button>
          <h5 class='modal-title'><span class="fa fa-github-alt"></span>&nbsp;&nbsp;<strong>Entry Imformation</strong></h5>
        </div>
        <div class='modal-body row'>
          <div class='col-md-6 img-modal'>
            <input type='hidden' value='' id='id_con_id' name="con_id"/>
            <input type='hidden' value='UPDATE'  name="mode"/>
			<input type='hidden' value='' id='pop_entry_id' name='entry_id'>
			<input type='hidden' value='' id='file_name' name='file_name'>
            <div id='showDetails' ><img id='id_show_thumb' class='img-thumbnail img-rounded' src="" style=" height:270px; margin-top:5px;"></div>
<!--             <p class='mtop10'><strong>File Name : </strong><span class='junkname' id='id_file_name'>default</span></p> -->
<!--             <p><strong>File Type : </strong><span class='junkext' id='id_file_type'>default</span></p> -->
          </div>
          <div class='col-md-6'>
            <div class='form-group'>
              <label>Entry name</label>
              <input id='id_entry_name_2' name="con_name" value='default' class='form-control'>
            </div>
            
            <div class='form-group'>
              <label>Entry Date</label>
                <div class="row" style="margin-bottom:10px;" >
                  <div class="col-md-12">
                    <div class="input-group date">
                      <input type="text" name="sch_sday" value="" size="5" class="form-control" readonly="reeadonly" data-beatpicker="true" data-beatpicker-id="myPicker" data-beatpicker-module="today,clear" style="cursor:pointer;background-color:#ffffff;text-align:center;" id="id_sch_sday_2" />
                        <span class="input-group-addon" style="background:#1FB5AD">
                          <span class="fa fa-minus" style="color:white"></span>
                        </span>
                      <input type="text" name="sch_eday" value="" size="5" class="form-control" readonly="reeadonly" data-beatpicker="true" data-beatpicker-id="myPickers" data-beatpicker-module="today,clear" style="cursor:pointer;background-color:#ffffff;text-align:center;"  id="id_sch_eday_2"/>
                    </div>
					<div class="input-group date">
					  <span class="input-group-addon" style="background:#1FB5AD;">
                        <span class="fa" style="color:white">OpenDate</span>
                      </span>
                      <input type="text" name="sch_oday" value="" size="5" class="form-control" readonly="reeadonly" data-beatpicker="true" data-beatpicker-id="myPickers" data-beatpicker-module="today,clear" style="cursor:pointer;background-color:#ffffff;text-align:center;"  id="id_sch_oday_2"/>	
					</div>
                  </div>
                </div>
            </div>
            <div class='row'> </div>
					
			<div class='form-group'>
			  <div>
			    <span class='input-group size'> </span>
			    <label>Name</label>
			    <input class="form-control" value="Please enter the Name" type="text" id="id_shoes_name_2" name="shoes_name" onkeydown='myKeyDown(this)'>
			  </div>
            </div>		
			
			<div class="form-group">
			  <div>
			    <span class='input-group size'> </span>
			    <label>Price</label>
			    <input class="form-control" value="Please enter the Price" type="text" id="id_shoes_price_2" name="shoes_price" onkeydown='myKeyDown(this)'>
			  </div>
			</div>

		  </div>
		  <div class='form-group'>
		    <div class="col-md-12">
			  <span class='input-group size'> </span>
		      <label>Explan</label>
		      <input class="form-control" value="Please enter the Explan" type="text" id="id_shoes_explan_2" name="shoes_explan" onkeydown='myKeyDown(this)'>
	        </div>
		  </div>
		  
		  <!-- 슈즈리스트 시작 -->
		  <div class='col-md-12' style="margin-top:15px;">
		    <div class='form-group'>
			  <label>Amount</label>
			  <table id="dataTalbe3" class="table table-striped" style="border:1px solid #DDDDDD;">
                <thead>
                  <tr class="eve">
                    <th style="width:10%">Size 1</th>
                    <th style="width:10%">Size 2</th>
                    <th style="width:10%">Size 3</th>
                    <th style="width:10%">Size 3.5</th>
                    <th style="width:10%">Size 4</th>
                    <th style="width:10%">Size 4.5</th>
                    <th style="width:10%">Size 5</th>
                    <th style="width:10%">Size 5.5</th>
                  </tr>
                </thead>
                <tbody>
                  <tr class="oddo" style="background-color:#FDFDFD; height:50px;">
                    <td style="vertical-align:middle;"><div style="width:100%; float:left;"><input value="0" name="shoes_amount_1" id="id_shoes_amount_2_1" class="form-control"style="width:100%;" onkeydown='myKeyDown(this)'></div></th>
                    <td style="vertical-align:middle;"><div style="width:100%; float:left;"><input value="0" name="shoes_amount_2"id="id_shoes_amount_2_2"class="form-control"style="width:100%;" onkeydown='myKeyDown(this)'></div></th>
                    <td style="vertical-align:middle;"><div style="width:100%; float:left;"><input value="0" name="shoes_amount_3"id="id_shoes_amount_2_3"class="form-control"style="width:100%;" onkeydown='myKeyDown(this)'></div></th>
                    <td style="vertical-align:middle;"><div style="width:100%; float:left;"><input value="0" name="shoes_amount_35"id="id_shoes_amount_2_35"class="form-control"style="width:100%;" onkeydown='myKeyDown(this)'></div></th>
                    <td style="vertical-align:middle;"><div style="width:100%; float:left;"><input value="0" name="shoes_amount_4"id="id_shoes_amount_2_4"class="form-control"style="width:100%;" onkeydown='myKeyDown(this)'></div></th>
                    <td style="vertical-align:middle;"><div style="width:100%; float:left;"><input value="0" name="shoes_amount_45"id="id_shoes_amount_2_45"class="form-control"style="width:100%;" onkeydown='myKeyDown(this)'></div></th>
                    <td style="vertical-align:middle;"><div style="width:100%; float:left;"><input value="0" name="shoes_amount_5"id="id_shoes_amount_2_5"class="form-control"style="width:100%;" onkeydown='myKeyDown(this)'></div></th>
                    <td style="vertical-align:middle;"><div style="width:100%; float:left;"><input value="0" name="shoes_amount_55"id="id_shoes_amount_2_55"class="form-control"style="width:100%;" onkeydown='myKeyDown(this)'></div></th>
				  </tr>
                </tbody>
              </table>
            </div>

            <div class='form-group'>
              <table id="dataTalbe3" class="table table-striped" style="border:1px solid #DDDDDD;" >
                <thead>
                  <tr class="eve">
					<th style="width:10%">Size 6</th>
                    <th style="width:10%">Size 6.5</th>
                    <th style="width:10%">Size 7</th>
                    <th style="width:10%">Size 7.5</th>
                    <th style="width:10%">Size 8</th>
                    <th style="width:10%">Size 8.5</th>
                    <th style="width:10%">Size 9</th>
                    <th style="width:10%">Size 9.5</th>
                  </tr>
                </thead>
                <tbody>
                  <tr class="oddo" style="background-color:#FDFDFD; height:50px;">
				    <td style="vertical-align:middle;"><div style="width:100%; float:left;"><input value="0" name="shoes_amount_6" id="id_shoes_amount_2_6" class="form-control"style="width:100%;" onkeydown='myKeyDown(this)'></div></th>
                    <td style="vertical-align:middle;"><div style="width:100%; float:left;"><input value="0" name="shoes_amount_65"id="id_shoes_amount_2_65"class="form-control"style="width:100%;" onkeydown='myKeyDown(this)'></div></th>
                    <td style="vertical-align:middle;"><div style="width:100%; float:left;"><input value="0" name="shoes_amount_7"id="id_shoes_amount_2_7"class="form-control"style="width:100%;" onkeydown='myKeyDown(this)'></div></th>
                    <td style="vertical-align:middle;"><div style="width:100%; float:left;"><input value="0" name="shoes_amount_75"id="id_shoes_amount_2_75"class="form-control"style="width:100%;" onkeydown='myKeyDown(this)'></div></th>
                    <td style="vertical-align:middle;"><div style="width:100%; float:left;"><input value="0" name="shoes_amount_8"id="id_shoes_amount_2_8"class="form-control"style="width:100%;" onkeydown='myKeyDown(this)'></div></th>
                    <td style="vertical-align:middle;"><div style="width:100%; float:left;"><input value="0" name="shoes_amount_85"id="id_shoes_amount_2_85"class="form-control"style="width:100%;" onkeydown='myKeyDown(this)'></div></th>
                    <td style="vertical-align:middle;"><div style="width:100%; float:left;"><input value="0" name="shoes_amount_9"id="id_shoes_amount_2_9"class="form-control"style="width:100%;" onkeydown='myKeyDown(this)'></div></th>
                    <td style="vertical-align:middle;"><div style="width:100%; float:left;"><input value="0" name="shoes_amount_95"id="id_shoes_amount_2_95"class="form-control"style="width:100%;" onkeydown='myKeyDown(this)'></div></th>
                  </tr>
                </tbody>
              </table>
            </div>

			<div class='form-group'>
              <table id="dataTalbe3" class="table table-striped" style="border:1px solid #DDDDDD;" >
                <thead>
                  <tr class="eve">
				    <th style="width:10%">Size 10</th>
					<th style="width:10%">Size 10.5</th>
                    <th style="width:10%">Size 11</th>
                    <th style="width:10%">Size 11.5</th>
                    <th style="width:10%">Size 12</th>
                    <th style="width:10%">Size 12.5</th>
                    <th style="width:10%">Size 13</th>
                    <th style="width:10%">Size 14</th>
                  </tr>
                </thead>
                <tbody>
                  <tr class="oddo" style="background-color:#FDFDFD; height:50px;">
				    <td style="vertical-align:middle;"><div style="width:100%; float:left;"><input value="0" name="shoes_amount_10" id="id_shoes_amount_2_10" class="form-control"style="width:100%;" onkeydown='myKeyDown(this)'></div></th>
                    <td style="vertical-align:middle;"><div style="width:100%; float:left;"><input value="0" name="shoes_amount_105"id="id_shoes_amount_2_105"class="form-control"style="width:100%;" onkeydown='myKeyDown(this)'></div></th>
                    <td style="vertical-align:middle;"><div style="width:100%; float:left;"><input value="0" name="shoes_amount_11"id="id_shoes_amount_2_11"class="form-control"style="width:100%;" onkeydown='myKeyDown(this)'></div></th>
                    <td style="vertical-align:middle;"><div style="width:100%; float:left;"><input value="0" name="shoes_amount_115"id="id_shoes_amount_2_115"class="form-control"style="width:100%;" onkeydown='myKeyDown(this)'></div></th>
                    <td style="vertical-align:middle;"><div style="width:100%; float:left;"><input value="0" name="shoes_amount_12"id="id_shoes_amount_2_12"class="form-control"style="width:100%;" onkeydown='myKeyDown(this)'></div></th>
                    <td style="vertical-align:middle;"><div style="width:100%; float:left;"><input value="0" name="shoes_amount_125"id="id_shoes_amount_2_125"class="form-control"style="width:100%;" onkeydown='myKeyDown(this)'></div></th>
                    <td style="vertical-align:middle;"><div style="width:100%; float:left;"><input value="0" name="shoes_amount_13"id="id_shoes_amount_2_13"class="form-control"style="width:100%;" onkeydown='myKeyDown(this)'></div></th>
                    <td style="vertical-align:middle;"><div style="width:100%; float:left;"><input value="0" name="shoes_amount_14"id="id_shoes_amount_2_14"class="form-control"style="width:100%;" onkeydown='myKeyDown(this)'></div></th>
                  </tr>
                </tbody>
              </table>
              </div>
			</div>
<!-- 슈즈리스트 끝  -->

<!-- 버튼 시작 -->
			<div class='form-group' style="margin:15px;">
              <span class='btn btn-primary btn-file'>
                 Select Main File <input type='file' id="id_file2" class='files' name="file_main" ">
              </span>
			  <span class='addon2'> </span>
            </div>

            <div class='col-md-12'>
              <div class='pull-right'>
			    <button id='img-change' class='btn btn-danger' type='button' onclick="setDeleteCheck();">Delete</button>
                <button id='img-change' class='btn btn-primary' type='button' onclick="setSaveCheck();">Change</button>	
              </div>
            </div>
<!-- 버튼 끝 -->
        </div>
      </div>
    </div>
  </div>
</form>

<!--entry 추첨 팝업 시작 -->
<form name="frmwin" method="post" action="pro_action.jsp" enctype="multipart/form-data">
  <div id='entry_winner_pop' class='modal fade' tabindex='-1' role='dialog' aria-hidden='true'>
    <div class='modal-dialog'>
      <div class='modal-content'>
        <div class='modal-header'>
          <button class='close' data-dismiss='modal' aria-hidden='true'>&times;</button>
          <h5 class='modal-title'><span class="fa fa-github-alt"></span>&nbsp;&nbsp;<strong>File Imformation</strong></h5>
        </div>
        <div class='modal-body row'>
          <div class='col-md-12 img-modal'>
            <input type='hidden' value='' id='id_con_id' name="con_id"/>
            <input type='hidden' value='UPDATE'  name="mode"/>
            
           <!-- 당첨 리스트 시작 -->
			<div class='form-group'>
			<label>Amount</label>
<!-- 			  <label style='color:#01DF3A'>Shoes Size List <img src="../images/common/details_open.png" onclick="setDetailTable(this)" style="cursor:pointer"></label> -->
              <table id="dataTalbe3" class="table table-striped" style="border:1px solid #DDDDDD;" >
                <thead>
                  <tr class="eve">
					<th style="width:16%">No</th>
                    <th style="width:16%">Name</th>
					<th style="width:16%">Gender</th>
					<th style="width:16%">Phone</th>
					<th style="width:16%">Size</th>
					<th style="width:16%">Mail</th>
                  </tr>
                </thead>
                <tbody id="id_winner_tbody" style="">
<%
for(int g = 0; g < arr_size.length; g++ ){
	
%>
<!-- 				<tr class="oddo" style="background-color:#FDFDFD; height:50px;"> -->
<!-- 					<td style="vertical-align:middle;"><div id="id_winner_name_<%=arr_size[g]%>" style="width:100%; float:left;white-space: pre;"></div></th> -->
<!-- 					<td style="vertical-align:middle;"><div id="id_winner_gender_<%=arr_size[g]%>" style="width:100%; float:left;white-space: pre;"></div></th> -->
<!-- 					<td style="vertical-align:middle;"><div id="id_winner_phone_<%=arr_size[g]%>" style="width:100%; float:left;white-space: pre;"></div></th> -->
<!-- 					<td style="vertical-align:middle;"><div id="id_winner_size_<%=arr_size[g]%>" style="width:100%; float:left;white-space: pre;"></div></th> -->
<!-- 					<td style="vertical-align:middle;"><div id="id_winner_mail_<%=arr_size[g]%>" style="width:100%; float:left;white-space: pre;"></div></th> -->
<!-- 				</tr> -->

<%
}
%>				
				 
				</tbody>
			  </table>
            </div>
<!-- 당첨 리스트 끝  -->
          </div>
      </div>
    </div>
  </div>
</form>
<!--entry 추첨 팝업 끝 -->

</div>
</body>
</html>

<style>
	.modal-dialog { 
		min-width : 50% ; 
	} 
</style>

<iframe name="frameupdate" src="" width="0" height="0" style="zindex:999;" frameborder="0" marginheight="0" marginwidth="0" scrolling="0"></iframe>

<form name="frmpage" action="entry_list.jsp">
  <input type="hidden" name="kiosk_id" value="">
  <input type="hidden" name="entry_pageno" value="<%=entry_pageno%>">
  <input type="hidden" name="entry_pagesize" value="<%=entry_pagesize%>">
  <input type="hidden" name="kiosk_pageno" value="<%=kiosk_pageno%>">
  <input type="hidden" name="kiosk_pagesize" value="<%=kiosk_pagesize%>">
</form>

<script>

window.onload=function()
{

}

	var update_kiosk_entryid = "";
	var update_kiosk_status = "";

	var data1 = new Array();
	data1[0] = [<%=entry_all_text%>];
	data1[1] = [<%=entry_all_value%>];

	var data2 = new Array();
	data2[0] = [<%=entry_today_text%>];
	data2[1] = [<%=entry_today_value%>];

	var data3 = new Array();
	data3[0] = [];
	data3[1] = [[]];
	data3[2] = [];

	var data4 = new Array();
	data4[0] = [<%=entry_gender_text%>];
	data4[1] = [<%=entry_gender_value%>];

	var data5 = new Array();
	data5[0] = [<%=entry_age_text%>];
	data5[1] = [<%=entry_age_value%>];

	var monthNames = ["January", "February", "March", "April", "May", "June","July", "August", "September", "October", "November", "December"];

	function setPageSubmit(no,id){
		if(id === "entry"){
			document.frmpage.entry_pageno.value = no;
			document.frmpage.submit();
		}else{
			document.frmpage.kiosk_pageno.value = no;
			document.frmpage.submit();
		}
    }
	
	//통계 설정하는 부분
	function drawStatis(){

		var date = new Date();

		setPieMethod(data4,"chart01","guide01",1);//성별 그래프
		setPieMethod(data5,"chart02","guide02",2);//나이대별 그래프

//		setPieMethod(data1,"chart01","guide01",1);//전체 응모별 그래프
//		setPieMethod(data2,"chart02","guide02",2);//당일 응모 그래프
//		setLineMethod2(data3,"chart03","guide03",3);//월별 응모 그래프

//		document.querySelector("#id_month").innerHTML = monthNames[date.getMonth()];
//
//		document.querySelector("#chart03").style.width = "70%";
//		document.querySelector("#chart03").style.height = "90%";
	}drawStatis();

	//이번달 통계 데이터 가져오는 부분
//	function getStatisInfo(){
//		for (var m=1; m <= 31; m++ ){
//			data3[0].push(m);
//		}
//
//		$.ajax({
//			 type:"get",
//			 url:"entry_statis.jsp",
//			 dataType:"text",
//			 success : function(data){
//				var ret_reg_date = [];
//				var ret_total_cnt = [];
//				var ret_parse_num = 0;
//				var jsonObj = $.parseJSON(data);
//
//				for(var i = 0; i < jsonObj.length; i++){
//					ret_reg_date[i] = parseInt(jsonObj[i].reg_date.substring(8,10));
//					ret_total_cnt[i] = parseInt(jsonObj[i].total_cnt);
//				}
//
//				var t = 0;
//
//				for (var j = 0; j <= 31; j++){
//					ret_parse_num = ret_reg_date[t] - 1;	
//					
//					if(j === ret_parse_num){
//						data3[1][0][ret_parse_num] = ret_total_cnt[t] + "";
//						t++;
//					}else{
//						data3[1][0][j] = 0 + "";
//					}
//				}
//				drawStatis();
//				
//			 },
//			 error : function(xhr, status, error){
//			 }
//		});
//	}getStatisInfo();
	
	//엔트리 수정 하는 부분
    function setSaveCheck(){

		var checkCon = confirm("Will you fix it??");

		if(checkCon){
			var shoes_name = document.querySelector("#id_shoes_name_2").value;
			var shoes_price = document.querySelector("#id_shoes_price_2").value;
			var shoes_explan = document.querySelector("#id_shoes_explan_2").value;
			var special_pattern = /[`~!@#$%^&*|\\\'\";:\/?]/gi;
			var check_num_amount = isNaN(shoes_price);

			for(var i=1; i < 15; i++){

				var id_shoes_amount = "id_shoes_amount_2_" + i ;
				var shoes_amount = document.querySelector("#" + id_shoes_amount).value;

				if(shoes_amount === "" || isNaN(shoes_amount)){
					alert("Please Check the Amount");
					document.querySelector("#" + id_shoes_amount).focus();
					return;
				}
			}

			if(shoes_name === "" || shoes_name === "Please enter the Name" ){
				alert("Please Check the Name..");
				document.querySelector("#id_shoes_name_2").focus();
				return;
			}
			if(shoes_price === "" || shoes_price === "Please enter the Price" || check_num_amount){
				alert("Please Check the Price..");
				document.querySelector("#id_shoes_price_2").focus();
				return;
			}
			if(shoes_explan === "" || shoes_explan === "Please enter the Explan" ){
				alert("Please Check the Explan..");
				document.querySelector("#id_shoes_explan_2").focus();
				return;
			}

			document.frmupdate.action = "entry_action.jsp";
			document.frmupdate.submit();
		}
    }
	
	//Entry 등록 하는 부분
	function setCreateEntry(){

		var checkTitleValue = document.querySelector("#id_entry_name_1").value;
		var checkStartDay =  document.querySelector("#id_sch_sday_1").value;
		var checkEndDay = document.querySelector("#id_sch_eday_1").value;
		var shoes_name = document.querySelector("#id_shoes_name_1").value;
		var shoes_price = document.querySelector("#id_shoes_price_1").value;
		var shoes_explan = document.querySelector("#id_shoes_explan_1").value;
		var check_num_amount = isNaN(shoes_price);

		for(var i=1; i < 15; i++){

			var id_shoes_amount = "id_shoes_amount_1_" + i ;
			var shoes_amount = document.querySelector("#" + id_shoes_amount).value;

			if(shoes_amount === "" || isNaN(shoes_amount)){
				alert("Please Check the Amount");
				document.querySelector("#" + id_shoes_amount).focus();
				return;
			}
		}

		if(checkTitleValue == ""){
			alert("Please Enter The EntryName..");
			document.querySelector("#id_entry_name_1").focus();
			return;
		}
		if(checkStartDay == ""){
			alert("Please Enter The StartDate..");
			document.querySelector("#id_sch_sday_1").focus();
			return;
		}
		if(checkEndDay == ""){
			alert("Please Enter The EndDate..");
			document.querySelector("#id_sch_eday_1").focus();
			return;
		}

		if(shoes_name === "" || shoes_name === "Please enter the Name" ){
				alert("Please Check the Name..");
				document.querySelector("#id_shoes_name_1").focus();
				return;
		}
		if(shoes_price === "" || shoes_price === "Please enter the Price" || check_num_amount){
			alert("Please Check the Price..");
			document.querySelector("#id_shoes_price_1").focus();
			return;
		}
		if(shoes_explan === "" || shoes_explan === "Please enter the Explan" ){
			alert("Please Check the Explan..");
			document.querySelector("#id_shoes_explan_1").focus();
			return;
		}

		document.querySelector("#id_mode").value = "INSERT";
		document.frmwrite.submit();
    }
	
	//슈즈 정보 입력시 기본 값 체크 부분
	function myKeyDown(obj){

		var input_id = obj.getAttribute("id");
		var text_value = document.querySelector("#" + input_id).value;

		if(input_id.length === 19 || input_id.length === 20){
			if(isNaN(text_value)){
				document.querySelector("#" + input_id).value = "";
			}
		}

		if(input_id === "id_entry_name_1" || input_id === "id_entry_name_2"){
			if(text_value === "Please enter the EntryName"){
			document.querySelector("#" + input_id).value = "";
			}
		}

		if(input_id === "id_shoes_name_1" || input_id === "id_shoes_name_2"){
			if(text_value === "Please enter the Name"){
			document.querySelector("#" + input_id).value = "";
			}
		}

		if(input_id === "id_shoes_price_1" || input_id === "id_shoes_price_2"){
			if(text_value === "Please enter the Price" || isNaN(text_value) || text_value === "" ){
				document.querySelector("#" + input_id).value = "";
				return;
			}
		}

		if(input_id === "id_shoes_explan_1" || input_id === "id_shoes_explan_2"){
			if(text_value === "Please enter the Explan"){
			document.querySelector("#" + input_id).value = "";
			}
		}
	}
	
	//엔트리 삭제 하는 부분
	function setDeleteCheck(){

		var checkCon = confirm("Will you delete it??");
		if(checkCon){
			document.frmupdate.action = "entry_action.jsp";
			document.frmupdate.mode.value = "DELETE";
			document.frmupdate.submit();
		}
	}

	//entry 등록 팝업 오픈 시 기본 제목 오늘 날짜 설정 부분
//	function getTodayTime(){
//
//		var time_str = "";
//		var time = new Date();
//
//		time_str += time.getFullYear() + "-" ; 
//		time_str += time.getMonth() + "-" ;
//		time_str += time.getDate() + "-" ;
//		time_str += time.getHours() + "-" ;
//		time_str += time.getMinutes() + "-" ;
//		time_str += time.getSeconds() ;
//
//		document.getElementById("id_con_name2").value = time_str;
//
//	};
	
	//kiosk 상태 업데이트
	function setKioskUpdateCheck(kiosk_id){

		var checkCon = confirm("Will you fix it??");
		var status_id = "status_id" + kiosk_id;
		var open_checkbox_id = "open_checkbox_id" + kiosk_id;
		var entry_id = $("#entry_select" + kiosk_id).val();
		var status = $('#' + status_id).bootstrapSwitch('state');
		var open_status = $("#" + open_checkbox_id).is(":checked");
		$("#entry_status").val(status);
		$("#status_id").val(status);
		$("#kiosk_id").val(kiosk_id);
		$("#entry_id").val(entry_id);
		$("#open_status_id").val(open_status);

		if(checkCon){
			document.frmkioskupdate.action = "entry_action.jsp";
			document.frmkioskupdate.mode.value = "KIOSKUPDATE";
			document.frmkioskupdate.submit();
		}
	}

	//Create Entry 팝업 띄우는 부분
    function setShowCreateModal(){

		$('#myModal').modal();
    }

	//Entry 정보 팝업 띄우는 부분
    function setShowInfoModal(entry_id){

		$('#entryInfoModal').modal();
		var entrySday = "";
		var entryEday = "";

		$.ajax({
             type:"get",
             url:"entry_json.jsp",
             dataType:"text",
             data : {'entry_id':entry_id},
             success : function(data){
				var jsonObj = $.parseJSON(data);
				$('#id_sch_sday_2').val(jsonObj.sch_sday.substring(0,4) +"-" +jsonObj.sch_sday.substring(4,6)+"-" +jsonObj.sch_sday.substring(6,8));
				$('#id_sch_eday_2').val(jsonObj.sch_eday.substring(0,4) +"-" +jsonObj.sch_eday.substring(4,6)+"-" +jsonObj.sch_eday.substring(6,8));
				$('#id_entry_name_2').val(jsonObj.entry_name);
				$('#file_name').val(jsonObj.file_name);
				$('#id_file_type').text(jsonObj.file_ext);
				$('#id_show_thumb').attr("src","http://192.000.0.000:8001/zcommonfiles/entry/" + jsonObj.file_name );
				$('#pop_entry_id').val(entry_id);
				$('#file_name2').val(jsonObj.file_name);
				$('#id_shoes_name_2').val(jsonObj.shoes_name);
				$('#id_shoes_explan_2').val(jsonObj.shoes_explan);
				$('#id_shoes_price_2').val(jsonObj.shoes_price);
				$('#id_shoes_amount_2_1').val(jsonObj.shoes_size_1);
				$('#id_shoes_amount_2_2').val(jsonObj.shoes_size_2);
				$('#id_shoes_amount_2_3').val(jsonObj.shoes_size_3);
				$('#id_shoes_amount_2_35').val(jsonObj.shoes_size_35);
				$('#id_shoes_amount_2_4').val(jsonObj.shoes_size_4);
				$('#id_shoes_amount_2_45').val(jsonObj.shoes_size_45);
				$('#id_shoes_amount_2_5').val(jsonObj.shoes_size_5);
				$('#id_shoes_amount_2_55').val(jsonObj.shoes_size_55);
				$('#id_shoes_amount_2_6').val(jsonObj.shoes_size_6);
				$('#id_shoes_amount_2_65').val(jsonObj.shoes_size_65);
				$('#id_shoes_amount_2_7').val(jsonObj.shoes_size_7);
				$('#id_shoes_amount_2_75').val(jsonObj.shoes_size_75);
				$('#id_shoes_amount_2_8').val(jsonObj.shoes_size_8);
				$('#id_shoes_amount_2_85').val(jsonObj.shoes_size_85);
				$('#id_shoes_amount_2_9').val(jsonObj.shoes_size_9);
				$('#id_shoes_amount_2_95').val(jsonObj.shoes_size_95);
				$('#id_shoes_amount_2_10').val(jsonObj.shoes_size_10);
				$('#id_shoes_amount_2_105').val(jsonObj.shoes_size_105);
				$('#id_shoes_amount_2_11').val(jsonObj.shoes_size_11);
				$('#id_shoes_amount_2_115').val(jsonObj.shoes_size_115);
				$('#id_shoes_amount_2_12').val(jsonObj.shoes_size_12);
				$('#id_shoes_amount_2_125').val(jsonObj.shoes_size_125);
				$('#id_shoes_amount_2_13').val(jsonObj.shoes_size_13);
				$('#id_shoes_amount_2_14').val(jsonObj.shoes_size_14);
				
             },
             error : function(xhr, status, error){

             }
        });
    }

	//파일 업로드시 파일명 보여주는 부분
	$('#id_file1').change(function(e){//엔트리 등록에서 파일변경시 실행되는 함수
		$('.addon1').text($(this).val());
    });

	$('#id_file2').change(function(e){//엔트리 수정에서 파일변경시 실행되는 함수
		$('.addon2').text($(this).val());
    });

	//kiosk 리스트에 entry 설정 적용 하는 부분
	function setKioskList(){

		var entry_list ="<%=entry_list%>";
		var entry_arr = entry_list.split(",");
		var kiosk_list ="<%=kiosk_list%>";
		var kiosk_arr = kiosk_list.split(",");
		var status_list = "<%=status_list%>";
		var status_arr = status_list.split(",");
		
		for (var i=0; i < kiosk_arr.length-1; i++ ){

			if(status_arr[i] === "" || "K"){
				$('#status_id' + kiosk_arr[i]).bootstrapSwitch('setState', true);
			}if(status_arr[i] ==="B"){
				$('#status_id' + kiosk_arr[i]).bootstrapSwitch('setState', false);
			}
			if(entry_arr[i] === ""){
				$("#entry_select"+kiosk_arr[i]).val(entry_arr[0]).prop("selected", true);
			}
			$("#entry_select"+kiosk_arr[i]).val(entry_arr[i]).prop("selected", true);
		};
	}setKioskList();

	//당첨자 뽑는 부분
	function setWinEntry(entry_id){
		
		document.querySelector("#winner_entry_id").value = entry_id;
		var checkCon = confirm("Will you choose winner??");

		if(checkCon){
			document.querySelector("#frmsetwinner").submit();
		}

	}
//	//당첨자 리스트 닫을 시  모달 초기화
//	$('#entry_winner_pop').on('hidden.bs.modal', function (e) {
//		
//		var arr = [1,2,3,35,4,45,5,55,6,65,7,75,8,85,9,95,10,105,11,115,12,125,13,14];
//
//	    for(var i = 0; i < arr.length; i++){
//
//			var target_name = "id_winner_name_" + arr[i];
//			var target_gender = "id_winner_gender_" + arr[i];
//			var target_phone = "id_winner_phone_" + arr[i];
//			var target_size = "id_winner_size_" + arr[i];
//			var target_mail = "id_winner_mail_" + arr[i];
//
//			document.querySelector("#" + target_name).innerHTML = "";
//			document.querySelector("#" + target_gender).innerHTML = "";
//			document.querySelector("#" + target_phone).innerHTML = "";
//			document.querySelector("#" + target_size).innerHTML = "";
//			document.querySelector("#" + target_mail).innerHTML = "";
//		}
//	});
	
	//당첨자 리스트 보여주는 부분
	function getWinEntryList(entry_id){
		$("#entry_winner_pop").modal();
		var arr = [1,2,3,35,4,45,5,55,6,65,7,75,8,85,9,95,10,105,11,115,12,125,13,14];
		$.ajax({
             type:"get",
             url:"entry_winner_json.jsp",
             dataType:"text",
             data : {'entry_id':entry_id},
             success : function(data){

				var jsonObj = JSON.parse(data);
				var text = "";
				for(var i = 0; i <jsonObj.length; i++){
					
					var name = jsonObj[i].name;
					var gender = jsonObj[i].gender;
					var phone = jsonObj[i].phone;
					var size = jsonObj[i].size;
					var mail = jsonObj[i].mail;

					text += 
					"<tr class='oddo' style='background-color:#FDFDFD; height:50px;'>" +
					  "<td style='vertical-align:middle;'><div style='width:100%; text-align:center;'>" + ( i + 1 ) + "</div></th>" +
					  "<td style='vertical-align:middle;'><div style='width:100%;text-align:center;'>" + name + "</div></th>" +
				      "<td style='vertical-align:middle;'><div style='width:100%;text-align:center;'>" + gender + "</div></th>" +
					  "<td style='vertical-align:middle;'><div style='width:100%;text-align:center;'>" + phone + "</div></th>" +
					  "<td style='vertical-align:middle;'><div style='width:100%;text-align:center;'>" + size + "</div></th>" +
					  "<td style='vertical-align:middle;'><div style='width:100%;text-align:center;'>" + mail + "</div></th>" +
					"</tr>";
				}
				document.querySelector("#id_winner_tbody").innerHTML = text;

             },
             error : function(xhr, status, error){

             }
        });
	}
	

//	//슈즈 사이즈 테이블 숨기는 부분
//	function setDetailTable(obj){ 
//		var check_display = document.querySelector("#dataTalbe3").style.display;
//		if(check_display === "none"){
//			obj.setAttribute("src","../images/common/details_close.png");
//			document.querySelector("#dataTalbe3").style.display = "block";
//		}else{
//			obj.setAttribute("src","../images/common/details_open.png");
//			document.querySelector("#dataTalbe3").style.display = "none";
//		}
//    }

	//엔트리 당첨 응모 이후 버튼 숨기는 부분
	function setHideWinnerBtn(){
		var winner_value = document.querySelector("#winner_id").value;
		if(winner_value === "C"){
			document.querySelector("#winner_btn").setAttribute("style","display:none;");
			document.querySelector("#winner_list_btn").setAttribute("style","");
		}
	}setHideWinnerBtn();
	

    //스타일 적용 부분
    $('.oddo').children().each(function(){$(this).css({'text-align':'center'});});
    $('.eve').children().each(function(){
        $(this).css({'text-align':'center','cursor':'pointer'});
        $(this).hover(function(){$(this).css('color','black')},function(){$(this).css('color','#767676')});
    });

    $('.switch-small').bootstrapSwitch();    //스위치 기능부여

    //라디오를 그리는 함수
    $('.minimal input').iCheck({
        checkboxClass: 'icheckbox_flat-blue',
        radioClass: 'iradio_flat-blue'
    });

    //체크박스를 그리는 함수
    $('.flat-green input').iCheck({
        checkboxClass: 'icheckbox_flat-blue',
        radioClass: 'iradio_flat-blue'
    });

    //전체 체크박스 선택
    $('#id_kiosk_all').on('ifChecked', function(event){
        $('.flat-green input').iCheck('check');
    });

    //전체 체크박스 해제
    $('#id_kiosk_all').on('ifUnchecked', function(event){
        $('.flat-green input').iCheck('uncheck');
    });
   
</script>
