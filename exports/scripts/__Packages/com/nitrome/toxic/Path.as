class com.nitrome.toxic.Path
{
   var rows;
   var cols;
   var names;
   function Path(start_row, start_col)
   {
      this.rows = new Array();
      this.cols = new Array();
      this.names = new Array();
      this.rows[0] = start_row;
      this.cols[0] = start_col;
      this.names[0] = "";
   }
   function getStartRow()
   {
      return this.rows[0];
   }
   function getStartCol()
   {
      return this.cols[0];
   }
   function getRows()
   {
      return this.rows;
   }
   function getCols()
   {
      return this.cols;
   }
   function getPathLength()
   {
      return this.rows.length;
   }
   function getRow(i)
   {
      return this.rows[i];
   }
   function getCol(i)
   {
      return this.cols[i];
   }
   function addPoint(row, col)
   {
      this.rows.push(row);
      this.cols.push(col);
   }
   function addHoloTile(n, row, col)
   {
      var _loc2_ = 1;
      while(_loc2_ < this.rows.length)
      {
         if(this.rows[_loc2_] == row && this.cols[_loc2_] == col)
         {
            break;
         }
         _loc2_ = _loc2_ + 1;
      }
      this.names[_loc2_] = n;
   }
   function getNames()
   {
      return this.names;
   }
}
