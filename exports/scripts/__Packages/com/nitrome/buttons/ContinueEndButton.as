class com.nitrome.buttons.ContinueEndButton extends com.nitrome.buttons.SimpleButton
{
   var onKeyDown;
   var done = false;
   function ContinueEndButton()
   {
      super();
      this.clearKeyListener();
      this.onKeyDown = function()
      {
         if(Key.getCode() == 32)
         {
            this.doPress();
         }
      };
      Key.addListener(this);
   }
   function doPress()
   {
      if(this.done == false)
      {
         _root.tt.doTween("ending");
         _root.mc.startMenuMusic(false);
         Key.removeListener(this);
         this.done = true;
      }
   }
   function clearKeyListener()
   {
      Key.removeListener(this);
   }
}
