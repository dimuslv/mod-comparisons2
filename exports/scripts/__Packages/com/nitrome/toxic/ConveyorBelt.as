class com.nitrome.toxic.ConveyorBelt extends MovieClip
{
   var game;
   var dir;
   var anim;
   var speed = new Array(-3,3);
   function ConveyorBelt()
   {
      super();
   }
   function init(game, dir)
   {
      this.game = game;
      this.dir = dir;
   }
   function doPause()
   {
      this.anim.stop();
   }
   function doUnpause()
   {
      this.anim.play();
   }
   function getOnScreen()
   {
      if(this.hitTest(_root.screen_test) == true)
      {
         return true;
      }
      return false;
   }
   function main()
   {
      if(this.getOnScreen() == true)
      {
         this._visible = true;
      }
      else
      {
         this._visible = false;
      }
   }
   function getSpeed()
   {
      return this.speed[this.dir];
   }
}
