class Code
{
	function Code()
	{
	}
	static function isS(sym, str)
	{
		return str.indexOf(sym) !== -1;
	}
	static function isWhiteSpaceAt(str, ind)
	{
		return Code.isWhiteSpace(str.charAt(ind));
	}
	static function isWhiteSpace(c)
	{
		return Code.isS(c," \t\r\n");
	}
	static function indOf(str1, str2, ind)
	{
		if(!ind)
		{
			ind = 0;
		}
		ind = str1.indexOf(str2,ind);
		if(ind === -1)
		{
			return str1.length;
		}
		return ind;
	}
	static function parseAngled(str, ind)
	{
		var _loc4_ = {_x:[0,0],_y:[0,0],vx:[0,0],vy:[0,0],state:[0,0]};
		var _loc5_ = -1;
		var _loc6_ = -1;
		var _loc7_;
		var _loc8_;
		var _loc9_;
		var _loc10_;
		var _loc11_;
		var _loc12_;
		while(ind < str.length)
		{
			_loc7_ = str.charAt(ind);
			if(!Code.isWhiteSpace(_loc7_))
			{
				if(_loc7_ === ">")
				{
					break;
				}
				if(_loc5_ === -1 || !Code.isS(_loc7_,":;"))
				{
					if(_loc5_ === -1)
					{
						_loc5_ = ind;
					}
					_loc6_ = ind + 1;
				}
				else
				{
					_loc8_ = str.slice(_loc5_,_loc6_);
					_loc9_ = {x:"_x",y:"_y",wc:"wall_count",fc:"fall_count",st:"state"}[_loc8_];
					if(_loc9_)
					{
						_loc8_ = _loc9_;
					}
					if(_root.game.player[_loc8_] === undefined)
					{
						break;
					}
					if(_loc7_ === ";")
					{
						delete _loc4_[_loc8_];
						_loc5_ = -1;
					}
					else
					{
						_loc4_[_loc8_] = [0,0];
						_loc10_ = false;
						_loc11_ = 0;
						while(_loc11_ < 2)
						{
							_loc5_ = -1;
							_loc6_ = -1;
							ind = ind + 1;
							while(ind < str.length)
							{
								_loc7_ = str.charAt(ind);
								if(Code.isS(_loc7_,",;"))
								{
									break;
								}
								if(!Code.isWhiteSpace(_loc7_))
								{
									if(_loc5_ === -1)
									{
										_loc5_ = ind;
									}
									_loc6_ = ind + 1;
								}
								ind = ind + 1;
							}
							if(ind >= str.length || _loc5_ === -1)
							{
								_loc10_ = true;
								break;
							}
							_loc12_ = Number(str.slice(_loc5_,_loc6_));
							if(isNaN(_loc12_))
							{
								_loc10_ = true;
								break;
							}
							if(_loc7_ === ";" && _loc11_ === 0)
							{
								if(_loc12_ >= 0)
								{
									_loc4_[_loc8_][1] = _loc12_;
									break;
								}
								_loc4_[_loc8_][0] = _loc12_;
								break;
							}
							if(_loc7_ === "," && _loc11_ === 1)
							{
								_loc10_ = true;
								break;
							}
							_loc4_[_loc8_][_loc11_] = _loc12_;
							_loc11_ = _loc11_ + 1;
						}
						if(_loc10_)
						{
							break;
						}
						_loc5_ = -1;
					}
				}
			}
			ind = ind + 1;
		}
		return [_loc4_,Code.indOf(str,">",ind) + 1];
	}
}
