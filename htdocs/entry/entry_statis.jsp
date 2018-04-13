<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.shoes.comm.CommUtil" %>
<%@ page import="java.util.*" %>
<%@ page import="com.shoes.admin.entry.*" %>
<%@ include file="../include/config.jsp" %>
<%@ include file="../include/logincheck.jsp" %>

<%

request.setCharacterEncoding("UTF-8");

CommUtil cutil = new CommUtil();

%>

<%

String data = "";
EntryMgr emgr = new EntryMgr();
ArrayList<EntryInfo> elist = new ArrayList<EntryInfo>();
EntryInfo einfo = new EntryInfo();

elist = emgr.getEntryOfDayStatis();

for(int i=0; i < elist.size(); i++){
	einfo = elist.get(i);
	if(i == 0){
		data += "[{";
	}else{
		data += "{";
	}
	data += "\"reg_date\":\"" + einfo.getReg_date() + "\",";
	data += "\"total_cnt\":\"" + einfo.getTotal_cnt() + "\"";
	if(i == elist.size() - 1){
		data += "}]";
	}else{
		data += "},";
	}
}
out.println(data);

%>