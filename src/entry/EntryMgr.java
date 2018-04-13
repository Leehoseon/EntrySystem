package com.shoes.admin.entry;

import com.shoes.admin.kiosk.KioskInfo;
import com.shoes.comm.DBConnectMgr;
import com.shoes.comm.CommUtil;
import java.sql.*;
import java.io.File;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.PreparedStatement;
import java.util.ArrayList;

public class EntryMgr{
    
    //엔트리 등록
    public String setEntryInsert(EntryInfo einfo,String file_mode,String gl_path_entry_file,String gl_path_tempfile){

        String retstr = "FAIL";
        DBConnectMgr ConnectMgr = new DBConnectMgr();
        Connection conn = null;
        PreparedStatement pstmt = null;
        PreparedStatement pstmtCheck = null;
        PreparedStatement pstmtUserStatus = null;
        ResultSet rs = null;
        StringBuffer query = new StringBuffer();
        StringBuffer checkQuery = new StringBuffer();
        StringBuffer UserStatusQuery = new StringBuffer();

        query.append(" INSERT INTO TB_ENTRY ");
        query.append(" (ENTRY_NAME,SCH_SDAY,SCH_EDAY,SCH_ODAY,REG_ID, ");
        query.append(" SHOES_SIZE_1,SHOES_SIZE_2,SHOES_SIZE_3,SHOES_SIZE_35,SHOES_SIZE_4,SHOES_SIZE_45,SHOES_SIZE_5,SHOES_SIZE_55,SHOES_SIZE_6,SHOES_SIZE_65,SHOES_SIZE_7,SHOES_SIZE_75, ");
        query.append(" SHOES_SIZE_8,SHOES_SIZE_85,SHOES_SIZE_9,SHOES_SIZE_95,SHOES_SIZE_10,SHOES_SIZE_105,SHOES_SIZE_11,SHOES_SIZE_115,SHOES_SIZE_12,SHOES_SIZE_125,SHOES_SIZE_13,SHOES_SIZE_14, ");
        query.append(" SHOES_NAME,SHOES_PRICE,SHOES_EXPLAN, ");
        query.append(" FILE_REALNAME,FILE_EXT,FILE_SIZE,FILE_PATH,FILE_NAME, ");
        query.append(" DB_STATUS,REG_DATE) ");
        query.append(" VALUES ");
        query.append(" (?,?,?,?,?, ");
        query.append(" ?,?,?,?,?,?,?,?,?,?,?,?, ");
        query.append(" ?,?,?,?,?,?,?,?,?,?,?,?, ");
        query.append(" ?,?,?, ");
        query.append(" ?,?,?,?,?, ");
        query.append(" 'A',GETDATE()) ");

        checkQuery.append(" SELECT MAX(ENTRY_ID) FROM TB_ENTRY ");

        UserStatusQuery.append(" UPDATE TB_ENTRY_WINNER SET CHOICE_STATUS = 'C' ");

        int x = 0;
        try{
            conn = ConnectMgr.getConnection();
            conn.setAutoCommit(false);

            try{
                retstr = "SUCC";
                pstmtCheck = conn.prepareStatement(checkQuery.toString());
                rs = pstmtCheck.executeQuery();
                pstmt = conn.prepareStatement(query.toString());
                pstmt.setString(++x,einfo.getEntry_name());
                pstmt.setString(++x,einfo.getSch_sday());
                pstmt.setString(++x,einfo.getSch_eday());
                pstmt.setString(++x,einfo.getSch_oday());
                pstmt.setString(++x,einfo.getUser_id());
                pstmt.setString(++x,einfo.getShoes_size_1());
                pstmt.setString(++x,einfo.getShoes_size_2());
                pstmt.setString(++x,einfo.getShoes_size_3());
                pstmt.setString(++x,einfo.getShoes_size_35());
                pstmt.setString(++x,einfo.getShoes_size_4());
                pstmt.setString(++x,einfo.getShoes_size_45());
                pstmt.setString(++x,einfo.getShoes_size_5());
                pstmt.setString(++x,einfo.getShoes_size_55());
                pstmt.setString(++x,einfo.getShoes_size_6());
                pstmt.setString(++x,einfo.getShoes_size_65());
                pstmt.setString(++x,einfo.getShoes_size_7());
                pstmt.setString(++x,einfo.getShoes_size_75());
                pstmt.setString(++x,einfo.getShoes_size_8());
                pstmt.setString(++x,einfo.getShoes_size_85());
                pstmt.setString(++x,einfo.getShoes_size_9());
                pstmt.setString(++x,einfo.getShoes_size_95());
                pstmt.setString(++x,einfo.getShoes_size_10());
                pstmt.setString(++x,einfo.getShoes_size_105());
                pstmt.setString(++x,einfo.getShoes_size_11());
                pstmt.setString(++x,einfo.getShoes_size_115());
                pstmt.setString(++x,einfo.getShoes_size_12());
                pstmt.setString(++x,einfo.getShoes_size_125());
                pstmt.setString(++x,einfo.getShoes_size_13());
                pstmt.setString(++x,einfo.getShoes_size_14());
                pstmt.setString(++x,einfo.getShoes_name());
                pstmt.setString(++x,einfo.getShoes_price());
                pstmt.setString(++x,einfo.getShoes_explan());

                if(file_mode.equals("YES")){
                    String file_retstr = "";
                    try{
                        int i_user_id = 0;
                        
                        if(rs.next()){
                            i_user_id = rs.getInt(1); 
                            i_user_id++;
                        }
                        
                        String convert_user_id = "";
                        String file_path = "";
                        String old_file = "";
                        String new_file_name = "";
                        String new_file_path = "";

                        convert_user_id = String.format("E%08d",i_user_id);

                        old_file = gl_path_tempfile + einfo.getFile_realname();
                        new_file_name = convert_user_id + einfo.getFile_ext();
                        new_file_path = gl_path_entry_file + new_file_name;

                        File dir = new File(gl_path_entry_file);
                        if(!dir.isDirectory()){
                            dir.mkdirs();
                        }
                        if(!new CommUtil().setMoveFile(old_file,new_file_path,true).equals("SUCC")){
                            file_retstr = "FAIL-MOVEFILE";
                        }else{
                            file_retstr = "SUCC";

                            pstmt.setString(++x,einfo.getFile_realname());
                            pstmt.setString(++x,einfo.getFile_ext());
                            pstmt.setString(++x,einfo.getFile_size()+"");
                            pstmt.setString(++x,"/zcommonfiles/entry/");
                            pstmt.setString(++x,new_file_name);
                        }
                        
                    }catch(Exception e0){
                        file_retstr = "FAIL";
                        conn.rollback();
                        System.err.println("["+ new CommUtil().getDebugDate("KOR","") +"][SHOES.EntryMgr] setEntryInsert() FILEMOVE :: " + e0.getMessage());
                    }
                                              
                }else{
                    pstmt.setString(++x,"");
                    pstmt.setString(++x,"");
                    pstmt.setString(++x,"");
                    pstmt.setString(++x,"");
                    pstmt.setString(++x,"");
                }
                pstmt.executeUpdate();

                pstmtUserStatus = conn.prepareStatement(UserStatusQuery.toString());
                pstmtUserStatus.executeUpdate();
                
            }catch(Exception e0){
                retstr = "FAIL";
                conn.rollback();
                System.err.println("["+ new CommUtil().getDebugDate("KOR","") +"][SHOES.EntryMgr] setEntryInsert() sql :: " + e0.getMessage());
            }
            conn.commit();
            conn.close();
        }catch(Exception e0){
            retstr = "FAIL";
            System.err.println("["+ new CommUtil().getDebugDate("KOR","") +"][SHOES.EntryMgr] setEntryInsert() DBConnect :: " + e0.getMessage());
        }finally{
            if(rs != null){try{rs.close();}catch (Exception SQL2){ System.err.println(SQL2.getMessage());}}
            if(pstmt != null){try{pstmt.close();}catch (Exception SQL3){ System.err.println(SQL3.getMessage());}}
            if(conn != null){try{conn.close();}catch(Exception e){System.err.println("[shoes.DBConnectMgr] freeConnection() :: "+ e.getMessage());}}
        }
        return retstr;
    }

    //엔트리 리스트 카운트
    public int getEntryListCnt(){

        DBConnectMgr ConnectMgr = new DBConnectMgr();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        StringBuffer query = new StringBuffer();   
        int total_cnt = 0;

        query.append(" SELECT ");
        query.append(" COUNT(*) ");
        query.append(" FROM TB_ENTRY ");
        query.append(" WHERE DB_STATUS = 'A' ");

        try{
            conn = ConnectMgr.getConnection();
            conn.setAutoCommit(false);
            try{
                pstmt = conn.prepareStatement(query.toString());
                rs = pstmt.executeQuery();
                if(rs.next()){
                    total_cnt = rs.getInt(1); 
                }
               
            }catch(Exception e0){
                System.err.println("["+ new CommUtil().getDebugDate("KOR","") +"][SHOES.EntryMgr] getEntryListCnt() sql :: " + e0.getMessage());
            }
            conn.close();
        }catch(Exception e0){
            System.err.println("["+ new CommUtil().getDebugDate("KOR","") +"][SHOES.EntryMgr] getEntryListCnt() DBConnect :: " + e0.getMessage());
        }finally{
            if(rs != null){try{rs.close();}catch (Exception SQL2){ System.err.println(SQL2.getMessage());}}
            if(pstmt != null){try{pstmt.close();}catch (Exception SQL3){ System.err.println(SQL3.getMessage());}}
            if(conn != null){try{conn.close();}catch(Exception e){System.err.println("[shoes.DBConnectMgr] freeConnection() :: "+ e.getMessage());}}
        }
        return total_cnt;
    }
    
    //엔트리 리스트 가져오기
    public ArrayList<EntryInfo> getEntryList(int i_page,int i_pagesize){

        DBConnectMgr ConnectMgr = new DBConnectMgr();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        StringBuffer query = new StringBuffer();   
        ArrayList<EntryInfo> elist = new ArrayList<EntryInfo>();

        query.append(" SELECT TOP (1) ");
        query.append(" A.ENTRY_ID,A.ENTRY_NAME,A.SCH_SDAY,A.SCH_EDAY,A.WINNER_CHOICE, ");
        query.append(" (SELECT COUNT(*) FROM TB_ENTRY_USER B WHERE A.ENTRY_ID = B.ENTRY_ID) AS TOTAL_CNT ");
        query.append(" FROM TB_ENTRY A WHERE A.DB_STATUS = 'A' ");
        query.append(" ORDER BY ENTRY_ID DESC ");

        i_page = (i_page - 1) * i_pagesize;

        int x = 0;
        try{
            conn = ConnectMgr.getConnection();
            conn.setAutoCommit(false);
            try{
                pstmt = conn.prepareStatement(query.toString());
                rs = pstmt.executeQuery();

                while(rs.next()){
                    EntryInfo einfo = new EntryInfo();
                    einfo.setEntry_id(rs.getString("ENTRY_ID"));
                    einfo.setEntry_name(rs.getString("ENTRY_NAME"));
                    einfo.setSch_sday(rs.getString("SCH_SDAY"));
                    einfo.setSch_eday(rs.getString("SCH_EDAY"));
                    einfo.setTotal_cnt(rs.getString("TOTAL_CNT"));
                    einfo.setWinner_choice(rs.getString("WINNER_CHOICE"));
                    elist.add(einfo);
                }
               
            }catch(Exception e0){
                System.err.println("["+ new CommUtil().getDebugDate("KOR","") +"][SHOES.EntryMgr] getEntryList() sql :: " + e0.getMessage());
            }
            conn.close();
        }catch(Exception e0){
            System.err.println("["+ new CommUtil().getDebugDate("KOR","") +"][SHOES.EntryMgr] getEntryList() DBConnect :: " + e0.getMessage());
        }finally{
            if(rs != null){try{rs.close();}catch (Exception SQL2){ System.err.println(SQL2.getMessage());}}
            if(pstmt != null){try{pstmt.close();}catch (Exception SQL3){ System.err.println(SQL3.getMessage());}}
            if(conn != null){try{conn.close();}catch(Exception e){System.err.println("[shoes.DBConnectMgr] freeConnection() :: "+ e.getMessage());}}
        }
        return elist;
    }
    
    //엔트리 정보 가져오기
    public EntryInfo getEntryInfo(String user_id){

        DBConnectMgr ConnectMgr = new DBConnectMgr();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        StringBuffer query = new StringBuffer();   
        EntryInfo einfo = new EntryInfo();

        query.append(" SELECT ");
        query.append(" ENTRY_NAME,SCH_SDAY,SCH_EDAY,SHOES_NAME,SHOES_PRICE,SHOES_EXPLAN, ");
        query.append(" SHOES_SIZE_1,SHOES_SIZE_2,SHOES_SIZE_3,SHOES_SIZE_35,SHOES_SIZE_4,SHOES_SIZE_45,SHOES_SIZE_5,SHOES_SIZE_55, ");
        query.append(" SHOES_SIZE_6,SHOES_SIZE_65,SHOES_SIZE_7,SHOES_SIZE_75,SHOES_SIZE_8,SHOES_SIZE_85,SHOES_SIZE_9,SHOES_SIZE_95,SHOES_SIZE_10,SHOES_SIZE_105, ");
        query.append(" SHOES_SIZE_11,SHOES_SIZE_115,SHOES_SIZE_12,SHOES_SIZE_125,SHOES_SIZE_13,SHOES_SIZE_14, ");
        query.append(" FILE_PATH,FILE_NAME,FILE_EXT ");
        query.append(" FROM ");
        query.append(" TB_ENTRY ");
        query.append(" WHERE ENTRY_ID = ? ");

        int x = 0;
        try{
            conn = ConnectMgr.getConnection();
            conn.setAutoCommit(false);
            try{
                pstmt = conn.prepareStatement(query.toString());
                pstmt.setString(++x,user_id);
                rs = pstmt.executeQuery();

                if(rs.next()){                    
                    einfo.setEntry_name(rs.getString("ENTRY_NAME"));
                    einfo.setSch_sday(rs.getString("SCH_SDAY"));
                    einfo.setSch_eday(rs.getString("SCH_EDAY"));
                    einfo.setShoes_name(rs.getString("SHOES_NAME"));
                    einfo.setShoes_price(rs.getString("SHOES_PRICE"));
                    einfo.setShoes_explan(rs.getString("SHOES_EXPLAN"));
                    einfo.setShoes_size_1(rs.getString("SHOES_SIZE_1"));
                    einfo.setShoes_size_2(rs.getString("SHOES_SIZE_2"));
                    einfo.setShoes_size_3(rs.getString("SHOES_SIZE_3"));
                    einfo.setShoes_size_35(rs.getString("SHOES_SIZE_35"));
                    einfo.setShoes_size_4(rs.getString("SHOES_SIZE_4"));
                    einfo.setShoes_size_45(rs.getString("SHOES_SIZE_45"));
                    einfo.setShoes_size_5(rs.getString("SHOES_SIZE_5"));
                    einfo.setShoes_size_55(rs.getString("SHOES_SIZE_55"));
                    einfo.setShoes_size_6(rs.getString("SHOES_SIZE_6"));
                    einfo.setShoes_size_65(rs.getString("SHOES_SIZE_65"));
                    einfo.setShoes_size_7(rs.getString("SHOES_SIZE_7"));
                    einfo.setShoes_size_75(rs.getString("SHOES_SIZE_75"));
                    einfo.setShoes_size_8(rs.getString("SHOES_SIZE_8"));
                    einfo.setShoes_size_85(rs.getString("SHOES_SIZE_85"));
                    einfo.setShoes_size_9(rs.getString("SHOES_SIZE_9"));
                    einfo.setShoes_size_95(rs.getString("SHOES_SIZE_95"));
                    einfo.setShoes_size_10(rs.getString("SHOES_SIZE_10"));
                    einfo.setShoes_size_105(rs.getString("SHOES_SIZE_105"));
                    einfo.setShoes_size_11(rs.getString("SHOES_SIZE_11"));
                    einfo.setShoes_size_115(rs.getString("SHOES_SIZE_115"));
                    einfo.setShoes_size_12(rs.getString("SHOES_SIZE_12"));
                    einfo.setShoes_size_125(rs.getString("SHOES_SIZE_125"));
                    einfo.setShoes_size_13(rs.getString("SHOES_SIZE_13"));
                    einfo.setShoes_size_14(rs.getString("SHOES_SIZE_14"));                 
                    einfo.setFile_path(rs.getString("FILE_PATH"));
                    einfo.setFile_name(rs.getString("FILE_NAME"));
                    einfo.setFile_ext(rs.getString("FILE_EXT"));
                }
               
            }catch(Exception e0){
                System.err.println("["+ new CommUtil().getDebugDate("KOR","") +"][SHOES.EntryMgr] getEntryInfo() sql :: " + e0.getMessage());
            }
            conn.close();
        }catch(Exception e0){
            System.err.println("["+ new CommUtil().getDebugDate("KOR","") +"][SHOES.EntryMgr] getEntryInfo() DBConnect :: " + e0.getMessage());
        }finally{
            if(rs != null){try{rs.close();}catch (Exception SQL2){ System.err.println(SQL2.getMessage());}}
            if(pstmt != null){try{pstmt.close();}catch (Exception SQL3){ System.err.println(SQL3.getMessage());}}
            if(conn != null){try{conn.close();}catch(Exception e){System.err.println("[shoes.DBConnectMgr] freeConnection() :: "+ e.getMessage());}}
        }
        return einfo;
    }
    
    //엔트리 수정
    public String setEntryUpdate(EntryInfo einfo,String gl_path_entry_file,String file_mode,String gl_path_tempfile){

        String retstr = "FAIL";
        DBConnectMgr ConnectMgr = new DBConnectMgr();
        Connection conn = null;
        PreparedStatement pstmt = null;
        PreparedStatement pstmtCheck = null;
        ResultSet rs = null;
        StringBuffer query = new StringBuffer();   
        StringBuffer checkQuery = new StringBuffer();
        checkQuery.append(" SELECT MAX(ENTRY_ID) FROM TB_ENTRY ");
        
        if(file_mode.equals("YES")){
         
            query.append(" UPDATE ");
            query.append(" TB_ENTRY SET ENTRY_NAME = ?, SCH_SDAY = ?, SCH_EDAY = ?,UPD_DATE = GETDATE(), ");
            query.append(" UPD_ID = ?, SHOES_SIZE_1 = ?, SHOES_SIZE_2 = ?, SHOES_SIZE_3 = ?, SHOES_SIZE_35 = ?, ");
            query.append(" SHOES_SIZE_4 = ?, SHOES_SIZE_45 = ?, SHOES_SIZE_5 = ?, SHOES_SIZE_55 = ?, SHOES_SIZE_6 = ?, SHOES_SIZE_65 = ?, SHOES_SIZE_7 = ?, SHOES_SIZE_75 = ?, ");
            query.append(" SHOES_SIZE_8 = ?, SHOES_SIZE_85 = ?, SHOES_SIZE_9 = ?, SHOES_SIZE_95 = ?, SHOES_SIZE_10 = ?, SHOES_SIZE_105 = ?, SHOES_SIZE_11 = ?, SHOES_SIZE_115 = ?, ");
            query.append(" SHOES_SIZE_12 = ?, SHOES_SIZE_125 = ?, SHOES_SIZE_13 = ?, SHOES_SIZE_14 = ?, ");
            query.append(" SHOES_NAME = ?, SHOES_PRICE = ?, SHOES_EXPLAN = ?, ");
            query.append(" FILE_NAME = ?, FILE_REALNAME = ?, FILE_PATH = ?,FILE_EXT = ?,FILE_SIZE = ? ");
            query.append(" WHERE ENTRY_ID = ? ");

        }else{

            query.append(" UPDATE ");
            query.append(" TB_ENTRY SET ENTRY_NAME = ?, SCH_SDAY = ?, SCH_EDAY = ?,UPD_DATE = GETDATE(), ");
            query.append(" UPD_ID = ?, SHOES_SIZE_1 = ?, SHOES_SIZE_2 = ?, SHOES_SIZE_3 = ?, SHOES_SIZE_35 = ?, ");
            query.append(" SHOES_SIZE_4 = ?, SHOES_SIZE_45 = ?, SHOES_SIZE_5 = ?, SHOES_SIZE_55 = ?, SHOES_SIZE_6 = ?, SHOES_SIZE_65 = ?, SHOES_SIZE_7 = ?, SHOES_SIZE_75 = ?, ");
            query.append(" SHOES_SIZE_8 = ?, SHOES_SIZE_85 = ?, SHOES_SIZE_9 = ?, SHOES_SIZE_95 = ?, SHOES_SIZE_10 = ?, SHOES_SIZE_105 = ?, SHOES_SIZE_11 = ?, SHOES_SIZE_115 = ?, ");
            query.append(" SHOES_SIZE_12 = ?, SHOES_SIZE_125 = ?, SHOES_SIZE_13 = ?, SHOES_SIZE_14 = ?, ");
            query.append(" SHOES_NAME = ?, SHOES_PRICE = ?, SHOES_EXPLAN = ? ");
            query.append(" WHERE ENTRY_ID = ? ");
        
        }
        
        int x = 0;
        try{
            conn = ConnectMgr.getConnection();
            conn.setAutoCommit(false);
            try{

                pstmtCheck = conn.prepareStatement(checkQuery.toString());
                rs = pstmtCheck.executeQuery();

                retstr = "SUCC";
                pstmt = conn.prepareStatement(query.toString());
                pstmt.setString(++x,einfo.getEntry_name());
                pstmt.setString(++x,einfo.getSch_sday());
                pstmt.setString(++x,einfo.getSch_eday());
                pstmt.setString(++x,einfo.getUpd_id());
                pstmt.setString(++x,einfo.getShoes_size_1());
                pstmt.setString(++x,einfo.getShoes_size_2());
                pstmt.setString(++x,einfo.getShoes_size_3());
                pstmt.setString(++x,einfo.getShoes_size_35());
                pstmt.setString(++x,einfo.getShoes_size_4());
                pstmt.setString(++x,einfo.getShoes_size_45());
                pstmt.setString(++x,einfo.getShoes_size_5());
                pstmt.setString(++x,einfo.getShoes_size_55());
                pstmt.setString(++x,einfo.getShoes_size_6());
                pstmt.setString(++x,einfo.getShoes_size_65());
                pstmt.setString(++x,einfo.getShoes_size_7());
                pstmt.setString(++x,einfo.getShoes_size_75());
                pstmt.setString(++x,einfo.getShoes_size_8());
                pstmt.setString(++x,einfo.getShoes_size_85());
                pstmt.setString(++x,einfo.getShoes_size_9());
                pstmt.setString(++x,einfo.getShoes_size_95());
                pstmt.setString(++x,einfo.getShoes_size_10());
                pstmt.setString(++x,einfo.getShoes_size_105());
                pstmt.setString(++x,einfo.getShoes_size_11());
                pstmt.setString(++x,einfo.getShoes_size_115());
                pstmt.setString(++x,einfo.getShoes_size_12());
                pstmt.setString(++x,einfo.getShoes_size_125());
                pstmt.setString(++x,einfo.getShoes_size_13());
                pstmt.setString(++x,einfo.getShoes_size_14());
                pstmt.setString(++x,einfo.getShoes_name());
                pstmt.setString(++x,einfo.getShoes_price());
                pstmt.setString(++x,einfo.getShoes_explan());

                if(file_mode.equals("YES")){

                    try{
                        
                        String convert_user_id = "";
                        String file_path = "";
                        String old_file = "";
                        String new_file_name = "";
                        String new_file_path = "";
                        String file_retstr = "";                        

                        if(einfo.getFile_name().equals("")){

                            int i_user_id = 0;
                        
                            if(rs.next()){
                                i_user_id = rs.getInt(1); 
                                i_user_id++;
                            }

                            convert_user_id = String.format("E%08d",i_user_id);
                            old_file = gl_path_tempfile + einfo.getFile_realname();
                            new_file_name = convert_user_id + einfo.getFile_ext();
                            new_file_path = gl_path_entry_file + new_file_name;

                            File dir = new File(gl_path_entry_file);

                            if(!dir.isDirectory()){
                                dir.mkdirs();
                            }
                            if(!new CommUtil().setMoveFile(old_file,new_file_path,true).equals("SUCC")){
                                file_retstr = "FAIL-MOVEFILE";
                            }else{
                                file_retstr = "SUCC";
                                
                                pstmt.setString(++x,new_file_name);
                                pstmt.setString(++x,einfo.getFile_realname());
                                pstmt.setString(++x,"/zcommonfiles/entry/");
                                pstmt.setString(++x,einfo.getFile_ext());
                                pstmt.setString(++x,einfo.getFile_size()+"");
                            }

                        }else{

                            old_file = gl_path_tempfile + einfo.getFile_realname();
                            new_file_path = gl_path_entry_file + einfo.getFile_name();

                            File dir = new File(gl_path_entry_file);

                            if(!dir.isDirectory()){
                                dir.mkdirs();
                            }
                            if(!new CommUtil().setMoveFile(old_file,new_file_path,true).equals("SUCC")){
                                file_retstr = "FAIL-MOVEFILE";
                            }else{
                                file_retstr = "SUCC";

                                pstmt.setString(++x,einfo.getFile_name());
                                pstmt.setString(++x,einfo.getFile_realname());
                                pstmt.setString(++x,"/zcommonfiles/entry/");
                                pstmt.setString(++x,einfo.getFile_ext());
                                pstmt.setString(++x,einfo.getFile_size()+"");
                                
                            }
                        }

                    }catch(Exception e0){
                        retstr = "FAIL";
                        conn.rollback();
                        System.err.println("["+ new CommUtil().getDebugDate("KOR","") +"][SHOES.EntryMgr] setEntryUpdate() DELETE FILE :: " + e0.getMessage());
                    }
                }

                pstmt.setString(++x,einfo.getEntry_id());
                pstmt.executeUpdate();
               
            }catch(Exception e0){
                retstr = "FAIL";
                conn.rollback();
                System.err.println("["+ new CommUtil().getDebugDate("KOR","") +"][SHOES.EntryMgr] setEntryUpdate() sql :: " + e0.getMessage());
            }
            conn.commit();
            conn.close();
            
        }catch(Exception e0){
            retstr = "FAIL";
            System.err.println("["+ new CommUtil().getDebugDate("KOR","") +"][SHOES.EntryMgr] setEntryUpdate() DBConnect :: " + e0.getMessage());
        }finally{
            if(rs != null){try{rs.close();}catch (Exception SQL2){ System.err.println(SQL2.getMessage());}}
            if(pstmt != null){try{pstmt.close();}catch (Exception SQL3){ System.err.println(SQL3.getMessage());}}
            if(conn != null){try{conn.close();}catch(Exception e){System.err.println("[shoes.DBConnectMgr] freeConnection() :: "+ e.getMessage());}}
        }
        return retstr;
    }
    
    //엔트리 삭제
    public String setEntryDelete(EntryInfo einfo,String gl_path_entry_file){

        String retstr = "FAIL";
        DBConnectMgr ConnectMgr = new DBConnectMgr();
        Connection conn = null;
        PreparedStatement pstmt = null;
        PreparedStatement pstmt_update = null;
        ResultSet rs = null;
        StringBuffer query = new StringBuffer();
        StringBuffer query_update = new StringBuffer();

        query.append(" UPDATE ");
        query.append(" TB_ENTRY SET DB_STATUS = 'D', DEL_ID = ?, DEL_DATE = GETDATE() WHERE ENTRY_ID = ? ");

        query_update.append(" UPDATE TB_KIOSK SET ENTRY_ID = '' WHERE ENTRY_ID = ?");

        int x = 0;
        try{
            conn = ConnectMgr.getConnection();
            conn.setAutoCommit(false);
            try{
                retstr = "SUCC";
                pstmt = conn.prepareStatement(query.toString());
                pstmt.setString(++x,einfo.getDel_id());
                pstmt.setString(++x,einfo.getEntry_id());
                pstmt.executeUpdate();
                x = 0;
                pstmt_update = conn.prepareStatement(query_update.toString());
                pstmt_update.setString(++x,einfo.getEntry_id());
                pstmt_update.executeUpdate();

                try{
                    new CommUtil().setDeleteFile(einfo.getFile_name(),gl_path_entry_file);
                }catch(Exception e0){
                    retstr = "FAIL";
                    conn.rollback();
                    System.err.println("["+ new CommUtil().getDebugDate("KOR","") +"][SHOES.EntryMgr] setEntryDelete() DELETE FILE :: " + e0.getMessage());
                }
            }catch(Exception e0){
                retstr = "FAIL";
                conn.rollback();
                System.err.println("["+ new CommUtil().getDebugDate("KOR","") +"][SHOES.EntryMgr] setEntryDelete() sql :: " + e0.getMessage());
            }
            conn.commit();
            conn.close();
            
        }catch(Exception e0){
            retstr = "FAIL";
            System.err.println("["+ new CommUtil().getDebugDate("KOR","") +"][SHOES.EntryMgr] setEntryUpdate() DBConnect :: " + e0.getMessage());
        }finally{
            if(rs != null){try{rs.close();}catch (Exception SQL2){ System.err.println(SQL2.getMessage());}}
            if(pstmt != null){try{pstmt.close();}catch (Exception SQL3){ System.err.println(SQL3.getMessage());}}
            if(conn != null){try{conn.close();}catch(Exception e){System.err.println("[shoes.DBConnectMgr] freeConnection() :: "+ e.getMessage());}}
        }
        return retstr;
    }
    
    //키오스크 상태 업데이트
    public String setKioskEntryStatus(String entry_id,String entry_status,String kiosk_id,String open_status){

        String retstr = "FAIL";
        DBConnectMgr ConnectMgr = new DBConnectMgr();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        StringBuffer query = new StringBuffer();   

        query.append(" UPDATE TB_KIOSK SET ENTRY_ID = ?, KIOSK_SECT = ?, UPD_DATE = GETDATE(), OPEN_STATUS = ? WHERE KIOSK_ID = ? ");

        int x = 0;
        try{
            conn = ConnectMgr.getConnection();
            conn.setAutoCommit(false);

            try{
                retstr = "SUCC";
                pstmt = conn.prepareStatement(query.toString());
                pstmt.setString(++x,entry_id);
                pstmt.setString(++x,entry_status);
                pstmt.setString(++x,open_status);
                pstmt.setString(++x,kiosk_id);
                pstmt.executeUpdate();
                
            }catch(Exception e0){
                retstr = "FAIL";
                conn.rollback();
                System.err.println("["+ new CommUtil().getDebugDate("KOR","") +"][SHOES.EntryMgr] setKioskEntryStatus() sql :: " + e0.getMessage());
            }
            conn.commit();
            conn.close();
        }catch(Exception e0){
            retstr = "FAIL";
            System.err.println("["+ new CommUtil().getDebugDate("KOR","") +"][SHOES.EntryMgr] setKioskEntryStatus() DBConnect :: " + e0.getMessage());
        }finally{
            if(rs != null){try{rs.close();}catch (Exception SQL2){ System.err.println(SQL2.getMessage());}}
            if(pstmt != null){try{pstmt.close();}catch (Exception SQL3){ System.err.println(SQL3.getMessage());}}
            if(conn != null){try{conn.close();}catch(Exception e){System.err.println("[shoes.DBConnectMgr] freeConnection() :: "+ e.getMessage());}}
        }
        return retstr;
    }

    //키오스크리스트용 엔트리 리스트 가져오기
    public ArrayList<EntryInfo> getKioskEntryList(){

        DBConnectMgr ConnectMgr = new DBConnectMgr();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        StringBuffer query = new StringBuffer();   
        ArrayList<EntryInfo> elist = new ArrayList<EntryInfo>();

        query.append(" SELECT ");
        query.append(" A.ENTRY_ID,A.ENTRY_NAME,A.SCH_SDAY,A.SCH_EDAY, ");
        query.append(" (SELECT COUNT(*) FROM TB_ENTRY_USER B WHERE A.ENTRY_ID = B.ENTRY_ID) AS TOTAL_CNT ");
        query.append(" FROM TB_ENTRY A WHERE A.DB_STATUS = 'A' ");

        int x = 0;
        try{
            conn = ConnectMgr.getConnection();
            conn.setAutoCommit(false);
            try{
                pstmt = conn.prepareStatement(query.toString());
                rs = pstmt.executeQuery();

                while(rs.next()){
                    EntryInfo einfo = new EntryInfo();
                    einfo.setEntry_id(rs.getString("ENTRY_ID"));
                    einfo.setEntry_name(rs.getString("ENTRY_NAME"));
                    einfo.setSch_sday(rs.getString("SCH_SDAY"));
                    einfo.setSch_eday(rs.getString("SCH_EDAY"));
                    einfo.setTotal_cnt(rs.getString("TOTAL_CNT"));
                    elist.add(einfo);
                }
               
            }catch(Exception e0){
                System.err.println("["+ new CommUtil().getDebugDate("KOR","") +"][SHOES.EntryMgr] getKioskEntryList() sql :: " + e0.getMessage());
            }
            conn.close();
        }catch(Exception e0){
            System.err.println("["+ new CommUtil().getDebugDate("KOR","") +"][SHOES.EntryMgr] getKioskEntryList() DBConnect :: " + e0.getMessage());
        }finally{
            if(rs != null){try{rs.close();}catch (Exception SQL2){ System.err.println(SQL2.getMessage());}}
            if(pstmt != null){try{pstmt.close();}catch (Exception SQL3){ System.err.println(SQL3.getMessage());}}
            if(conn != null){try{conn.close();}catch(Exception e){System.err.println("[shoes.DBConnectMgr] freeConnection() :: "+ e.getMessage());}}
        }
        return elist;
    }

    //키오스크 리스트 카운트
    public int getKioskListCnt(){

        DBConnectMgr ConnectMgr = new DBConnectMgr();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        StringBuffer query = new StringBuffer();   
        int total_cnt = 0;

        query.append(" SELECT ");
        query.append(" COUNT(*) ");
        query.append(" FROM TB_KIOSK ");
        query.append(" WHERE DB_STATUS = 'A' ");

        try{
            conn = ConnectMgr.getConnection();
            conn.setAutoCommit(false);
            try{
                pstmt = conn.prepareStatement(query.toString());
                rs = pstmt.executeQuery();
                if(rs.next()){
                    total_cnt = rs.getInt(1); 
                }
               
            }catch(Exception e0){
                System.err.println("["+ new CommUtil().getDebugDate("KOR","") +"][SHOES.EntryMgr] getKioskListCnt() sql :: " + e0.getMessage());
            }
            conn.close();
        }catch(Exception e0){
            System.err.println("["+ new CommUtil().getDebugDate("KOR","") +"][SHOES.EntryMgr] getKioskListCnt() DBConnect :: " + e0.getMessage());
        }finally{
            if(rs != null){try{rs.close();}catch (Exception SQL2){ System.err.println(SQL2.getMessage());}}
            if(pstmt != null){try{pstmt.close();}catch (Exception SQL3){ System.err.println(SQL3.getMessage());}}
            if(conn != null){try{conn.close();}catch(Exception e){System.err.println("[shoes.DBConnectMgr] freeConnection() :: "+ e.getMessage());}}
        }
        return total_cnt;
    }
    
    //키오스크 리스트 가져오기
    public ArrayList<KioskInfo> getKioskList(int k_page,int k_pagesize){

        DBConnectMgr ConnectMgr = new DBConnectMgr();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        StringBuffer query = new StringBuffer();   
        ArrayList<KioskInfo> klist = new ArrayList<KioskInfo>();

        query.append(" SELECT KIOSK_ID,BRN_ID,KIOSK_SECT,KIOSK_TYPE,KIOSK_FORM,KIOSK_NAME,OPEN_STATUS, ");
        query.append(" KIOSK_CODE,KIOSK_STATUS,KIOSK_PASSWD,KIOSK_DIRECT,AUTO_SYNC,FLOOR_CODE, ");
        query.append(" POS_X,POS_Y,SCH_WEEK,SCH_TYPE,SCH_TIME,IP_ADDR,MAC_ADDR,KIOSK_CPU,KIOSK_MEM, ");
        query.append(" SCREEN_SHOT,KIOSK_DESC,DB_STATUS,REG_ID,UPD_ID,DEL_ID,REG_DATE,UPD_DATE,DEL_DATE, ");
        query.append(" LAST_DATE,KIOSK_TOTAL,KIOSK_SPACE,DISK_TOTAL,DISK_SPACE,RESS_DATE,KIOSK_WAY,ENTRY_ID,ENTRY_STATUS ");
        query.append(" ENTRY_ID,ENTRY_STATUS ");
        query.append(" FROM TB_KIOSK ");
        query.append(" WHERE DB_STATUS = 'A' ");
        query.append(" ORDER BY KIOSK_SECT DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY ");

        k_page = (k_page - 1) * k_pagesize;

        int x = 0;
        try{
            conn = ConnectMgr.getConnection();
            conn.setAutoCommit(false);
            try{
                pstmt = conn.prepareStatement(query.toString());
                pstmt.setInt(++x,k_page);
                pstmt.setInt(++x,k_pagesize);
                rs = pstmt.executeQuery();

                while(rs.next()){
                    KioskInfo ainfo = new KioskInfo();
                    ainfo.setKiosk_id(rs.getString("KIOSK_ID"));
                    ainfo.setBrn_id(rs.getString("BRN_ID"));
                    ainfo.setKiosk_sect(rs.getString("KIOSK_SECT"));
                    ainfo.setKiosk_type(rs.getString("KIOSK_TYPE"));
                    ainfo.setKiosk_name(rs.getString("KIOSK_NAME"));
                    ainfo.setKiosk_code(rs.getString("KIOSK_CODE"));
                    ainfo.setOpen_status(rs.getString("OPEN_STATUS"));
                    ainfo.setKiosk_status(rs.getString("KIOSK_STATUS"));
                    ainfo.setKiosk_passwd(rs.getString("KIOSK_PASSWD"));
                    ainfo.setKiosk_direct(rs.getString("KIOSK_DIRECT"));
                    ainfo.setAuto_sync(rs.getString("AUTO_SYNC"));
                    ainfo.setFloor_code(rs.getString("FLOOR_CODE"));
                    ainfo.setPos_x(rs.getInt("POS_X"));
                    ainfo.setPos_y(rs.getInt("POS_Y"));
                    ainfo.setSch_week(rs.getString("SCH_WEEK"));
                    ainfo.setSch_type(rs.getString("SCH_TYPE"));
                    ainfo.setSch_time(rs.getString("SCH_TIME"));
                    ainfo.setIp_addr(rs.getString("IP_ADDR"));
                    ainfo.setMac_addr(rs.getString("MAC_ADDR"));
                    ainfo.setKiosk_cpu(rs.getInt("KIOSK_CPU"));
                    ainfo.setKiosk_mem(rs.getInt("KIOSK_MEM"));
                    ainfo.setScreen_shot(rs.getString("SCREEN_SHOT"));
                    ainfo.setKiosk_desc(rs.getString("KIOSK_DESC"));
                    ainfo.setDb_status(rs.getString("DB_STATUS"));
                    ainfo.setReg_id(rs.getString("REG_ID"));
                    ainfo.setUpd_id(rs.getString("UPD_ID"));
                    ainfo.setReg_date(rs.getString("REG_DATE"));
                    ainfo.setUpd_date(rs.getString("UPD_DATE"));
                    ainfo.setDel_date(rs.getString("DEL_DATE"));
                    ainfo.setLast_date(rs.getString("LAST_DATE"));
                    ainfo.setKiosk_total(rs.getString("KIOSK_TOTAL"));
                    ainfo.setKiosk_space(rs.getString("KIOSK_SPACE"));
                    ainfo.setDisk_total(rs.getString("DISK_TOTAL"));
                    ainfo.setDisk_space(rs.getString("DISK_SPACE"));
                    ainfo.setRess_date(rs.getString("RESS_DATE"));
                    ainfo.setKiosk_way(rs.getString("KIOSK_WAY"));
                    ainfo.setEntry_id(rs.getString("ENTRY_ID"));
                    ainfo.setEntry_status(rs.getString("ENTRY_STATUS"));                    
                    klist.add(ainfo);
                }
               
            }catch(Exception e0){
                System.err.println("["+ new CommUtil().getDebugDate("KOR","") +"][SHOES.EntryMgr] getKioskList() sql :: " + e0.getMessage());
            }
            conn.close();
        }catch(Exception e0){
            System.err.println("["+ new CommUtil().getDebugDate("KOR","") +"][SHOES.EntryMgr] getKioskList() DBConnect :: " + e0.getMessage());
        }finally{
            if(rs != null){try{rs.close();}catch (Exception SQL2){ System.err.println(SQL2.getMessage());}}
            if(pstmt != null){try{pstmt.close();}catch (Exception SQL3){ System.err.println(SQL3.getMessage());}}
            if(conn != null){try{conn.close();}catch(Exception e){System.err.println("[shoes.DBConnectMgr] freeConnection() :: "+ e.getMessage());}}
        }
        return klist;
    }
    
    //전체 통계
    public ArrayList<EntryInfo> getEntryAllStatis(){

        DBConnectMgr ConnectMgr = new DBConnectMgr();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        StringBuffer query = new StringBuffer();   
        ArrayList<EntryInfo> elist = new ArrayList<EntryInfo>();

        query.append(" SELECT ");
        query.append(" ENTRY_ID,ENTRY_NAME, ");
        query.append(" (SELECT COUNT(*) FROM TB_ENTRY_USER B WHERE A.ENTRY_ID = B.ENTRY_ID) AS TOTAL_CNT ");
        query.append(" FROM ");
        query.append(" TB_ENTRY A");
        query.append(" WHERE A.DB_STATUS = 'A' ");

        int x = 0;
        try{
            conn = ConnectMgr.getConnection();
            conn.setAutoCommit(false);
            try{
                pstmt = conn.prepareStatement(query.toString());
                rs = pstmt.executeQuery();

                while(rs.next()){
                    EntryInfo einfo = new EntryInfo();
                    einfo.setEntry_id(rs.getString("ENTRY_ID"));
                    einfo.setEntry_name(rs.getString("ENTRY_NAME"));
                    einfo.setTotal_cnt(rs.getString("TOTAL_CNT"));
                    elist.add(einfo);
                }
               
            }catch(Exception e0){
                System.err.println("["+ new CommUtil().getDebugDate("KOR","") +"][SHOES.EntryMgr] getEntryAllStatis() sql :: " + e0.getMessage());
            }
            conn.close();
        }catch(Exception e0){
            System.err.println("["+ new CommUtil().getDebugDate("KOR","") +"][SHOES.EntryMgr] getEntryAllStatis() DBConnect :: " + e0.getMessage());
        }finally{
            if(rs != null){try{rs.close();}catch (Exception SQL2){ System.err.println(SQL2.getMessage());}}
            if(pstmt != null){try{pstmt.close();}catch (Exception SQL3){ System.err.println(SQL3.getMessage());}}
            if(conn != null){try{conn.close();}catch(Exception e){System.err.println("[shoes.DBConnectMgr] freeConnection() :: "+ e.getMessage());}}
        }
        return elist;
    }
    
    //오늘 날짜 통계
    public ArrayList<EntryInfo> getEntryTodayStatis(){

        DBConnectMgr ConnectMgr = new DBConnectMgr();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        StringBuffer query = new StringBuffer();   
        ArrayList<EntryInfo> elist = new ArrayList<EntryInfo>();

        query.append(" SELECT ");
        query.append(" ENTRY_ID,ENTRY_NAME, ");
        query.append(" (SELECT COUNT(*) FROM TB_ENTRY_USER B WHERE A.ENTRY_ID = B.ENTRY_ID AND DATEDIFF(HH,REG_DATE,GETDATE()) < 24 ) AS TOTAL_CNT ");
        query.append(" FROM ");
        query.append(" TB_ENTRY A");
        query.append(" WHERE A.DB_STATUS = 'A' ");

        int x = 0;
        try{
            conn = ConnectMgr.getConnection();
            conn.setAutoCommit(false);
            try{
                pstmt = conn.prepareStatement(query.toString());
                rs = pstmt.executeQuery();

                while(rs.next()){
                    EntryInfo einfo = new EntryInfo();
                    einfo.setEntry_id(rs.getString("ENTRY_ID"));
                    einfo.setEntry_name(rs.getString("ENTRY_NAME"));
                    einfo.setTotal_cnt(rs.getString("TOTAL_CNT"));
                    elist.add(einfo);
                }
               
            }catch(Exception e0){
                System.err.println("["+ new CommUtil().getDebugDate("KOR","") +"][SHOES.EntryMgr] getEntryTodayStatis() sql :: " + e0.getMessage());
            }
            conn.close();
        }catch(Exception e0){
            System.err.println("["+ new CommUtil().getDebugDate("KOR","") +"][SHOES.EntryMgr] getEntryTodayStatis() DBConnect :: " + e0.getMessage());
        }finally{
            if(rs != null){try{rs.close();}catch (Exception SQL2){ System.err.println(SQL2.getMessage());}}
            if(pstmt != null){try{pstmt.close();}catch (Exception SQL3){ System.err.println(SQL3.getMessage());}}
            if(conn != null){try{conn.close();}catch(Exception e){System.err.println("[shoes.DBConnectMgr] freeConnection() :: "+ e.getMessage());}}
        }
        return elist;
    }
    
    //월별 통계
    public ArrayList<EntryInfo> getEntryOfDayStatis(){

        DBConnectMgr ConnectMgr = new DBConnectMgr();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        StringBuffer query = new StringBuffer();   
        ArrayList<EntryInfo> elist = new ArrayList<EntryInfo>();

        query.append(" DECLARE @S_DATE DATETIME,@E_DATE DATETIME ");
        query.append(" SET @S_DATE = CONVERT (VARCHAR(10),DATEADD(S,-1,DATEADD(MM,DATEDIFF(M,0,GETDATE()),1)),112) ");
        query.append(" SET @E_DATE = CONVERT (VARCHAR(10),DATEADD(S,-1,DATEADD(MM,DATEDIFF(M,0,GETDATE())+1,0)),112) ");
        query.append(" SELECT CONVERT(varchar(20), A.REG_DATE, 23) AS REG_DATE, ");
        query.append(" COUNT(*) AS TOTAL_CNT ");
        query.append(" FROM TB_ENTRY_USER A LEFT JOIN TB_ENTRY B ON A.ENTRY_ID = B.ENTRY_ID ");
        query.append(" WHERE B.DB_STATUS = 'A' AND A.REG_DATE >= @S_DATE AND A.REG_DATE <= @E_DATE ");
        query.append(" GROUP BY CONVERT(varchar(20), A.REG_DATE, 23) ");
        query.append(" ORDER BY CONVERT(varchar(20), A.REG_DATE, 23) ");

        int x = 0;
        try{
            conn = ConnectMgr.getConnection();
            conn.setAutoCommit(false);
            try{
                pstmt = conn.prepareStatement(query.toString());
                rs = pstmt.executeQuery();

                while(rs.next()){
                    EntryInfo einfo = new EntryInfo();
                    einfo.setReg_date(rs.getString("REG_DATE"));
                    einfo.setTotal_cnt(rs.getString("TOTAL_CNT"));
                    elist.add(einfo);
                }
               
            }catch(Exception e0){
                System.err.println("["+ new CommUtil().getDebugDate("KOR","") +"][SHOES.EntryMgr] getEntryOfDayStatis() sql :: " + e0.getMessage());
            }
            conn.close();
        }catch(Exception e0){
            System.err.println("["+ new CommUtil().getDebugDate("KOR","") +"][SHOES.EntryMgr] getEntryOfDayStatis() DBConnect :: " + e0.getMessage());
        }finally{
            if(rs != null){try{rs.close();}catch (Exception SQL2){ System.err.println(SQL2.getMessage());}}
            if(pstmt != null){try{pstmt.close();}catch (Exception SQL3){ System.err.println(SQL3.getMessage());}}
            if(conn != null){try{conn.close();}catch(Exception e){System.err.println("[shoes.DBConnectMgr] freeConnection() :: "+ e.getMessage());}}
        }
        return elist;
    }

    //응모별 성별 통계
    public EntryInfo getEntryGenderStatis(String entry_id){
        DBConnectMgr ConnectMgr = new DBConnectMgr();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        StringBuffer query = new StringBuffer();   
        EntryInfo einfo = new EntryInfo();

        query.append(" SELECT DISTINCT ");
        query.append(" (SELECT COUNT(*) FROM TB_ENTRY_USER WHERE USER_GENDER = 'M' AND ENTRY_ID = ? ) M_CNT, ");
        query.append(" (SELECT COUNT(*) FROM TB_ENTRY_USER WHERE USER_GENDER = 'F' AND ENTRY_ID = ? ) F_CNT ");
        query.append(" FROM TB_ENTRY_USER ");

        int x = 0;
        try{
            conn = ConnectMgr.getConnection();
            conn.setAutoCommit(false);
            try{
                pstmt = conn.prepareStatement(query.toString());
                pstmt.setString(++x,entry_id);
                pstmt.setString(++x,entry_id);
                rs = pstmt.executeQuery();

                while(rs.next()){
                    einfo.setM_cnt(rs.getString("M_CNT"));
                    einfo.setF_cnt(rs.getString("F_CNT"));
                }
               
            }catch(Exception e0){
                System.err.println("["+ new CommUtil().getDebugDate("KOR","") +"][SHOES.EntryMgr] getEntryGenderStatis() sql :: " + e0.getMessage());
            }
            conn.close();
        }catch(Exception e0){
            System.err.println("["+ new CommUtil().getDebugDate("KOR","") +"][SHOES.EntryMgr] getEntryGenderStatis() DBConnect :: " + e0.getMessage());
        }finally{
            if(rs != null){try{rs.close();}catch (Exception SQL2){ System.err.println(SQL2.getMessage());}}
            if(pstmt != null){try{pstmt.close();}catch (Exception SQL3){ System.err.println(SQL3.getMessage());}}
            if(conn != null){try{conn.close();}catch(Exception e){System.err.println("[shoes.DBConnectMgr] freeConnection() :: "+ e.getMessage());}}
        }
        return einfo;
    }

    //응모별 나이대 통계
    public EntryInfo getEntryAgeStatis(String entry_id){
        DBConnectMgr ConnectMgr = new DBConnectMgr();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        StringBuffer query = new StringBuffer();   
        EntryInfo einfo = new EntryInfo();

        query.append(" SELECT DISTINCT ");
        query.append(" (SELECT COUNT(*) FROM TB_ENTRY_USER WHERE DATEDIFF(YEAR,USER_BIRTHDAY,GETDATE()) < 20 AND DATEDIFF(YEAR,USER_BIRTHDAY,GETDATE()) >= 10 AND ENTRY_ID = ?) 'TEN_CNT', ");
        query.append(" (SELECT COUNT(*) FROM TB_ENTRY_USER WHERE DATEDIFF(YEAR,USER_BIRTHDAY,GETDATE()) < 30 AND DATEDIFF(YEAR,USER_BIRTHDAY,GETDATE()) >= 20 AND ENTRY_ID = ?) 'TWENTY_CNT', ");
        query.append(" (SELECT COUNT(*) FROM TB_ENTRY_USER WHERE DATEDIFF(YEAR,USER_BIRTHDAY,GETDATE()) < 40 AND DATEDIFF(YEAR,USER_BIRTHDAY,GETDATE()) >= 30 AND ENTRY_ID = ?) 'THIRTY_CNT', ");
        query.append(" (SELECT COUNT(*) FROM TB_ENTRY_USER WHERE DATEDIFF(YEAR,USER_BIRTHDAY,GETDATE()) < 50 AND DATEDIFF(YEAR,USER_BIRTHDAY,GETDATE()) >= 40 AND ENTRY_ID = ?) 'FORTY_CNT', ");
        query.append(" (SELECT COUNT(*) FROM TB_ENTRY_USER WHERE DATEDIFF(YEAR,USER_BIRTHDAY,GETDATE()) < 60 AND DATEDIFF(YEAR,USER_BIRTHDAY,GETDATE()) >= 50 AND ENTRY_ID = ?) 'FIFTY_CNT' ");
        query.append(" FROM TB_ENTRY_USER ");
        query.append(" WHERE ENTRY_ID = ? ");

        int x = 0;
        try{
            conn = ConnectMgr.getConnection();
            conn.setAutoCommit(false);
            try{
                pstmt = conn.prepareStatement(query.toString());
                pstmt.setString(++x,entry_id);
                pstmt.setString(++x,entry_id);
                pstmt.setString(++x,entry_id);
                pstmt.setString(++x,entry_id);
                pstmt.setString(++x,entry_id);
                pstmt.setString(++x,entry_id);
                rs = pstmt.executeQuery();

                while(rs.next()){
                    einfo.setTen_cnt(rs.getString("TEN_CNT"));
                    einfo.setTwenty_cnt(rs.getString("TWENTY_CNT"));
                    einfo.setThirty_cnt(rs.getString("THIRTY_CNT"));
                    einfo.setForty_cnt(rs.getString("FORTY_CNT"));
                    einfo.setFifty_cnt(rs.getString("FIFTY_CNT"));
                }
               
            }catch(Exception e0){
                System.err.println("["+ new CommUtil().getDebugDate("KOR","") +"][SHOES.EntryMgr] getEntryAgeStatis() sql :: " + e0.getMessage());
            }
            conn.close();
        }catch(Exception e0){
            System.err.println("["+ new CommUtil().getDebugDate("KOR","") +"][SHOES.EntryMgr] getEntryAgeStatis() DBConnect :: " + e0.getMessage());
        }finally{
            if(rs != null){try{rs.close();}catch (Exception SQL2){ System.err.println(SQL2.getMessage());}}
            if(pstmt != null){try{pstmt.close();}catch (Exception SQL3){ System.err.println(SQL3.getMessage());}}
            if(conn != null){try{conn.close();}catch(Exception e){System.err.println("[shoes.DBConnectMgr] freeConnection() :: "+ e.getMessage());}}
        }
        return einfo;
    }

    //응모자 등록
    public String setEntryUser(EntryInfo einfo){

        DBConnectMgr ConnectMgr = new DBConnectMgr();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        StringBuffer query = new StringBuffer();   
        String retstr = "";

        query.append(" INSERT INTO TB_ENTRY_USER ");
        query.append(" (ENTRY_ID,USER_FIRSTNAME,USER_LASTNAME,SHOES_SIZE,USER_PHONE,USER_MAIL,USER_GENDER,USER_BIRTHDAY,REG_DATE) ");
        query.append(" VALUES( ");
        query.append(" ?,?,?,?,?,?,?,CONVERT(datetime,?,104),GETDATE()) ");

        int x = 0;
        try{
            conn = ConnectMgr.getConnection();
            conn.setAutoCommit(false);
            try{
                pstmt = conn.prepareStatement(query.toString());
                pstmt.setString(++x,einfo.getEntry_id());
                pstmt.setString(++x,einfo.getUser_firstname());
                pstmt.setString(++x,einfo.getUser_lastname());
                pstmt.setString(++x,einfo.getShoes_size());
                pstmt.setString(++x,einfo.getUser_phone());
                pstmt.setString(++x,einfo.getUser_mail());
                pstmt.setString(++x,einfo.getUser_gender());
                pstmt.setString(++x,einfo.getUser_birthday());
                pstmt.executeUpdate();
                retstr = "SUCC";
               
            }catch(Exception e0){
                conn.rollback();
                retstr = "FAIL";
                System.err.println("["+ new CommUtil().getDebugDate("KOR","") +"][SHOES.EntryMgr] setEntryUser() sql :: " + e0.getMessage());
            }
            conn.commit();
            conn.close();
        }catch(Exception e0){
            System.err.println("["+ new CommUtil().getDebugDate("KOR","") +"][SHOES.EntryMgr] setEntryUser() DBConnect :: " + e0.getMessage());
        }finally{
            if(rs != null){try{rs.close();}catch (Exception SQL2){ System.err.println(SQL2.getMessage());}}
            if(pstmt != null){try{pstmt.close();}catch (Exception SQL3){ System.err.println(SQL3.getMessage());}}
            if(conn != null){try{conn.close();}catch(Exception e){System.err.println("[shoes.DBConnectMgr] freeConnection() :: "+ e.getMessage());}}
        }
        return retstr;
    }

    //추첨 응모자 리스트 가져오기
    public ArrayList<EntryInfo> getEntryUserList(String entry_id){

        DBConnectMgr ConnectMgr = new DBConnectMgr();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        StringBuffer query = new StringBuffer();
        ArrayList<EntryInfo> elist = new ArrayList<EntryInfo>();

        query.append(" SELECT ");
        query.append(" USER_ID,USER_FIRSTNAME,USER_LASTNAME,SHOES_SIZE,USER_PHONE,USER_MAIL,USER_GENDER,USER_BIRTHDAY ");
        query.append(" FROM TB_ENTRY_USER ");
        query.append(" WHERE ENTRY_ID = ? ");
        query.append(" ORDER BY SHOES_SIZE ASC ");

        int x = 0;
        try{
            conn = ConnectMgr.getConnection();
            conn.setAutoCommit(false);
            try{

                pstmt = conn.prepareStatement(query.toString());
                pstmt.setString(++x,entry_id);
                rs = pstmt.executeQuery();

                while(rs.next()){
                    EntryInfo einfo = new EntryInfo();
                    einfo.setUser_id(rs.getString("USER_ID"));
                    einfo.setUser_firstname(rs.getString("USER_FIRSTNAME"));
                    einfo.setUser_lastname(rs.getString("USER_LASTNAME"));
                    einfo.setShoes_size(rs.getString("SHOES_SIZE"));
                    einfo.setUser_phone(rs.getString("USER_PHONE"));
                    einfo.setUser_mail(rs.getString("USER_MAIL"));
                    einfo.setUser_gender(rs.getString("USER_GENDER"));
                    einfo.setUser_birthday(rs.getString("USER_BIRTHDAY"));
                    elist.add(einfo);
                }
               
            }catch(Exception e0){
                System.err.println("["+ new CommUtil().getDebugDate("KOR","") +"][SHOES.EntryMgr] getEntryUserList() sql :: " + e0.getMessage());
            }
            conn.close();
        }catch(Exception e0){
            System.err.println("["+ new CommUtil().getDebugDate("KOR","") +"][SHOES.EntryMgr] getEntryUserList() DBConnect :: " + e0.getMessage());
        }finally{
            if(rs != null){try{rs.close();}catch (Exception SQL2){ System.err.println(SQL2.getMessage());}}
            if(pstmt != null){try{pstmt.close();}catch (Exception SQL3){ System.err.println(SQL3.getMessage());}}
            if(conn != null){try{conn.close();}catch(Exception e){System.err.println("[shoes.DBConnectMgr] freeConnection() :: "+ e.getMessage());}}
        }
        return elist;
    }

    //응모자 추첨 저장
    public String setEntryWinner(String entry_id,String size,String user_id){

        DBConnectMgr ConnectMgr = new DBConnectMgr();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        StringBuffer query = new StringBuffer();   
        String retstr = "";
        String [] arr_userid = user_id.split(",");  
        StringBuffer query_winner = new StringBuffer();

        query.append(" INSERT INTO TB_ENTRY_WINNER ");
        query.append(" (USER_ID,ENTRY_ID,SHOES_SIZE,DB_STATUS,REG_DATE) ");
        query.append(" VALUES( ");
        query.append(" ?,?,?,'A',CONVERT(VARCHAR(10),GETDATE(),104) ) ");

        query_winner.append(" UPDATE TB_ENTRY SET WINNER_CHOICE = 'C' WHERE ENTRY_ID = ? ");
        

        int x = 0;
        try{
            conn = ConnectMgr.getConnection();
            conn.setAutoCommit(false);
            try{
                pstmt = conn.prepareStatement(query.toString());

                for(int i = 0; i < arr_userid.length; i++){
                    x = 0;

                    if(arr_userid[i].equals("0")){
                        retstr = "SUCC";
                        return retstr;
                    }
        
                    pstmt.setString(++x,arr_userid[i]);
                    pstmt.setString(++x,entry_id);
                    pstmt.setString(++x,size);
                    pstmt.executeUpdate();
                }
                
                x = 0;

                pstmt = conn.prepareStatement(query_winner.toString());
                pstmt.setString(++x,entry_id);
                pstmt.executeUpdate();

                retstr = "SUCC";
               
            }catch(Exception e0){
                retstr = "FAIL";
                conn.rollback();
                System.err.println("["+ new CommUtil().getDebugDate("KOR","") +"][SHOES.EntryMgr] setEntryWinner() sql :: " + e0.getMessage());
            }
            conn.commit();
            conn.close();
        }catch(Exception e0){
            System.err.println("["+ new CommUtil().getDebugDate("KOR","") +"][SHOES.EntryMgr] setEntryWinner() DBConnect :: " + e0.getMessage());
        }finally{
            if(rs != null){try{rs.close();}catch (Exception SQL2){ System.err.println(SQL2.getMessage());}}
            if(pstmt != null){try{pstmt.close();}catch (Exception SQL3){ System.err.println(SQL3.getMessage());}}
            if(conn != null){try{conn.close();}catch(Exception e){System.err.println("[shoes.DBConnectMgr] freeConnection() :: "+ e.getMessage());}}
        }
        return retstr;
    }

    //추첨 당첨자 리스트 가져오기
    public ArrayList<EntryInfo> getEntryWinnerList(String entry_id){

        DBConnectMgr ConnectMgr = new DBConnectMgr();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        StringBuffer query = new StringBuffer();
        ArrayList<EntryInfo> elist = new ArrayList<EntryInfo>();

        query.append(" SELECT ");
        query.append(" WINNER_ID,USER_ID,ENTRY_ID,SHOES_SIZE,DB_STATUS,REG_DATE, ");
        query.append(" (SELECT USER_FIRSTNAME FROM TB_ENTRY_USER WHERE USER_ID = B.USER_ID) USER_FIRSTNAME, ");
        query.append(" (SELECT USER_LASTNAME FROM TB_ENTRY_USER WHERE USER_ID = B.USER_ID) USER_LASTNAME, ");
        query.append(" (SELECT USER_PHONE FROM TB_ENTRY_USER WHERE USER_ID = B.USER_ID) USER_PHONE, ");
        query.append(" (SELECT USER_MAIL FROM TB_ENTRY_USER WHERE USER_ID = B.USER_ID) USER_MAIL, ");
        query.append(" (SELECT USER_GENDER FROM TB_ENTRY_USER WHERE USER_ID = B.USER_ID) USER_GENDER ");
        query.append(" FROM TB_ENTRY_WINNER B ");
        query.append(" WHERE ENTRY_ID = ? ");
        query.append(" ORDER BY CAST(SHOES_SIZE AS INT) ASC ");

        int x = 0;
        try{
            conn = ConnectMgr.getConnection();
            conn.setAutoCommit(false);
            try{

                pstmt = conn.prepareStatement(query.toString());
                pstmt.setString(++x,entry_id);
                rs = pstmt.executeQuery();

                while(rs.next()){
                    EntryInfo einfo = new EntryInfo();
                    einfo.setWinner_id(rs.getString("WINNER_ID"));
                    einfo.setUser_id(rs.getString("USER_ID"));
                    einfo.setEntry_id(rs.getString("ENTRY_ID"));
                    einfo.setShoes_size(rs.getString("SHOES_SIZE"));
                    einfo.setDb_status(rs.getString("DB_STATUS"));
                    einfo.setReg_date(rs.getString("REG_DATE"));
                    einfo.setUser_firstname(rs.getString("USER_FIRSTNAME"));
                    einfo.setUser_lastname(rs.getString("USER_LASTNAME"));
                    einfo.setUser_phone(rs.getString("USER_PHONE"));
                    einfo.setUser_mail(rs.getString("USER_MAIL"));
                    einfo.setUser_gender(rs.getString("USER_GENDER"));
                    elist.add(einfo);
                }
               
            }catch(Exception e0){
                System.err.println("["+ new CommUtil().getDebugDate("KOR","") +"][SHOES.EntryMgr] getEntryWinnerList() sql :: " + e0.getMessage());
            }
            conn.close();
        }catch(Exception e0){
            System.err.println("["+ new CommUtil().getDebugDate("KOR","") +"][SHOES.EntryMgr] getEntryWinnerList() DBConnect :: " + e0.getMessage());
        }finally{
            if(rs != null){try{rs.close();}catch (Exception SQL2){ System.err.println(SQL2.getMessage());}}
            if(pstmt != null){try{pstmt.close();}catch (Exception SQL3){ System.err.println(SQL3.getMessage());}}
            if(conn != null){try{conn.close();}catch(Exception e){System.err.println("[shoes.DBConnectMgr] freeConnection() :: "+ e.getMessage());}}
        }
        return elist;
    }

    //키오스크 엔트리 상태 가져오기
    public String getKioskEntryInfo(String kiosk_id){

        DBConnectMgr ConnectMgr = new DBConnectMgr();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        StringBuffer query = new StringBuffer();   
        String retstr = "";

        query.append(" SELECT ");
        query.append(" ENTRY_STATUS ");
        query.append(" FROM TB_KIOSK ");
        query.append(" WHERE KIOSK_ID = ? ");

        int x = 0;
        try{
            conn = ConnectMgr.getConnection();
            conn.setAutoCommit(false);
            try{
                pstmt = conn.prepareStatement(query.toString());
                pstmt.setString(++x,kiosk_id);
                rs = pstmt.executeQuery();

                if(rs.next()){                    
                    retstr = rs.getString("ENTRY_STATUS");
                }
               
            }catch(Exception e0){
                retstr = "FAIL";
                System.err.println("["+ new CommUtil().getDebugDate("KOR","") +"][SHOES.EntryMgr] getKioskEntryInfo() sql :: " + e0.getMessage());
            }
            conn.close();
        }catch(Exception e0){
            retstr = "FAIL";
            System.err.println("["+ new CommUtil().getDebugDate("KOR","") +"][SHOES.EntryMgr] getKioskEntryInfo() DBConnect :: " + e0.getMessage());
        }finally{
            if(rs != null){try{rs.close();}catch (Exception SQL2){ System.err.println(SQL2.getMessage());}}
            if(pstmt != null){try{pstmt.close();}catch (Exception SQL3){ System.err.println(SQL3.getMessage());}}
            if(conn != null){try{conn.close();}catch(Exception e){System.err.println("[shoes.DBConnectMgr] freeConnection() :: "+ e.getMessage());}}
        }
        return retstr;
    }

    
    
}