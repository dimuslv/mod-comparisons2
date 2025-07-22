class com.nitrome.buttons.ContinueButton extends com.nitrome.buttons.SimpleButton
{
   function ContinueButton()
   {
      super();
   }
   function doPress()
   {
      _root.game.unpauseGame();
      _root.popup_holder.hidePopUp();
   }
}
