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

String entry_id = cutil.getCheckNull(request.getParameter("entry_id"));
String data = "";
String shoes_size = "";
String check = "";
EntryMgr emgr = new EntryMgr();
ArrayList<EntryInfo> elist = new ArrayList<EntryInfo>();

elist = emgr.getEntryWinnerList(entry_id);


data  = "[";
int x = 0;
for(EntryInfo einfo : elist){

	if(x == elist.size()-1){
		data += "{\"name\":\"" + einfo.getUser_firstname() + "\"," + "\"" + "gender\":\"" + einfo.getUser_gender() + "\"," + "\"mail\":\"" + einfo.getUser_mail() + "\"," + "\"phone\":\"" + einfo.getUser_phone() + "\"," + "\"size\":\"" + einfo.getShoes_size() + "\"}";
	}else{
		data += "{\"name\":\"" + einfo.getUser_firstname() + "\"," + "\"" + "gender\":\"" + einfo.getUser_gender() + "\"," + "\"mail\":\"" + einfo.getUser_mail() + "\"," + "\"phone\":\"" + einfo.getUser_phone() + "\"," + "\"size\":\"" + einfo.getShoes_size() + "\"},";
	}
	x++;	

}

data += "]";

out.println(data);
%>