class com.nitrome.toxic.PlatformBomb extends MovieClip
{
	var anim;
	var bottom_boundary;
	var dir;
	var game;
	var left_boundary;
	var right_boundary;
	var top_boundary;
	var vx;
	var vy;
	var throw_count = 0;
	var max_throw_count = 5;
	var can_move = true;
	var INERTIA = 0.92;
	var GRAVITY = 1;
	var landed = false;
	var chid = 1928;
	function PlatformBomb()
	{
		super();
	}
	function getBombType()
	{
		return com.nitrome.toxic.Global.BOMB_PLATFORM;
	}
	function doPause()
	{
		_root._stop(this.anim);
	}
	function doUnpause()
	{
		_root._play(this.anim);
	}
	function initPlayer(game, x, y, d, s, player_vx, player_vy, flag)
	{
		this.game = game;
		this._x = x;
		this._y = y;
		if(s == com.nitrome.toxic.Global.DUCK)
		{
			if(d == com.nitrome.toxic.Global.LEFT)
			{
				if(flag == true)
				{
					this.vx = 0;
					this.vy = -1;
				}
				else
				{
					this.vx = -1;
					this.vy = -1;
				}
			}
			else if(d == com.nitrome.toxic.Global.RIGHT)
			{
				if(flag == true)
				{
					this.vx = 0;
					this.vy = -1;
				}
				else
				{
					this.vx = 1;
					this.vy = -1;
				}
			}
		}
		else if(s == com.nitrome.toxic.Global.STAND)
		{
			if(d == com.nitrome.toxic.Global.LEFT)
			{
				if(flag == true)
				{
					this.vx = 0;
					this.vy = -2;
				}
				else
				{
					this.vx = -2;
					this.vy = -2;
				}
			}
			else if(d == com.nitrome.toxic.Global.RIGHT)
			{
				if(flag == true)
				{
					this.vx = 0;
					this.vy = -2;
				}
				else
				{
					this.vx = 2;
					this.vy = -2;
				}
			}
		}
		else if(s == com.nitrome.toxic.Global.WALK)
		{
			if(d == com.nitrome.toxic.Global.LEFT)
			{
				if(flag == true)
				{
					this.vx = 0;
					this.vy = -2;
				}
				else
				{
					this.vx = -2;
					this.vy = -2;
				}
			}
			else if(d == com.nitrome.toxic.Global.RIGHT)
			{
				if(flag == true)
				{
					this.vx = 0;
					this.vy = -2;
				}
				else
				{
					this.vx = 2;
					this.vy = -2;
				}
			}
		}
		else if(s == com.nitrome.toxic.Global.JUMP || s == com.nitrome.toxic.Global.FALL)
		{
			if(player_vy > 0)
			{
				this.vy = player_vy + 1;
			}
			else
			{
				this.vx = 0;
				this.vy = 1;
			}
		}
		if(this.vx > 0)
		{
			this.dir = com.nitrome.toxic.Global.RIGHT;
		}
		else if(this.vx < 0)
		{
			this.dir = com.nitrome.toxic.Global.LEFT;
		}
	}
	function doExplode()
	{
		this.game.createExplosion(this._x,this._y,this._name,com.nitrome.toxic.Global.BOMB_PLATFORM);
	}
	function finishExplode()
	{
	}
	function getFinishedExplode()
	{
		return true;
	}
	function main()
	{
		var _loc3_;
		var _loc2_;
		if(this.can_move == true)
		{
			this.throw_count = this.throw_count + 1;
			if(this.throw_count >= this.max_throw_count)
			{
				this._x = Math.round(this._x);
				this._y = Math.round(this._y);
				this.game.drawPlatformBomb(this._x,this._y);
				this.can_move = false;
				return undefined;
			}
			if(!(this.vx == 0 && this.vy == 0))
			{
				this.landed = false;
				_loc3_ = this.checkVertWalls(this.vx);
				this._x += _loc3_;
				this._y += this.checkHorizWalls(this.vy);
				_loc2_ = Math.abs(this.vx);
				_loc2_ *= this.INERTIA;
				if(this.vx > 0)
				{
					this.vx = _loc2_;
				}
				else if(this.vx < 0)
				{
					this.vx = - _loc2_;
				}
				_loc2_ = Math.abs(this.vy);
				_loc2_ *= this.INERTIA;
				if(this.vy > 0)
				{
					this.vy = _loc2_;
				}
				else if(this.vy < 0)
				{
					this.vy = - _loc2_;
				}
				this.vy += this.GRAVITY;
				if(Math.abs(this.vy) < 0.5 && this.landed == true)
				{
					this.vy = 0;
					this.adjustToFloor();
				}
				if(Math.abs(this.vx) < 0.01)
				{
					this.vx = 0;
				}
			}
		}
	}
	function checkVertWalls(v)
	{
		var _loc5_;
		var _loc6_;
		var _loc3_;
		var _loc2_;
		if(v != 0)
		{
			if(v > 0)
			{
				_loc5_ = new Array(-8,-6,-4,-2,0,2,4,6);
				_loc6_ = this._x + this.right_boundary._x;
				_loc3_ = 0;
				while(_loc3_ < Math.abs(v))
				{
					_loc2_ = 0;
					while(_loc2_ < _loc5_.length)
					{
						if(this.game.getSceneryCollision(_loc6_ + _loc3_,this._y + _loc5_[_loc2_]) == true)
						{
							this.vx = v * -1;
							this.dir = com.nitrome.toxic.Global.LEFT;
							return _loc3_;
						}
						_loc2_ = _loc2_ + 1;
					}
					_loc3_ = _loc3_ + 1;
				}
				return v;
			}
			if(v < 0)
			{
				_loc5_ = new Array(-8,-6,-4,-2,0,2,4,6);
				_loc6_ = this._x + this.left_boundary._x;
				_loc3_ = 0;
				while(_loc3_ < Math.abs(v))
				{
					_loc2_ = 0;
					while(_loc2_ < _loc5_.length)
					{
						if(this.game.getSceneryCollision(_loc6_ - _loc3_,this._y + _loc5_[_loc2_]) == true)
						{
							this.vx = v * -1;
							this.dir = com.nitrome.toxic.Global.RIGHT;
							return - _loc3_;
						}
						_loc2_ = _loc2_ + 1;
					}
					_loc3_ = _loc3_ + 1;
				}
				return v;
			}
		}
		return 0;
	}
	function checkHorizWalls(v)
	{
		var _loc5_;
		var _loc6_;
		var _loc3_;
		var _loc2_;
		if(v != 0)
		{
			if(v > 0)
			{
				_loc5_ = new Array(-6,-4,-2,0,2,4,6,8);
				_loc6_ = this._y + this.bottom_boundary._y;
				_loc3_ = 0;
				while(_loc3_ < Math.abs(v))
				{
					_loc2_ = 0;
					while(_loc2_ < _loc5_.length)
					{
						if(this.game.getSceneryCollision(this._x + _loc5_[_loc2_],_loc6_ + _loc3_) == true)
						{
							if(this.vy > 1)
							{
								this.vy = this.vy - 1;
							}
							this.vy = v * -1;
							this.landed = true;
							return _loc3_;
						}
						_loc2_ = _loc2_ + 1;
					}
					_loc3_ = _loc3_ + 1;
				}
				return v;
			}
			if(v < 0)
			{
				_loc5_ = new Array(-8,-6,-4,-2,0,2,4,6);
				_loc6_ = this._y + this.top_boundary._y;
				_loc3_ = 0;
				while(_loc3_ < Math.abs(v))
				{
					_loc2_ = 0;
					while(_loc2_ < _loc5_.length)
					{
						if(this.game.getSceneryCollision(this._x + _loc5_[_loc2_],_loc6_ - _loc3_) == true)
						{
							this.vy = v * -1;
							this.landed = true;
							return - _loc3_;
						}
						_loc2_ = _loc2_ + 1;
					}
					_loc3_ = _loc3_ + 1;
				}
				return v;
			}
		}
		return 0;
	}
	function adjustToFloor()
	{
		var _loc2_;
		if(this.getInGround(this._x,this._y + this.bottom_boundary._y) == false)
		{
			_loc2_ = 1;
			while(_loc2_ <= 8)
			{
				if(this.getOnGround(this._x,this._y + this.bottom_boundary._y + _loc2_) == true)
				{
					this._y += _loc2_ - 1;
					break;
				}
				_loc2_ = _loc2_ + 1;
			}
		}
	}
	function getOnGround(x, y)
	{
		if(this.game.getSceneryCollision(x,y) == true)
		{
			if(this.game.getSceneryCollision(x,y - 1) == false)
			{
				return true;
			}
			return false;
		}
		return false;
	}
	function getInGround(x, y)
	{
		if(this.game.getSceneryCollision(x,y) == true)
		{
			if(this.game.getSceneryCollision(x,y - 1) == true)
			{
				return true;
			}
			return false;
		}
		return false;
	}
}
