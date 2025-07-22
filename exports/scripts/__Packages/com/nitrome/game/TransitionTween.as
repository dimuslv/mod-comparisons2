class com.nitrome.game.TransitionTween extends MovieClip
{
   var frame;
   function TransitionTween()
   {
      super();
   }
   function doTween(frame)
   {
      this.frame = frame;
      if(false)
      {
         this.gotoAndPlay(2);
      }
      else
      {
         this.changeFrame();
      }
   }
   function changeFrame()
   {
      _root.game.clearAll();
      this._parent.gotoAndStop(this.frame);
   }
}
