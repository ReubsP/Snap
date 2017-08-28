void loadData() {
  // Load CSV file into a Table object
  // "header" option indicates the file has a header row
  table = loadTable(tableFile, "header");

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
    if(l.equals("1") && r.equals("1") && g.equals("1")) successes++;
  }
  
}

void saveData() {
  Cycle c = cycles[cycles.length-1];
  if(c.left && c.right && c.ground) successes++;
  TableRow newRow = table.addRow();
  newRow.setString("Time", c.timeString);
  newRow.setString("Left", boolToStr(c.left));
  newRow.setString("Right", boolToStr(c.right));
  newRow.setString("Ground", boolToStr(c.ground));
  newRow.setString("Push", nf(c.push,3,1));
  newRow.setString("Pull", nf(c.pull,3,1));
  
  saveTable(table, tableFile);
}