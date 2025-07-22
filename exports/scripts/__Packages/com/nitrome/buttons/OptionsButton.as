class com.nitrome.buttons.OptionsButton extends com.nitrome.buttons.SimpleButton
{
   function OptionsButton()
   {
      super();
   }
   function doPress()
   {
      _root.tt.doTween("options");
   }
}
