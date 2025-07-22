class com.nitrome.toxic.InfoPoint extends MovieClip
{
   var anim;
   var info_str;
   var game;
   var collected = false;
   function InfoPoint()
   {
      super();
   }
   function getInfoPoint()
   {
      return true;
   }
   function doPause()
   {
      this.anim.stop();
   }
   function doUnpause()
   {
      this.anim.play();
   }
   function init(str, game)
   {
      this.info_str = str;
      this.game = game;
   }
   function doCollect()
   {
      if(this.collected == false)
      {
         _root.text_display.displayText(this.info_str,1);
         this.collected = true;
      }
   }
   function endCollect()
   {
      if(this.collected == true)
      {
         _root.text_display.hideText();
         this.collected = false;
      }
   }
}
