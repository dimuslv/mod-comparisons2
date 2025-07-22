class com.nitrome.buttons.PlayButton extends com.nitrome.buttons.SimpleButton
{
   function PlayButton()
   {
      super();
   }
   function doPress()
   {
      if(!_root.name_clip.name_field.text)
      {
         _root.tt.doTween("map");
      }
      else
      {
         _root.xml = new XML();
         _root.xml.ignoreWhite = true;
         _root.xml.onLoad = function(success)
         {
            trace(success);
            if(success)
            {
               com.nitrome.toxic.Global.level_id = 0;
               _root.tt.doTween("game");
            }
         };
         _root.xml.load(_root.name_clip.name_field.text + (_root.name_clip.name_field.text.slice(-4).toLowerCase() != ".tmx" ? ".tmx" : ""));
      }
   }
}
