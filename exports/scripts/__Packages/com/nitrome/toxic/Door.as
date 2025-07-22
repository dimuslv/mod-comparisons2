class com.nitrome.toxic.Door extends MovieClip
{
   var game;
   var side;
   function Door()
   {
      super();
   }
   function init(game, side)
   {
      this.game = game;
      this.side = side;
   }
   function doClose()
   {
      this.gotoAndStop("close");
   }
   function finishClose()
   {
      this.game.drawDoor(this._x,this._y);
      this.game.nextDoor(this.side);
   }
   function doOpen()
   {
      this.game.clearDoor(this._x,this._y);
      this.gotoAndStop("open");
   }
   function finishOpen()
   {
      this.game.openDoor(this.side);
   }
}
