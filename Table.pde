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

void saveData() {
  Cycle lastCycle = cycles[cycles.length-1];
  TableRow newRow = table.addRow();
  newRow.setString("Time", lastCycle.timeString);
  newRow.setString("Left", boolToStr(lastCycle.left));
  newRow.setString("Right", boolToStr(lastCycle.right));
  newRow.setString("Ground", boolToStr(lastCycle.ground));
  newRow.setString("Push", nf(lastCycle.push,3,1));
  newRow.setString("Pull", nf(lastCycle.pull,3,1));
  
  saveTable(table, "table.csv");
}