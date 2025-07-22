class com.nitrome.toxic.PowerCell extends MovieClip
{
   var anim;
   var game;
   var dull;
   var row;
   var col;
   var collected = false;
   var chid = 2158;
   function PowerCell()
   {
      super();
   }
   function doPause()
   {
      _root._stop(this.anim);
   }
   function doUnpause()
   {
      _root._play(this.anim);
   }
   function init(game, dull, row, col)
   {
      this.game = game;
      this.dull = dull;
      this.row = row;
      this.col = col;
      if(dull == true)
      {
         this._alpha = 50;
      }
   }
   function doCollect()
   {
      if(this.collected == false)
      {
         this.gotoAndStop("collect");
         if(this.dull == false)
         {
            _root.powercell_panel.increment();
            this.game.collectPowerCell(this.row,this.col);
            this.dull = true;
         }
         this.collected = true;
      }
   }
   function finishCollect()
   {
      this.game.removeObject(this._name);
      this.removeMovieClip();
   }
}
