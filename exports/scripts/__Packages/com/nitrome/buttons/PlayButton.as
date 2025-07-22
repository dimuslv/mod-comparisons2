class com.nitrome.buttons.PlayButton extends com.nitrome.buttons.SimpleButton
{
   function PlayButton()
   {
      super();
   }
   function doPress()
   {
      _root.tt.doTween("map");
   }
}
