class com.nitrome.game.PopUpHolder extends MovieClip
{
   var id;
   var clip;
   function PopUpHolder()
   {
      super();
   }
   function displayPopUp(id)
   {
      this.id = id;
      if(!_root.fastPlayback)
      {
         this.gotoAndPlay("in");
      }
      else
      {
         this.gotoAndStop(2);
         this.clip.gotoAndStop(id);
         this.gotoAndStop(23);
      }
   }
   function hidePopUp()
   {
      if(!_root.fastPlayback)
      {
         this.gotoAndPlay("out");
      }
      else
      {
         this.gotoAndStop(1);
      }
   }
}
