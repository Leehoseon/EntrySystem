//¿£Æ®¸® ´çÃ·ÀÚ »Ì±â
     public String setEntryWinner(ArrayList<EntryInfo> size_list,int shoes_amount){
         
         String retstr = "";
         String winner_size = "";
         
         if (size_list.size() == 0){
            return retstr;
         }

         try{
            
            Collections.shuffle(size_list);
            for(int m = 0; m < shoes_amount; m++){
                EntryInfo einfo = new EntryInfo();

                if(m > size_list.size()-1){
                    return winner_size;
                }else{
                    einfo = size_list.get(m);
                    if(winner_size.equals("")) winner_size = einfo.getUser_id();
                    else winner_size = winner_size + "," + einfo.getUser_id();   
                }

                /*
                if(m < shoes_amount - 1){
                    winner_size += einfo.getUser_id() + ",";
                }else{
                    winner_size += einfo.getUser_id() ;
                }
                size_list.remove(m);

                if(shoes_amount >= size_list.size()){
                    winner_size +="0";
                    return winner_size;
                }

                */
            }
            
            retstr = "SUCC"; 
         }catch(Exception e){
             System.out.println("[SHOES.ENTRY CommUtill.java] Error = " + e.getMessage());
             retstr = "FAIL";
             return retstr;
         }

         return winner_size;
     }