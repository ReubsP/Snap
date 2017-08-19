void loadData() {
  // Load CSV file into a Table object
  // "header" option indicates the file has a header row
  table = loadTable("table.csv", "header");

  // The size of the array of Bubble objects is determined by the total number of rows in the CSV
  cycles = new Cycle[table.getRowCount()]; 

  // You can access iterate over all the rows in a table
  int rowCount = 0;
  for (TableRow row : table.rows()) {
    // You can access the fields via their column name (or index)
    String t = row.getString("Time");
    String l = row.getString("Left");
    String r = row.getString("Right");
    String g = row.getString("Ground");
    int push = row.getInt("Push");
    int pull = row.getInt("Pull");
    // Make a event object
    cycles[rowCount] = new Cycle(t,l,r,g,push,pull);
    rowCount++;
  }
  
}

//void saveData() {
//  for(int i=0; i < events.length; i++){
//    String t = events[i].timeString;
//    TableRow thisRow = table.getRow(i);
//    thisRow.setString("time",t);
//  }
//  saveTable(table, "runsheet.csv");
//}