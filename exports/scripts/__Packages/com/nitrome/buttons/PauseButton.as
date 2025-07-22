class com.nitrome.buttons.PauseButton extends com.nitrome.buttons.SimpleButton
{
   function PauseButton()
   {
      super();
   }
   function doPress()
   {
      _root.popup_holder.displayPopUp("game_paused");
      _root.game.pauseGame();
   }
}
