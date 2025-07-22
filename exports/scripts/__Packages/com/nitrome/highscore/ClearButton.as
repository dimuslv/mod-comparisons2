class com.nitrome.highscore.ClearButton extends com.nitrome.buttons.SimpleButton
{
   function ClearButton()
   {
      super();
   }
   function onPress()
   {
      this._parent.clearName();
   }
}
