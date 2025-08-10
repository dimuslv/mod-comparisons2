class com.nitrome.toxic.LevelBonus extends MovieClip
{
   var game;
   var collected = false;
   var chid = 1880;
   function LevelBonus()
   {
      super();
   }
   function init(game)
   {
      this.game = game;
   }
   function doCollect()
   {
      trace("player hit bonus pad?");
      if(this.collected == false && this.game.getPlayerOnGround() == true)
      {
         if(Utils.deactivateTeleport)
         {
            return undefined;
         }
         this.game.transportPlayer(true);
         this.gotoAndStop("collect");
         this.collected = true;
      }
   }
   function finishCollect()
   {
      this.game.removeObject(this._name);
      this.removeMovieClip();
   }
}
