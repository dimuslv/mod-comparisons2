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
         if(!_root.fastPlayback)
         {
            this[id].gotoAndPlay(2);
         }
      }
   }
}
