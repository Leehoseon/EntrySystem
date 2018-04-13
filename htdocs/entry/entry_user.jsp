<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.shoes.comm.CommUtil" %>
<%@ page import="com.shoes.admin.entry.*" %>

<%

request.setCharacterEncoding("UTF-8");
EntryMail email = new EntryMail();
CommUtil cutil = new CommUtil();

%>

<%

String entry_id = cutil.getCheckNull(request.getParameter("entry_id"));
String user_firstname = cutil.getCheckNull(request.getParameter("user_firstname"));
String user_lastname = cutil.getCheckNull(request.getParameter("user_lastname"));
String shoes_size = cutil.getCheckNull(request.getParameter("shoes_size"));
String user_phone = cutil.getCheckNull(request.getParameter("user_phone"));
String user_mail = cutil.getCheckNull(request.getParameter("user_mail"));
String user_gender = cutil.getCheckNull(request.getParameter("user_gender"));
String user_birthday = cutil.getCheckNull(request.getParameter("user_birthday"));
String result = "";

if(entry_id.equals("") || user_firstname.equals("") || user_lastname.equals("") || shoes_size.equals("") || user_phone.equals("") || user_mail.equals("") || user_gender.equals("") || user_birthday.equals("")){
    out.println("FAIL");
    return;
}else{

    try{

      EntryMgr emgr = new EntryMgr();
      EntryInfo einfo = new EntryInfo();

      einfo.setEntry_id(entry_id);
      einfo.setUser_firstname(user_firstname);
      einfo.setUser_lastname(user_lastname);
      einfo.setShoes_size(shoes_size);
      einfo.setUser_phone(user_phone);
      einfo.setUser_mail(user_mail);
      einfo.setUser_gender(user_gender);
      einfo.setUser_birthday(user_birthday);

      result = emgr.setEntryUser(einfo);

	  if(result.equals("SUCC")){
//	      email.setEntryUserSendMail(user_mail);
	  }

      out.println(result);

    }catch(Exception e){
        System.out.println("[SHOES.ENTRY entry_user.jsp] Error = " + e.getMessage());
        return;
    }
}

%>

<!-- http://192.168.0.201:8001/stadmin/entry/entry_user.jsp?entry_id=1&user_firstname=test&user_lastname=test&shoes_size=10&user_phone=123123&user_mail=sdfsfsfsdf@sdfsdfsdf.com&user_gender=M&user_birthday=20/10/1988 -->