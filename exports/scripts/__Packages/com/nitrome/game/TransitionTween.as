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
      this.gotoAndPlay(2);
   }
   function changeFrame()
   {
      _root.game.clearAll();
      this._parent.gotoAndStop(this.frame);
   }
}
