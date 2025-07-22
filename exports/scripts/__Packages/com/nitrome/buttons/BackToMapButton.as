class com.nitrome.buttons.BackToMapButton extends com.nitrome.buttons.SimpleButton
{
   function BackToMapButton()
   {
      super();
   }
   function doPress()
   {
      this._parent.key_button.clearKeyListener();
      _root.mc.startMenuMusic(false);
      _root.tt.doTween("map");
   }
}
