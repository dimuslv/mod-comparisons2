class com.nitrome.toxic.DiggerBomb extends MovieClip
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
	var INERTIA = 0.92;
	var GRAVITY = 1;
	var landed = false;
	var on_conveyor = false;
	var prev_conveyor = false;
	var hit_wall = -1;
	var digging = false;
	var dig_count = 0;
	var max_dig_count = 20;
	var explode_count = 0;
	var max_explode_count = 5;
	var chid = 1262;
	function DiggerBomb()
	{
		super();
	}
	function getBombType()
	{
		return com.nitrome.toxic.Global.BOMB_DIGGER;
	}
	function doPause()
	{
		_root._stop(this.anim);
		_root._stop(this.anim.clip.clip);
	}
	function doUnpause()
	{
		_root._play(this.anim);
		_root._play(this.anim.clip.clip);
	}
	function init(game, x, y, vx, vy)
	{
		this.game = game;
		this._x = x;
		this._y = y;
		this.vx = vx;
		this.vy = vy;
		if(vx > 0)
		{
			this.dir = com.nitrome.toxic.Global.RIGHT;
		}
		else if(vx < 0)
		{
			this.dir = com.nitrome.toxic.Global.LEFT;
		}
		this.adjustToFloor();
	}
	function initPlayer(game, x, y, d, s, player_vx, player_vy, flag)
	{
		this.game = game;
		this._x = x;
		this._y = y;
		if(s == com.nitrome.toxic.Global.DUCK)
		{
			this.vx = 0;
			this.vy = 0;
			this.hit_wall = com.nitrome.toxic.Global.DOWN;
			this.anim.clip.gotoAndStop("down");
		}
		else if(s == com.nitrome.toxic.Global.STAND)
		{
			if(d == com.nitrome.toxic.Global.LEFT)
			{
				if(flag == true)
				{
					this.vx = 0;
					this.vy = -3;
				}
				else
				{
					this.vx = -3;
					this.vy = -3;
				}
			}
			else if(d == com.nitrome.toxic.Global.RIGHT)
			{
				if(flag == true)
				{
					this.vx = 0;
					this.vy = -3;
				}
				else
				{
					this.vx = 3;
					this.vy = -3;
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
					this.vy = -3;
				}
				else
				{
					this.vx = -3 + player_vx;
					this.vy = -3;
				}
			}
			else if(d == com.nitrome.toxic.Global.RIGHT)
			{
				if(flag == true)
				{
					this.vx = 0;
					this.vy = -3;
				}
				else
				{
					this.vx = 3 + player_vx;
					this.vy = -3;
				}
			}
		}
		else if(s == com.nitrome.toxic.Global.JUMP || s == com.nitrome.toxic.Global.FALL)
		{
			if(d == com.nitrome.toxic.Global.LEFT)
			{
				if(flag == true)
				{
					this.vx = 0;
					this.vy = -3 + player_vy;
				}
				else
				{
					this.vx = -3 + player_vx;
					this.vy = -3 + player_vy;
				}
			}
			else if(d == com.nitrome.toxic.Global.RIGHT)
			{
				if(flag == true)
				{
					this.vx = 0;
					this.vy = -3 + player_vy;
				}
				else
				{
					this.vx = 3 + player_vx;
					this.vy = -3 + player_vy;
				}
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
		this.adjustToFloor();
	}
	function doExplode()
	{
		var _loc2_ = String(this._name + "*" + this.explode_count);
		this.game.updateBombName(this._name,_loc2_);
		this._name = String(this._name + "*" + this.explode_count);
		this.explode_count = this.explode_count + 1;
		this.digging = true;
		this.game.createExplosion(this._x,this._y,this._name,com.nitrome.toxic.Global.BOMB_DIGGER,this.hit_wall);
		Main._gotoAndStop(this.anim,"hidden",1261);
	}
	function getFinishedExplode()
	{
		if(this.explode_count >= this.max_explode_count)
		{
			return true;
		}
		return false;
	}
	function finishExplode()
	{
	}
	function main()
	{
		var _loc3_;
		var _loc2_;
		if(this.digging == true)
		{
			this.checkConveyorBelts();
			this.dig_count = this.dig_count + 1;
			if(this.dig_count >= this.max_dig_count)
			{
				if(this.hit_wall == com.nitrome.toxic.Global.LEFT)
				{
					this._x -= 50;
				}
				else if(this.hit_wall == com.nitrome.toxic.Global.RIGHT)
				{
					this._x += 50;
				}
				else if(this.hit_wall == com.nitrome.toxic.Global.UP)
				{
					this._y -= 50;
				}
				else if(this.hit_wall == com.nitrome.toxic.Global.DOWN)
				{
					this._y += 50;
				}
				this.doExplode();
				this.dig_count = 0;
			}
		}
		else
		{
			if(!(this.vx == 0 && this.vy == 0))
			{
				this.landed = false;
				this.hit_wall = -1;
				_loc3_ = this.checkVertWalls(this.vx);
				this._x += _loc3_;
				this._y += this.checkHorizWalls(this.vy);
				if(this.hit_wall != -1)
				{
					this.hit_wall = this.checkHitWall();
					if(this.hit_wall == com.nitrome.toxic.Global.LEFT)
					{
						this.anim.clip.gotoAndStop("left");
						this.vx = 0;
						this.vy = 0;
					}
					else if(this.hit_wall == com.nitrome.toxic.Global.RIGHT)
					{
						this.anim.clip.gotoAndStop("right");
						this.vx = 0;
						this.vy = 0;
					}
					else if(this.hit_wall == com.nitrome.toxic.Global.UP)
					{
						this.anim.clip.gotoAndStop("up");
						this.vx = 0;
						this.vy = 0;
					}
					else if(this.hit_wall == com.nitrome.toxic.Global.DOWN)
					{
						this.anim.clip.gotoAndStop("down");
						this.vx = 0;
						this.vy = 0;
					}
					else if(this.hit_wall == -1)
					{
					}
				}
				else
				{
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
			if(this.getOnGround(this._x,this._y + this.bottom_boundary._y) == true || this.vx == 0 && this.vy == 0)
			{
				this.prev_conveyor = this.on_conveyor;
				this.on_conveyor = false;
				this.checkConveyorBelts();
				if(this.on_conveyor == false && this.prev_conveyor == true)
				{
					this.vx = 0;
				}
			}
		}
	}
	function conveyor(xspeed)
	{
		this.on_conveyor = true;
		if(xspeed > 0)
		{
			if(xspeed > this.vx)
			{
				xspeed -= this.vx;
			}
		}
		else if(xspeed < 0)
		{
			if(xspeed < this.vx)
			{
				xspeed = - (Math.abs(xspeed) - Math.abs(this.vx));
			}
		}
		var _loc3_ = this.checkConveyorWalls(xspeed);
		this._x += _loc3_;
	}
	function checkConveyorBelts()
	{
		var _loc4_;
		var _loc5_;
		var _loc6_;
		if(this.hitTest(_root.game.object_holder) == true)
		{
			_loc4_ = new Object();
			_loc4_.xMin = this._x - 25;
			_loc4_.xMax = this._x + 25;
			_loc4_.yMin = this._y - 25;
			_loc4_.yMax = this._y + 25;
			_global.img = new flash.display.BitmapData(_loc4_.xMax - _loc4_.xMin,_loc4_.yMax - _loc4_.yMin,false);
			_loc5_ = new flash.geom.Matrix();
			_loc5_.tx -= _loc4_.xMin;
			_loc5_.ty -= _loc4_.yMin;
			_global.imgc.draw(_root.game.object_holder,_loc5_,new flash.geom.ColorTransform(1,1,1,1,255,-255,-255,255));
			_global.imgc.draw(_root.game.bomb_holder,_loc5_,new flash.geom.ColorTransform(1,1,1,1,255,255,255,255),"difference");
			_loc6_ = _global.imgc.getColorBoundsRect(4294967295,4278255615);
			if(_loc6_.width != 0)
			{
				this.game.findConveyor(this);
			}
			_global.imgc.dispose();
			delete _global.imgc;
		}
	}
	function checkConveyorWalls(v)
	{
		var _loc4_;
		var _loc6_;
		var _loc3_;
		var _loc2_;
		if(v != 0)
		{
			if(v > 0)
			{
				_loc4_ = new Array(-10,-8,-6,-4,-2,0,2,4,6);
				_loc6_ = this._x + this.right_boundary._x;
				_loc3_ = 0;
				while(_loc3_ < Math.abs(v))
				{
					_loc2_ = 0;
					while(_loc2_ < _loc4_.length)
					{
						if(this.game.getSceneryCollision(_loc6_ + _loc3_,this._y + _loc4_[_loc2_]) == true)
						{
							this.vx = _loc3_;
							this.dir = com.nitrome.toxic.Global.RIGHT;
							if(this.digging == false)
							{
								this.hit_wall = com.nitrome.toxic.Global.RIGHT;
							}
							return _loc3_;
						}
						_loc2_ = _loc2_ + 1;
					}
					_loc3_ = _loc3_ + 1;
				}
				this.vx = v;
				this.dir = com.nitrome.toxic.Global.RIGHT;
				return v;
			}
			if(v < 0)
			{
				_loc4_ = new Array(-10,-8,-6,-4,-2,0,2,4,6);
				_loc6_ = this._x + this.left_boundary._x;
				_loc3_ = 0;
				while(_loc3_ < Math.abs(v))
				{
					_loc2_ = 0;
					while(_loc2_ < _loc4_.length)
					{
						if(this.game.getSceneryCollision(_loc6_ - _loc3_,this._y + _loc4_[_loc2_]) == true)
						{
							this.vx = - _loc3_;
							this.dir = com.nitrome.toxic.Global.LEFT;
							if(this.digging == false)
							{
								this.hit_wall = com.nitrome.toxic.Global.LEFT;
							}
							return - _loc3_;
						}
						_loc2_ = _loc2_ + 1;
					}
					_loc3_ = _loc3_ + 1;
				}
				this.vx = v;
				this.dir = com.nitrome.toxic.Global.LEFT;
				return v;
			}
		}
		return 0;
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
				_loc5_ = new Array(-10,-8,-6,-4,-2,0,2,4,6,8);
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
							this.hit_wall = com.nitrome.toxic.Global.RIGHT;
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
				_loc5_ = new Array(-10,-8,-6,-4,-2,0,2,4,6,8);
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
							this.hit_wall = com.nitrome.toxic.Global.LEFT;
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
				_loc5_ = new Array(-8,-6,-4,-2,0,2,4,6,8,10);
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
							this.hit_wall = com.nitrome.toxic.Global.UP;
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
				_loc5_ = new Array(-10,-8,-6,-4,-2,0,2,4,6,8);
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
							this.hit_wall = com.nitrome.toxic.Global.DOWN;
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
	function checkHitWall()
	{
		if(this.game.getSceneryCollision(this._x + this.left_boundary._x,this._y) == true)
		{
			return com.nitrome.toxic.Global.LEFT;
		}
		if(this.game.getSceneryCollision(this._x + this.right_boundary._x,this._y) == true)
		{
			return com.nitrome.toxic.Global.RIGHT;
		}
		if(this.game.getSceneryCollision(this._x,this._y + this.bottom_boundary._y) == true)
		{
			return com.nitrome.toxic.Global.DOWN;
		}
		if(this.game.getSceneryCollision(this._x,this._y + this.top_boundary._y) == true)
		{
			return com.nitrome.toxic.Global.UP;
		}
		if(this.game.getSceneryCollision(this._x + this.left_boundary._x - 2,this._y) == true)
		{
			return com.nitrome.toxic.Global.LEFT;
		}
		if(this.game.getSceneryCollision(this._x + this.right_boundary._x + 2,this._y) == true)
		{
			return com.nitrome.toxic.Global.RIGHT;
		}
		if(this.game.getSceneryCollision(this._x,this._y + this.bottom_boundary._y + 2) == true)
		{
			return com.nitrome.toxic.Global.DOWN;
		}
		if(this.game.getSceneryCollision(this._x,this._y + this.top_boundary._y - 2) == true)
		{
			return com.nitrome.toxic.Global.UP;
		}
		return -1;
	}
}
