class com.nitrome.toxic.SmokeTile extends MovieClip
{
   function SmokeTile()
   {
      super();
      var _loc4_;
      var _loc3_;
      if(this._name.indexOf("copy") == -1)
      {
         _loc4_ = this._name.slice(6);
         _loc3_ = _root._random(707) + 1;
         this.gotoAndPlay(_loc3_);
         this._parent["smokecopy_" + _loc4_].gotoAndPlay(_loc3_);
         this._parent["smokecopy2_" + _loc4_].gotoAndPlay(_loc3_);
      }
   }
}
