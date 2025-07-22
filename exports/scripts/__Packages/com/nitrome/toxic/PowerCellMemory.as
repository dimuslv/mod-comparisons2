class com.nitrome.toxic.PowerCellMemory
{
   var powercells;
   function PowerCellMemory()
   {
      var _loc2_ = SharedObject.getLocal("toxic_power_cells");
      var _loc3_ = false;
      for(var _loc4_ in _loc2_.data)
      {
         _loc3_ = true;
      }
      if(_loc3_)
      {
         if(_loc2_.data.pc.length <= 0)
         {
            _loc2_.data.pc = new Array();
         }
      }
      else
      {
         _loc2_.data.pc = new Array();
      }
      this.powercells = new Array();
      this.powercells = _loc2_.data.pc;
   }
   function getTotalCollected()
   {
      var _loc1_ = SharedObject.getLocal("toxic_power_cells");
      return _loc1_.data.pc.length;
   }
   function getCollected(level_number, row, col)
   {
      var _loc2_;
      if(this.powercells.length > 0)
      {
         _loc2_ = 0;
         while(_loc2_ < this.powercells.length)
         {
            if(this.powercells[_loc2_].ln == level_number && this.powercells[_loc2_].row == row && this.powercells[_loc2_].col == col)
            {
               return true;
            }
            _loc2_ = _loc2_ + 1;
         }
      }
      return false;
   }
   function setCollected(level_number, row, col)
   {
      this.powercells.push({ln:level_number,row:row,col:col});
   }
   function finaliseLevel()
   {
      var _loc2_ = SharedObject.getLocal("toxic_power_cells");
      _loc2_.data.pc = this.powercells;
      _loc2_.flush();
   }
   function clearAll()
   {
      var _loc1_ = SharedObject.getLocal("toxic_power_cells");
      _loc1_.clear();
   }
   function getLevelCollected(level_number)
   {
      var _loc2_ = SharedObject.getLocal("toxic_power_cells");
      var _loc3_ = 0;
      var _loc1_;
      if(_loc2_.data.pc.length > 0)
      {
         _loc1_ = 0;
         while(_loc1_ < _loc2_.data.pc.length)
         {
            if(_loc2_.data.pc[_loc1_].ln == level_number)
            {
               _loc3_ = _loc3_ + 1;
            }
            _loc1_ = _loc1_ + 1;
         }
      }
      return _loc3_;
   }
}
