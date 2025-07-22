class com.nitrome.game.PopUpHolder extends MovieClip
{
   var id;
   function PopUpHolder()
   {
      super();
   }
   function displayPopUp(id)
   {
      this.id = id;
      this.gotoAndPlay("in");
   }
   function hidePopUp()
   {
      this.gotoAndPlay("out");
   }
}
