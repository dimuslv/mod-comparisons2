class com.nitrome.toxic.HoloButton extends MovieClip
{
   var game;
   var row;
   var col;
   var names;
   var active = false;
   var timer_count = 0;
   var max_timer = 200;
   var chid = 1591;
   function HoloButton()
   {
      super();
   }
   function init(game, row, col)
   {
      this.game = game;
      this.row = row;
      this.col = col;
   }
   function getRow()
   {
      return this.row;
   }
   function getCol()
   {
      return this.col;
   }
   function savePath(path)
   {
      this.names = new Array();
      this.names = path.getNames();
   }
   function doActivate()
   {
      var _loc2_;
      if(this.active == false)
      {
         this.timer_count = 0;
         _loc2_ = 1;
         while(_loc2_ < this.names.length)
         {
            this.game.displayHoloPlatform(this.names[_loc2_]);
            _loc2_ = _loc2_ + 1;
         }
         this.gotoAndStop("on");
         this.active = true;
      }
   }
   function doDeactivate()
   {
      var _loc2_ = 1;
      while(_loc2_ < this.names.length)
      {
         this.game.hideHoloPlatform(this.names[_loc2_]);
         _loc2_ = _loc2_ + 1;
      }
      this.game.removeHoloButton(this._name);
      this.gotoAndStop("off");
      this.active = false;
   }
   function main()
   {
      this.timer_count = this.timer_count + 1;
      if(this.timer_count == 150)
      {
         _root.sfx.playSound("holo");
         this.gotoAndStop("flash");
      }
      if(this.timer_count >= this.max_timer)
      {
         this.doDeactivate();
      }
   }
}
