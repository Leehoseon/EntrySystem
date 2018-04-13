<%@ page language="java" contentType="application/vnd.ms-excel;charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="java.util.*" %>
<%@ page import="com.shoes.admin.entry.*" %>
<%@ page import="com.shoes.comm.CommUtil" %>

<%
response.setContentType("application/vnd.ms-excel");
%>

<%

CommUtil cutil = new CommUtil();
EntryMgr emgr = new EntryMgr();
ArrayList<EntryInfo> elist = new ArrayList<EntryInfo>();

String entry_id = cutil.getCheckNull(request.getParameter("entry_id"));
String target = cutil.getCheckNull(request.getParameter("target"));

%>
<br>
<head>
<style type="text/css">
body{
  font-weight:"normal" !important;
}
table{
  font-weight:"normal" !important;
}
</style>
</head>
<body>

<%
if(target.equals("winner")){
response.setHeader("Content-Disposition", "attachment; filename=winner.xls");
%>

<p>WinnerList</p>
<table>
<thead>
  <tr class="eve">
    <th style="width:5%">Name</th>
    <th style="width:10%">Gender</th>
    <th style="width:20%">Phone</th>
    <th style="width:30%">Size</th>
    <th style="width:30%">Mail</th>
  </tr>
</thead>
<%
	elist = emgr.getEntryWinnerList(entry_id);
	for(EntryInfo einfo : elist){
%>
<tbody>
  <tr class="eve">
    <th style="width:5%"><%=einfo.getUser_firstname() + " " + einfo.getUser_lastname()%></th>
    <th style="width:10%"><%=einfo.getUser_gender()%></th>
    <th style="width:20%"><%=einfo.getUser_phone()%></th>
    <th style="width:30%"><%=einfo.getShoes_size()%></th>
    <th style="width:30%"><%=einfo.getUser_mail()%></th>
  </tr>
</tbody>
<%
	}
}
%>
</table>

<%
if(target.equals("user")){
response.setHeader("Content-Disposition", "attachment; filename=user.xls");
%>
<p>UserList</p>
<br>
<table>
<thead>
  <tr class="eve">
    <th style="width:5%">Name</th>
    <th style="width:10%">Gender</th>
    <th style="width:20%">Phone</th>
    <th style="width:30%">Size</th>
    <th style="width:30%">Mail</th>
  </tr>
</thead>
<%
elist = emgr.getEntryUserList(entry_id);
for(EntryInfo einfo : elist){
%>
<tbody>
  <tr class="eve">
    <th style="width:5%"><%=einfo.getUser_firstname() + " " + einfo.getUser_lastname()%></th>
    <th style="width:10%"><%=einfo.getUser_gender()%></th>
    <th style="width:20%"><%=einfo.getUser_phone()%></th>
    <th style="width:30%"><%=einfo.getShoes_size()%></th>
    <th style="width:30%"><%=einfo.getUser_mail()%></th>
  </tr>
</tbody>
<%
	}
}
%>
</table>
</body>



<!-- http://192.168.0.201:8001/stadmin/entry/entry_excel.jsp?entry_id=1066&target=winner -->