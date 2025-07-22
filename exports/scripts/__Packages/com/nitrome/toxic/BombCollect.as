class com.nitrome.toxic.BombCollect extends MovieClip
{
   var game;
   var bomb_type;
   var spawner;
   var anim;
   var collected = false;
   function BombCollect()
   {
      super();
   }
   function init(game, bomb_type, spawner)
   {
      this.game = game;
      this.bomb_type = bomb_type;
      this.spawner = spawner;
   }
   function doPause()
   {
      this.anim.stop();
   }
   function doUnpause()
   {
      this.anim.play();
   }
   function doCollect()
   {
      if(this.collected == false)
      {
         this.gotoAndStop("collect");
         this.spawner.gotoAndStop("collect");
         this.game.setBombType(this.bomb_type);
         _root.bomb_panel.collectBomb(this.bomb_type);
         this.collected = true;
      }
   }
   function finishCollect()
   {
      this.collected = false;
      this.gotoAndStop("normal");
   }
}
