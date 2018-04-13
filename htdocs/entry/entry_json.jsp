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
EntryMgr emgr = new EntryMgr();
EntryInfo einfo = new EntryInfo();

einfo = emgr.getEntryInfo(entry_id);

data  = "{";
data += "\"entry_name\":\"" + einfo.getEntry_name() + "\",";
data += "\"sch_sday\":\"" + einfo.getSch_sday() + "\",";
data += "\"sch_eday\":\"" + einfo.getSch_eday() + "\",";
data += "\"file_path\":\"" + einfo.getFile_path() + "\",";
data += "\"file_name\":\"" + einfo.getFile_name() + "\",";
data += "\"file_ext\":\"" + einfo.getFile_ext() + "\",";
data += "\"shoes_amount\":\"" + einfo.getShoes_amount() + "\",";
data += "\"shoes_name\":\"" + einfo.getShoes_name() + "\",";
data += "\"shoes_price\":\"" + einfo.getShoes_price() + "\",";
data += "\"shoes_explan\":\"" + einfo.getShoes_explan() + "\",";
data += "\"shoes_size_1\":\"" + einfo.getShoes_size_1() + "\",";
data += "\"shoes_size_2\":\"" + einfo.getShoes_size_2() + "\",";
data += "\"shoes_size_3\":\"" + einfo.getShoes_size_3() + "\",";
data += "\"shoes_size_35\":\"" + einfo.getShoes_size_35() + "\",";
data += "\"shoes_size_4\":\"" + einfo.getShoes_size_4() + "\",";
data += "\"shoes_size_45\":\"" + einfo.getShoes_size_45() + "\",";
data += "\"shoes_size_5\":\"" + einfo.getShoes_size_5() + "\",";
data += "\"shoes_size_55\":\"" + einfo.getShoes_size_55() + "\",";
data += "\"shoes_size_6\":\"" + einfo.getShoes_size_6() + "\",";
data += "\"shoes_size_65\":\"" + einfo.getShoes_size_65() + "\",";
data += "\"shoes_size_7\":\"" + einfo.getShoes_size_7() + "\",";
data += "\"shoes_size_75\":\"" + einfo.getShoes_size_75() + "\",";
data += "\"shoes_size_8\":\"" + einfo.getShoes_size_8() + "\",";
data += "\"shoes_size_85\":\"" + einfo.getShoes_size_85() + "\",";
data += "\"shoes_size_9\":\"" + einfo.getShoes_size_9() + "\",";
data += "\"shoes_size_95\":\"" + einfo.getShoes_size_95() + "\",";
data += "\"shoes_size_10\":\"" + einfo.getShoes_size_10() + "\",";
data += "\"shoes_size_105\":\"" + einfo.getShoes_size_105() + "\",";
data += "\"shoes_size_11\":\"" + einfo.getShoes_size_11() + "\",";
data += "\"shoes_size_115\":\"" + einfo.getShoes_size_115() + "\",";
data += "\"shoes_size_12\":\"" + einfo.getShoes_size_12() + "\",";
data += "\"shoes_size_125\":\"" + einfo.getShoes_size_125() + "\",";
data += "\"shoes_size_13\":\"" + einfo.getShoes_size_13() + "\",";
data += "\"shoes_size_14\":\"" + einfo.getShoes_size_14() + "\"";
data += "}";

out.println(data);
%>