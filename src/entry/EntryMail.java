package com.shoes.admin.entry;
import com.shoes.comm.CommUtil;
import java.util.*;
import javax.mail.*;
import java.util.Properties;
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.Multipart;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;

public class EntryMail{
    
    //응모자 메일 보내는 부분
    public String setEntryUserSendMail(ArrayList<String> winner_list){

        String host = "192.000.000.000";
        String retstr = "";

        ArrayList<String> test_list = new ArrayList<String>();

        final String username = "test";
        final String password = "test";
        int port = 25;

        String recipient = "zzdlghtjs@naver.com";
        String subject = "메일테스트";
        String body = "Dear Sneaker Fan, We have received your entry for the April2018 Ballot. Please stay tuned to find out ifyou are one of the lucky winners.";

        for(int i = 0; i < 25; i++){
            test_list.add("zzdlghtjs@naver.com");
        }

        int recpients_size = test_list.size();

        try{
            Properties props = System.getProperties();
            props.put("mail.smtp.host", host);
            props.put("mail.smtp.port", port);
//            props.put("mail.smtp.auth", "false");
//            props.put("mail.smtp.ssl.enable", "true");
//            props.put("mail.smtp.ssl.trust", host);

            Session session = Session.getDefaultInstance(props, new javax.mail.Authenticator() { 
                String un=username; 
                String pw=password; 
                protected javax.mail.PasswordAuthentication getPasswordAuthentication() { 
                    return new javax.mail.PasswordAuthentication(un, pw); 
                } 
            });

            session.setDebug(true); //for debug

            Message mimeMessage = new MimeMessage(session);

            mimeMessage.setFrom(new InternetAddress("test@test.com"));

            InternetAddress[] toAddr = new InternetAddress[recpients_size]; 
            int test_i = 0;

//            for(String mail : winner_list){
//                toAddr[test_i] = new InternetAddress(mail);
//                test_i++;
//            }

            for(String test : test_list){
                toAddr[test_i] = new InternetAddress(test);
                test_i++;
            }

//            mimeMessage.setRecipient(Message.RecipientType.TO, new InternetAddress(recipient)); //수신자 한명 셋팅

            mimeMessage.setRecipients(Message.RecipientType.TO, toAddr ); //수신자 여러명 셋팅

            mimeMessage.setSubject(subject);
            mimeMessage.setText(body); 
            Transport.send(mimeMessage);
            retstr = "SUCC";
            
        }catch(Exception e0){
            retstr = "FAIL";
            System.err.println("["+ new CommUtil().getDebugDate("KOR","") +"][SHOES.EntryMail] setEntryUserSendMail() :: " + e0.getMessage());
        }

        return retstr;
    }

}
