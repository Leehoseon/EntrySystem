<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.shoes.comm.CommUtil" %>
<%@ page import="java.io.File"%>
<%@ page import="java.util.*" %>
<%@ page import="com.oreilly.servlet.MultipartRequest,com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page import="com.shoes.admin.entry.*" %>
<%@ include file="../include/config.jsp" %>
<%@ include file="../include/logincheck.jsp" %>

<%

request.setCharacterEncoding("UTF-8");

CommUtil cutil = new CommUtil();

%>

<%
try{
    //file download start
    MultipartRequest multi = new MultipartRequest(request,gl_path_tempfile,gl_file_limit,"UTF-8",new DefaultFileRenamePolicy());
    //file download end

	String insertResult = ""; 
	String entryName = cutil.getCheckNull(multi.getParameter("con_name"));
	String entryStartDay = cutil.getCheckNull(multi.getParameter("sch_sday"));
	String entryEndDay = cutil.getCheckNull(multi.getParameter("sch_eday"));
	String entryOpenDay = cutil.getCheckNull(multi.getParameter("sch_oday"));
	String mode = cutil.getCheckNull(multi.getParameter("mode"));
	String entry_id = cutil.getCheckNull(multi.getParameter("entry_id"));
	String file_name = cutil.getCheckNull(multi.getParameter("file_name"));
	String kiosk_id = cutil.getCheckNull(multi.getParameter("kiosk_id"));
	String entry_status = cutil.getCheckNull(multi.getParameter("entry_status"));
	String shoes_amount_1 = cutil.getCheckNull(multi.getParameter("shoes_amount_1"));
	String shoes_amount_2 = cutil.getCheckNull(multi.getParameter("shoes_amount_2"));
	String shoes_amount_3 = cutil.getCheckNull(multi.getParameter("shoes_amount_3"));
	String shoes_amount_35 = cutil.getCheckNull(multi.getParameter("shoes_amount_35"));
	String shoes_amount_4 = cutil.getCheckNull(multi.getParameter("shoes_amount_4"));
	String shoes_amount_45 = cutil.getCheckNull(multi.getParameter("shoes_amount_45"));
	String shoes_amount_5 = cutil.getCheckNull(multi.getParameter("shoes_amount_5"));
	String shoes_amount_55 = cutil.getCheckNull(multi.getParameter("shoes_amount_55"));
	String shoes_amount_6 = cutil.getCheckNull(multi.getParameter("shoes_amount_6"));
	String shoes_amount_65 = cutil.getCheckNull(multi.getParameter("shoes_amount_65"));
	String shoes_amount_7 = cutil.getCheckNull(multi.getParameter("shoes_amount_7"));
	String shoes_amount_75 = cutil.getCheckNull(multi.getParameter("shoes_amount_75"));
	String shoes_amount_8 = cutil.getCheckNull(multi.getParameter("shoes_amount_8"));
	String shoes_amount_85 = cutil.getCheckNull(multi.getParameter("shoes_amount_85"));
	String shoes_amount_9 = cutil.getCheckNull(multi.getParameter("shoes_amount_9"));
	String shoes_amount_95 = cutil.getCheckNull(multi.getParameter("shoes_amount_95"));
	String shoes_amount_10 = cutil.getCheckNull(multi.getParameter("shoes_amount_10"));
	String shoes_amount_105 = cutil.getCheckNull(multi.getParameter("shoes_amount_105"));
	String shoes_amount_11 = cutil.getCheckNull(multi.getParameter("shoes_amount_11"));
	String shoes_amount_115 = cutil.getCheckNull(multi.getParameter("shoes_amount_115"));
	String shoes_amount_12 = cutil.getCheckNull(multi.getParameter("shoes_amount_12"));
	String shoes_amount_125 = cutil.getCheckNull(multi.getParameter("shoes_amount_125"));
	String shoes_amount_13 = cutil.getCheckNull(multi.getParameter("shoes_amount_13"));
	String shoes_amount_14 = cutil.getCheckNull(multi.getParameter("shoes_amount_14"));
	String shoes_name = cutil.getCheckNull(multi.getParameter("shoes_name"));
	String shoes_price = cutil.getCheckNull(multi.getParameter("shoes_price"));
	String shoes_explan = cutil.getCheckNull(multi.getParameter("shoes_explan"));
	String open_status = cutil.getCheckNull(multi.getParameter("open_status"));

	EntryMgr emgr = new EntryMgr();
	EntryInfo einfo = new EntryInfo();
	
	String result = "FAIL";
    String attfilename = "";
    String file_tmptype = "";
    String formName = "";
    File objfile = null;
    int file_size = 0;
    String file_mode = "NO";
    Enumeration formNames=multi.getFileNames();

    while(formNames.hasMoreElements()){
        formName = (String)formNames.nextElement();
        attfilename = multi.getFilesystemName(formName);

        if(attfilename != null){
            objfile = multi.getFile(formName);
            file_size = (int)objfile.length();

            einfo.setFile_realname(attfilename);
            einfo.setFile_ext(cutil.getFileExt(attfilename).toLowerCase());
            einfo.setFile_size(file_size);

            file_mode = "YES";
        }
    }

	if(mode.equals("INSERT")){

		String[] entryStartDayArr = entryStartDay.split("-");
        String[] entryEndDayArr = entryEndDay.split("-");
		String[] entryOpenDayArr = entryOpenDay.split("-");
        String entryStartDayResult = "";
        String entryEndDayResult = "";
		String entryOpenDayResult = "";

        for(int i = 0; i < entryStartDayArr.length; i++){
            entryStartDayResult += entryStartDayArr[i];
            entryEndDayResult += entryEndDayArr[i];
			entryOpenDayResult += entryOpenDayArr[i];
        }
		out.println(entryOpenDayResult);
        einfo.setEntry_name(entryName);
        einfo.setSch_sday(entryStartDayResult);
        einfo.setSch_eday(entryEndDayResult);
		einfo.setSch_oday(entryOpenDayResult);
        einfo.setUser_id(ss_user_id);
        einfo.setFile_path(gl_path_entry_file);
        einfo.setShoes_size_1(shoes_amount_1);
        einfo.setShoes_size_2(shoes_amount_2);
        einfo.setShoes_size_3(shoes_amount_3);
        einfo.setShoes_size_35(shoes_amount_35);
        einfo.setShoes_size_4(shoes_amount_4);
        einfo.setShoes_size_45(shoes_amount_45);
        einfo.setShoes_size_5(shoes_amount_5);
        einfo.setShoes_size_55(shoes_amount_55);
        einfo.setShoes_size_6(shoes_amount_6);
        einfo.setShoes_size_65(shoes_amount_65);
        einfo.setShoes_size_7(shoes_amount_7);
        einfo.setShoes_size_75(shoes_amount_75);
        einfo.setShoes_size_8(shoes_amount_8);
        einfo.setShoes_size_85(shoes_amount_85);
        einfo.setShoes_size_9(shoes_amount_9);
        einfo.setShoes_size_95(shoes_amount_95);
        einfo.setShoes_size_10(shoes_amount_10);
        einfo.setShoes_size_105(shoes_amount_105);
        einfo.setShoes_size_11(shoes_amount_11);
        einfo.setShoes_size_115(shoes_amount_115);
        einfo.setShoes_size_12(shoes_amount_12);
        einfo.setShoes_size_125(shoes_amount_125);
        einfo.setShoes_size_13(shoes_amount_13);
        einfo.setShoes_size_14(shoes_amount_14);
        einfo.setShoes_name(shoes_name);
        einfo.setShoes_price(shoes_price);
        einfo.setShoes_explan(shoes_explan);


        result = emgr.setEntryInsert(einfo,file_mode,gl_path_entry_file,gl_path_tempfile);

        if(result.equals("SUCC")){
            out.println(cutil.getGoUrl("Successfully registered.","entry_list.jsp","PARENT"));
        }else{
            out.println(cutil.getGoUrl("Registration failed.","entry_list.jsp","PARENT"));
        }
    }

	if(mode.equals("DELETE")){

		einfo.setDel_id(ss_user_id);
		einfo.setEntry_id(entry_id);
		einfo.setFile_name(file_name);

        result = emgr.setEntryDelete(einfo,gl_path_entry_file);

        if(result.equals("SUCC")){
            out.println(cutil.getGoUrl("Successfully registered.","entry_list.jsp","PARENT"));
        }else{
            out.println(cutil.getGoUrl("Registration failed.","entry_list.jsp","PARENT"));
        }
    }

	if(mode.equals("UPDATE")){

		String[] entryStartDayArr = entryStartDay.split("-");
        String[] entryEndDayArr = entryEndDay.split("-");
        String entryStartDayResult = "";
        String entryEndDayResult = "";

        for(int i = 0; i < entryStartDayArr.length; i++){
            entryStartDayResult += entryStartDayArr[i];
            entryEndDayResult += entryEndDayArr[i];
        }

      einfo.setUpd_id(ss_user_id);
      einfo.setEntry_name(entryName);
      einfo.setSch_sday(entryStartDayResult);
      einfo.setSch_eday(entryEndDayResult);
      einfo.setEntry_id(entry_id);
      einfo.setShoes_size_1(shoes_amount_1);
      einfo.setShoes_size_2(shoes_amount_2);
      einfo.setShoes_size_3(shoes_amount_3);
      einfo.setShoes_size_35(shoes_amount_35);
      einfo.setShoes_size_4(shoes_amount_4);
      einfo.setShoes_size_45(shoes_amount_45);
      einfo.setShoes_size_5(shoes_amount_5);
      einfo.setShoes_size_55(shoes_amount_55);
      einfo.setShoes_size_6(shoes_amount_6);
      einfo.setShoes_size_65(shoes_amount_65);
      einfo.setShoes_size_7(shoes_amount_7);
      einfo.setShoes_size_75(shoes_amount_75);
      einfo.setShoes_size_8(shoes_amount_8);
      einfo.setShoes_size_85(shoes_amount_85);
      einfo.setShoes_size_9(shoes_amount_9);
      einfo.setShoes_size_95(shoes_amount_95);
      einfo.setShoes_size_10(shoes_amount_10);
      einfo.setShoes_size_105(shoes_amount_105);
      einfo.setShoes_size_11(shoes_amount_11);
      einfo.setShoes_size_115(shoes_amount_115);
      einfo.setShoes_size_12(shoes_amount_12);
      einfo.setShoes_size_125(shoes_amount_125);
      einfo.setShoes_size_13(shoes_amount_13);
      einfo.setShoes_size_14(shoes_amount_14);
      einfo.setShoes_name(shoes_name);
      einfo.setShoes_price(shoes_price);
      einfo.setShoes_explan(shoes_explan);

      if(file_mode == "YES"){
        einfo.setFile_path("/zcommonfiles/entry/");
        einfo.setFile_name(file_name);
      }else{
        einfo.setFile_path("");
        einfo.setFile_name("");
      }

        result = emgr.setEntryUpdate(einfo,gl_path_entry_file,file_mode,gl_path_tempfile);

        if(result.equals("SUCC")){
            out.println(cutil.getGoUrl("Successfully registered.","entry_list.jsp","PARENT"));
        }else{
            out.println(cutil.getGoUrl("Registration failed.","entry_list.jsp","PARENT"));
        }
    }

	if(mode.equals("KIOSKUPDATE")){

		if(entry_status.equals("true")){
			entry_status = "K";
		}else{
			entry_status = "B";
		}

		if(open_status.equals("true")){
			open_status = "O";
		}else{
			open_status = "A";
		}

        result = emgr.setKioskEntryStatus(entry_id,entry_status,kiosk_id,open_status);

        if(result.equals("SUCC")){
            out.println(cutil.getGoUrl("Successfully registered.","entry_list.jsp","PARENT"));
        }else{
            out.println(cutil.getGoUrl("Registration failed.","entry_list.jsp","PARENT"));
        }
    }

}catch(Exception e){
    System.out.println("[SHOES.ENTRY entry_action.jsp] Error = " + e.getMessage());
    out.println(cutil.getGoUrl("Fail","","NOMOVE"));
    return;
}
%>
