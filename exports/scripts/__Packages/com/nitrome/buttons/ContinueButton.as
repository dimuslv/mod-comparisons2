class com.nitrome.buttons.ContinueButton extends com.nitrome.buttons.SimpleButton
{
   function ContinueButton()
   {
      super();
   }
   function doPress()
   {
      if(!_root.aMode)
      {
         _root.game.unpauseGame();
         _root.popup_holder.hidePopUp();
      }
      else
      {
         _root.justPause = false;
      }
   }
}
