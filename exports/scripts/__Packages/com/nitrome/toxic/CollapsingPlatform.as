class com.nitrome.toxic.CollapsingPlatform extends MovieClip
{
   var game;
   var player;
   var collected = false;
   var chid = 926;
   function CollapsingPlatform()
   {
      super();
   }
   function init(game)
   {
      this.game = game;
   }
   function setPlayer(player)
   {
      this.player = player;
   }
   function doCollect()
   {
      if(this.collected == false && this.player._y == this._y)
      {
         this.gotoAndStop("collapse");
         this.collected = true;
      }
   }
   function setCollapseSize(n)
   {
      this.game.drawCollapsePlatform(n,this._x,this._y);
   }
   function finishCollapse()
   {
      this.game.drawCollapsePlatform(7,this._x,this._y);
      this.game.removeObject(this._name);
      this.removeMovieClip();
   }
}
