class com.nitrome.toxic.BubbleTile extends MovieClip
{
	function BubbleTile()
	{
		super();
		var _loc4_;
		var _loc3_;
		if(!_root.aMode || this._parent._parent._parent != _root.game)
		{
			if(this._name.indexOf("copy") == -1)
			{
				_loc4_ = this._name.slice(7);
				_loc3_ = random(267) + 1;
				this.gotoAndPlay(_loc3_);
				this._parent["bubblecopy_" + _loc4_].gotoAndPlay(_loc3_);
				this._parent["bubblecopy2_" + _loc4_].gotoAndPlay(_loc3_);
			}
		}
	}
}
