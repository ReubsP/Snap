class Cycle {
  long unixTime;
  String timeString;
  boolean left, right, ground;
  float push, pull;
  
  //t,l,r,g,push,pull
  Cycle(String t_, String l_, String r_, String g_, float push_, float pull_){
    timeString = t_; 
    unixTime = stringToUnix(timeString);
    left = strToBool(l_);
    right = strToBool(r_);
    ground = strToBool(g_);
    push = push_;
    pull = pull_;
  }
  Cycle(String t_, boolean l_, boolean r_, boolean g_, float push_, float pull_){
    timeString = t_; 
    unixTime = stringToUnix(timeString);
    left = l_;
    right = r_;
    ground = g_;
    push = push_;
    pull = pull_;
  }
  Cycle(String t_){
    timeString = t_; 
    unixTime = stringToUnix(timeString);
    left = true;
    right = true;
    ground = true;
    push = random(100,400);
    pull = random(100,400);
  }
}

void newCycle(){
  //cycles[cycleNum+1] = new Cycle(currentDate(),false,false,false,0,0); 
  Cycle c = new Cycle(currentDate(),false,false,false,0,0);
  cycles = (Cycle[]) append(cycles, c);
  cycleNum++;
  //append(cycles, new Cycle(currentDate(),false,false,false,0,0)); 
}
void newCycleRandom(){
  //cycles[cycleNum] = new Cycle(currentDate()); 
  Cycle c = new Cycle(currentDate());
  cycles = (Cycle[]) append(cycles, c);
}

boolean strToBool(String in){
  boolean result = true;
  if(in.equals("0")) result = false;
  return result;
}

String boolToStr(boolean in){
  String result = "1";
  if(!in) result = "0";
  return result;
}

String unixToString(long unixSeconds){
  //---Date date = new Date() --- will give the current unix time
  Date date= new Date(unixSeconds*1000); // *1000 for milliseconds
  String dateString = sdf.format(date);
  return dateString;
}

String currentDate(){
  Date date = new Date();
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