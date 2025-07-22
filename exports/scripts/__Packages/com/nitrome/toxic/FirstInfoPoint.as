class com.nitrome.toxic.FirstInfoPoint extends MovieClip
{
   var anim;
   var info_str;
   var game;
   var collected = false;
   var hacked = false;
   var first_read = false;
   var chid = 1482;
   function FirstInfoPoint()
   {
      super();
   }
   function getInfoPoint()
   {
      return true;
   }
   function doPause()
   {
      _root._stop(this.anim);
   }
   function doUnpause()
   {
      _root._play(this.anim);
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
         if(this.hacked == false)
         {
            _root.text_display.displayText("0100110100010111010100101010101000100010101001010101001101000101110111001011101010001000101010010100000011010001011101010110101010100010001010000101",2);
         }
         else
         {
            _root.text_display.displayText(this.info_str,1);
         }
         this.collected = true;
      }
   }
   function endCollect()
   {
      if(this.collected == true)
      {
         if(this.hacked == true)
         {
            if(this.first_read == false)
            {
               this.game.openDoor(3);
               this.first_read = true;
            }
         }
         _root.text_display.hideText();
         this.collected = false;
      }
   }
   function checkExplosions()
   {
      if(this.hacked == false)
      {
         if(this.hitTest(_root.game.explosion_holder) == true)
         {
            this.hack();
         }
      }
   }
   function hack()
   {
      this.hacked = true;
      this.gotoAndStop("hacked");
      this.endCollect();
   }
}
