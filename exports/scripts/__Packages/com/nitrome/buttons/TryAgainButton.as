class com.nitrome.buttons.TryAgainButton extends com.nitrome.buttons.SimpleButton
{
   var onKeyDown;
   var done = false;
   function TryAgainButton()
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
         _root.tt.doTween("reload");
         _root.popup_holder.hidePopUp();
         Key.removeListener(this);
         this.done = true;
      }
   }
   function clearKeyListener()
   {
      Key.removeListener(this);
   }
}
