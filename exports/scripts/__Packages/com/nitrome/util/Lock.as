class com.nitrome.util.Lock extends MovieClip
{
   function Lock()
   {
      super();
      this._visible = false;
      var _loc4_;
      if(true == true)
      {
         this._visible = false;
      }
      else
      {
         this._visible = true;
         _loc4_ = "http://www.nitrome.com/games/" + _root.ng.getGameId();
         this.getURL(_loc4_,"_blank");
      }
   }
}
