class Cycle {
  long unixTime;
  String timeString;
  boolean left, right, ground;
  int push, pull;
  
  //t,l,r,g,push,pull
  Cycle(String t_, String l_, String r_, String g_, int push_, int pull_){
    timeString = t_; 
    unixTime = stringToUnix(timeString);
    left = strToBool(l_);
    right = strToBool(r_);
    ground = strToBool(g_);
    push = push_;
    pull = pull_;
    println(timeString,unixTime,left,right,ground,push,pull);
  }
}

boolean strToBool(String in){
  boolean result = true;
  if(in.equals("0")) result = false;
  return result;
}



String unixToString(long unixSeconds){
  //---Date date = new Date() --- will give the current unix time
  Date date= new Date(unixSeconds*1000); // *1000 for milliseconds
  String dateString = sdf.format(date);
  return dateString;
}


long stringToUnix(String timeStr){
  long result = 0;
  try{
    Date d = sdf.parse(timeStr);
    result = d.getTime();
  }
  catch (ParseException ex){
    ex.printStackTrace();
  }
  return result;
}

/*  Date functions:
 *  Date date1 = new Date(unixSeconds*1000);  //creates date object from given timestamp
 *  Date date2 = new Date();                  //creates date object from current time
 *  long date3 = date2.getTime();             //converts into unix timestamp
 *  
 *  SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yy"); //date formatter object
 *  sdf.setTimeZone(TimeZone.getTimeZone("GMT+12"));         //set timezone
 * 
 *  String dateString = sdf.format(date1);     //formats date
 *  
*/