class com.nitrome.game.SfxManager extends MovieClip
{
   function SfxManager()
   {
      super();
   }
   function playSound(id)
   {
      if(_root.mc.getSfxOn() == true)
      {
         this[id].gotoAndPlay(2);
      }
   }
}
