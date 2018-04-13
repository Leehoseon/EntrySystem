<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.shoes.comm.CommUtil" %>
<%@ page import="com.shoes.admin.entry.*" %>
<%@ page import="java.util.*" %>

<%

request.setCharacterEncoding("UTF-8");

CommUtil cutil = new CommUtil();

EntryMgr emgr = new EntryMgr();
EntryInfo einfo = new EntryInfo();
EntryInfo ainfo = new EntryInfo();
EntryMail email = new EntryMail();

ArrayList<EntryInfo> elist = new ArrayList<EntryInfo>();
ArrayList<EntryInfo> size_1 = new ArrayList<EntryInfo>();
ArrayList<EntryInfo> size_2 = new ArrayList<EntryInfo>();
ArrayList<EntryInfo> size_3 = new ArrayList<EntryInfo>();
ArrayList<EntryInfo> size_35 = new ArrayList<EntryInfo>();
ArrayList<EntryInfo> size_4 = new ArrayList<EntryInfo>();
ArrayList<EntryInfo> size_45 = new ArrayList<EntryInfo>();
ArrayList<EntryInfo> size_5 = new ArrayList<EntryInfo>();
ArrayList<EntryInfo> size_55 = new ArrayList<EntryInfo>();
ArrayList<EntryInfo> size_6 = new ArrayList<EntryInfo>();
ArrayList<EntryInfo> size_65 = new ArrayList<EntryInfo>();
ArrayList<EntryInfo> size_7 = new ArrayList<EntryInfo>();
ArrayList<EntryInfo> size_75 = new ArrayList<EntryInfo>();
ArrayList<EntryInfo> size_8 = new ArrayList<EntryInfo>();
ArrayList<EntryInfo> size_85 = new ArrayList<EntryInfo>();
ArrayList<EntryInfo> size_9 = new ArrayList<EntryInfo>();
ArrayList<EntryInfo> size_95 = new ArrayList<EntryInfo>();
ArrayList<EntryInfo> size_10 = new ArrayList<EntryInfo>();
ArrayList<EntryInfo> size_105 = new ArrayList<EntryInfo>();
ArrayList<EntryInfo> size_11 = new ArrayList<EntryInfo>();
ArrayList<EntryInfo> size_115 = new ArrayList<EntryInfo>();
ArrayList<EntryInfo> size_12 = new ArrayList<EntryInfo>();
ArrayList<EntryInfo> size_125 = new ArrayList<EntryInfo>();
ArrayList<EntryInfo> size_13 = new ArrayList<EntryInfo>();
ArrayList<EntryInfo> size_14 = new ArrayList<EntryInfo>();
ArrayList<EntryInfo> winner_list = new ArrayList<EntryInfo>();

String result = "";
ArrayList<String> winner_list_list = new ArrayList<String>();
String winner_list_mail = "";

String entry_id = cutil.getCheckNull(request.getParameter("entry_id"));

elist = emgr.getEntryUserList(entry_id);
ainfo = emgr.getEntryInfo(entry_id);

String id = "";
String size = "";
String winner_size_1 = "";
String winner_size_2 = "";
String winner_size_3 = "";
String winner_size_35 = "";
String winner_size_4 = "";
String winner_size_45 = "";
String winner_size_5 = "";
String winner_size_55 = "";
String winner_size_6 = "";
String winner_size_65 = "";
String winner_size_7 = "";
String winner_size_75 = "";
String winner_size_8 = "";
String winner_size_85 = "";
String winner_size_9 = "";
String winner_size_95 = "";
String winner_size_10 = "";
String winner_size_105 = "";
String winner_size_11 = "";
String winner_size_115 = "";
String winner_size_12 = "";
String winner_size_125 = "";
String winner_size_13 = "";
String winner_size_14 = "";

int shoes_amount_1 = Integer.parseInt(ainfo.getShoes_size_1());
int shoes_amount_2 = Integer.parseInt(ainfo.getShoes_size_2());
int shoes_amount_3 = Integer.parseInt(ainfo.getShoes_size_3());
int shoes_amount_35 = Integer.parseInt(ainfo.getShoes_size_35());
int shoes_amount_4 = Integer.parseInt(ainfo.getShoes_size_4());
int shoes_amount_45 = Integer.parseInt(ainfo.getShoes_size_45());
int shoes_amount_5 = Integer.parseInt(ainfo.getShoes_size_5());
int shoes_amount_55 = Integer.parseInt(ainfo.getShoes_size_55());
int shoes_amount_6 = Integer.parseInt(ainfo.getShoes_size_6());
int shoes_amount_65 = Integer.parseInt(ainfo.getShoes_size_65());
int shoes_amount_7 = Integer.parseInt(ainfo.getShoes_size_7());
int shoes_amount_75 = Integer.parseInt(ainfo.getShoes_size_75());
int shoes_amount_8 = Integer.parseInt(ainfo.getShoes_size_8());
int shoes_amount_85 = Integer.parseInt(ainfo.getShoes_size_85());
int shoes_amount_9 = Integer.parseInt(ainfo.getShoes_size_9());
int shoes_amount_95 = Integer.parseInt(ainfo.getShoes_size_95());
int shoes_amount_10 = Integer.parseInt(ainfo.getShoes_size_10());
int shoes_amount_105 = Integer.parseInt(ainfo.getShoes_size_105());
int shoes_amount_11 = Integer.parseInt(ainfo.getShoes_size_11());
int shoes_amount_115 = Integer.parseInt(ainfo.getShoes_size_115());
int shoes_amount_12 = Integer.parseInt(ainfo.getShoes_size_12());
int shoes_amount_125 = Integer.parseInt(ainfo.getShoes_size_125());
int shoes_amount_13 = Integer.parseInt(ainfo.getShoes_size_13());
int shoes_amount_14 = Integer.parseInt(ainfo.getShoes_size_14());

%>

<%

try{

//	for(int i = 0; i < elist.size(); i++){
//		einfo = elist.get(i);
//		id = einfo.getUser_id();
//		size = einfo.getShoes_size();
//
//		out.println(size);
//		out.println("-+-----------------------------------------------------------");
//
//
//		if(size.equals("1")){
//			size_1.add(einfo);
//		}
//		if(size.equals("2")){
//			size_2.add(einfo);
//		}
//		if(size.equals("3")){
//			size_3.add(einfo);
//		}
//		if(size.equals("35")){
//			size_35.add(einfo);
//		}
//		if(size.equals("4")){
//			size_4.add(einfo);
//		}
//		if(size.equals("45")){
//			size_45.add(einfo);
//		}
//		if(size.equals("5")){
//			size_5.add(einfo);
//		}
//		if(size.equals("55")){
//			size_55.add(einfo);
//		}
//		if(size.equals("6")){
//			size_6.add(einfo);
//		}
//		if(size.equals("65")){
//			size_65.add(einfo);
//		}
//		if(size.equals("7")){
//			size_7.add(einfo);
//		}
//		if(size.equals("75")){
//			size_75.add(einfo);
//		}
//		if(size.equals("8")){
//			size_8.add(einfo);
//		}
//		if(size.equals("85")){
//			size_85.add(einfo);
//		}
//		if(size.equals("9")){
//			size_9.add(einfo);
//		}
//		if(size.equals("95")){
//			size_95.add(einfo);
//		}
//		if(size.equals("10")){
//			size_10.add(einfo);
//		}
//		if(size.equals("105")){
//			size_105.add(einfo);
//		}
//		if(size.equals("11")){
//			size_11.add(einfo);
//		}
//		if(size.equals("115")){
//			size_115.add(einfo);
//		}
//		if(size.equals("12")){
//			size_12.add(einfo);
//		}
//		if(size.equals("125")){
//			size_125.add(einfo);
//		}
//		if(size.equals("13")){
//			size_13.add(einfo);
//		}
//		if(size.equals("14")){
//			size_14.add(einfo);
//		}
//	
//	}
//
//	winner_size_1 += cutil.setEntryWinner(size_1,shoes_amount_1);
//	out.println(winner_size_1+"(1)");
//	winner_size_2 += cutil.setEntryWinner(size_2,shoes_amount_2);
//	out.println(winner_size_2+"(2)");
//	winner_size_3 += cutil.setEntryWinner(size_3,shoes_amount_3);
//	out.println(winner_size_3+"(3)");
//	winner_size_35 += cutil.setEntryWinner(size_35,shoes_amount_35);
//	out.println(winner_size_35+"(35)");
//	winner_size_4 += cutil.setEntryWinner(size_4,shoes_amount_4);
//	out.println(winner_size_4+"(4)");
//	winner_size_45 += cutil.setEntryWinner(size_45,shoes_amount_45);
//	out.println(winner_size_45+"(45)");
//	winner_size_5 += cutil.setEntryWinner(size_5,shoes_amount_5);
//	out.println(winner_size_5+"(5)");
//	winner_size_55 += cutil.setEntryWinner(size_55,shoes_amount_55);
//	out.println(winner_size_55+"(55)");
//	winner_size_6 += cutil.setEntryWinner(size_6,shoes_amount_6);
//	out.println(winner_size_6+"(6)");
//	winner_size_65 += cutil.setEntryWinner(size_65,shoes_amount_65);
//	out.println(winner_size_65+"(65)");
//	winner_size_7 += cutil.setEntryWinner(size_7,shoes_amount_7);
//	out.println(winner_size_7+"(7)");
//	winner_size_75 += cutil.setEntryWinner(size_75,shoes_amount_75);
//	out.println(winner_size_75+"(75)");
//	winner_size_8 += cutil.setEntryWinner(size_8,shoes_amount_8);
//	out.println(winner_size_8+"(8)");
//	winner_size_85 += cutil.setEntryWinner(size_85,shoes_amount_85);
//	out.println(winner_size_85+"(85)");
//	winner_size_9 += cutil.setEntryWinner(size_9,shoes_amount_9);
//	out.println(winner_size_9+"(9)");
//	winner_size_95 += cutil.setEntryWinner(size_95,shoes_amount_95);
//	out.println(winner_size_95+"(95)");
//	winner_size_10 += cutil.setEntryWinner(size_10,shoes_amount_10);
//	out.println(winner_size_10+"(10)");
//	winner_size_105 += cutil.setEntryWinner(size_105,shoes_amount_105);
//	out.println(winner_size_105+"(105)");
//	winner_size_11 += cutil.setEntryWinner(size_11,shoes_amount_11);
//	out.println(winner_size_11+"(11)");
//	winner_size_115 += cutil.setEntryWinner(size_115,shoes_amount_115);
//	out.println(winner_size_115+"(115)");
//	winner_size_12 = cutil.setEntryWinner(size_12,shoes_amount_12);
//	out.println(winner_size_12+"(12)");
//	winner_size_125 += cutil.setEntryWinner(size_125,shoes_amount_125);
//	out.println(winner_size_125+"(125)");
//	winner_size_13 += cutil.setEntryWinner(size_13,shoes_amount_13);
//	out.println(winner_size_13+"(13)");
//	winner_size_14 += cutil.setEntryWinner(size_14,shoes_amount_14);
//	out.println(winner_size_14+"(14)");
//	
//	if(!winner_size_1.equals("")){
//		result = emgr.setEntryWinner(entry_id,"1",winner_size_1);
//	}
//	if(!winner_size_2.equals("")){
//		result = emgr.setEntryWinner(entry_id,"2",winner_size_2);
//	}
//	if(!winner_size_3.equals("")){
//		result = emgr.setEntryWinner(entry_id,"3",winner_size_3);
//	}
//	if(!winner_size_35.equals("")){
//		result = emgr.setEntryWinner(entry_id,"35",winner_size_35);
//	}
//	if(!winner_size_4.equals("")){
//		result = emgr.setEntryWinner(entry_id,"4",winner_size_4);
//	}
//	if(!winner_size_45.equals("")){
//		result = emgr.setEntryWinner(entry_id,"45",winner_size_45);
//	}
//	if(!winner_size_5.equals("")){
//		result = emgr.setEntryWinner(entry_id,"5",winner_size_5);
//	}
//	if(!winner_size_55.equals("")){
//		result = emgr.setEntryWinner(entry_id,"55",winner_size_55);
//	}
//	if(!winner_size_6.equals("")){
//		result = emgr.setEntryWinner(entry_id,"6",winner_size_6);
//	}
//	if(!winner_size_65.equals("")){
//		result = emgr.setEntryWinner(entry_id,"65",winner_size_65);
//	}
//	if(!winner_size_7.equals("")){
//		result = emgr.setEntryWinner(entry_id,"7",winner_size_7);
//	}
//	if(!winner_size_75.equals("")){
//		result = emgr.setEntryWinner(entry_id,"75",winner_size_75);
//	}
//	if(!winner_size_8.equals("")){
//		result = emgr.setEntryWinner(entry_id,"8",winner_size_8);
//	}
//	if(!winner_size_85.equals("")){
//		result = emgr.setEntryWinner(entry_id,"85",winner_size_85);
//	}
//	if(!winner_size_9.equals("")){
//		result = emgr.setEntryWinner(entry_id,"9",winner_size_9);
//	}
//	if(!winner_size_95.equals("")){
//		result = emgr.setEntryWinner(entry_id,"95",winner_size_95);
//	}
//	if(!winner_size_10.equals("")){
//		result = emgr.setEntryWinner(entry_id,"10",winner_size_10);
//	}
//	if(!winner_size_105.equals("")){
//		result = emgr.setEntryWinner(entry_id,"105",winner_size_105);
//	}
//	if(!winner_size_11.equals("")){
//		result = emgr.setEntryWinner(entry_id,"11",winner_size_11);
//	}
//	if(!winner_size_115.equals("")){
//		result = emgr.setEntryWinner(entry_id,"115",winner_size_115);
//	}
//	if(!winner_size_12.equals("")){
//		result = emgr.setEntryWinner(entry_id,"12",winner_size_12);
//	}
//	if(!winner_size_125.equals("")){
//		result = emgr.setEntryWinner(entry_id,"125",winner_size_125);
//	}
//	if(!winner_size_13.equals("")){
//		result = emgr.setEntryWinner(entry_id,"13",winner_size_13);
//	}
//	if(!winner_size_14.equals("")){
//		result = emgr.setEntryWinner(entry_id,"14",winner_size_14);
//	}
	result = "SUCC";

	if(result.equals("SUCC")){
		winner_list = emgr.getEntryWinnerList(entry_id);

		for(EntryInfo winfo : winner_list){
			winner_list_mail = winfo.getUser_mail();
			winner_list_list.add(winner_list_mail);
		}
		email.setEntryUserSendMail(winner_list_list);
		out.println(winner_list_list.get(23));

//		out.println(cutil.getGoUrl("Successfully registered.","entry_list.jsp","PARENT"));
	}else{
//		out.println(cutil.getGoUrl("Registration failed.","entry_list.jsp","PARENT"));
	}

}catch(Exception e){
    System.out.println("[SHOES.ENTRY entry_win.jsp] Error = " + e.getMessage());
    return;
}


%>
