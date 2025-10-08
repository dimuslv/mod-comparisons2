class com.nitrome.toxic.BomberRobot extends MovieClip
{
	var aim_next;
	var anim;
	var bomb_1;
	var bomb_2;
	var bomb_3;
	var dir;
	var edge_boundary_left;
	var edge_boundary_right;
	var fall_anim_count;
	var fire_angle;
	var game;
	var player;
	var prev_dir;
	var prev_state;
	var state;
	var wall_boundary_left;
	var wall_boundary_right;
	var vx = 0;
	var vy = 0;
	var max_vx = 1;
	var max_vy = 6;
	var fall_vy = 0;
	var max_slope = 16;
	var debris_right = new Array({id:65,x:7,y:-28},{id:66,x:21,y:-63},{id:67,x:21,y:-38},{id:68,x:42,y:-51},{id:69,x:11,y:-52},{id:70,x:6,y:-51},{id:71,x:-6,y:-28});
	var debris_left = new Array({id:72,x:6,y:-28},{id:73,x:-20,y:-64},{id:74,x:-21,y:-37},{id:75,x:-43,y:-51},{id:76,x:-13,y:-51},{id:77,x:-6,y:-51},{id:78,x:-6,y:-28});
	var fire_count = 0;
	var max_fire_count = 30;
	var done_splash = false;
	var chid = 542;
	function BomberRobot()
	{
		super();
	}
	function doPause()
	{
		_root._stop(this.anim);
		_root._stop(this.anim.head);
	}
	function doUnpause()
	{
		_root._play(this.anim);
		_root._play(this.anim.head);
	}
	function init(dir, game)
	{
		this.dir = dir;
		this.game = game;
		this.state = com.nitrome.toxic.Global.WALK;
		this.updateAnim();
		if(dir == com.nitrome.toxic.Global.LEFT)
		{
			this.vx = - this.max_vx;
		}
		else if(dir == com.nitrome.toxic.Global.RIGHT)
		{
			this.vx = this.max_vx;
		}
		this.vy = 0;
		this.adjustToFloor();
	}
	function getOnScreen()
	{
		if(this.hitTest(_root.screen_test) == true)
		{
			return true;
		}
		return false;
	}
	function main()
	{
		this._visible = this.getOnScreen();
		this.updateAnim();
		if(this.state == com.nitrome.toxic.Global.WALK)
		{
			this.doWalk();
		}
		else if(this.state == com.nitrome.toxic.Global.FALL)
		{
			this.doFall();
			this.checkFallOff();
		}
		else if(this.state != com.nitrome.toxic.Global.TURN)
		{
			if(this.state != com.nitrome.toxic.Global.AIM)
			{
				if(this.state == com.nitrome.toxic.Global.FIRE)
				{
				}
			}
		}
	}
	function doExplode()
	{
		this.game.createExplosion(this._x,this._y,this._name,100);
		if(this.dir == com.nitrome.toxic.Global.LEFT)
		{
			this.game.createDebris(this._x,this._y,this.debris_left);
		}
		else if(this.dir == com.nitrome.toxic.Global.RIGHT)
		{
			this.game.createDebris(this._x,this._y,this.debris_right);
		}
		this.removeMovieClip();
	}
	function doWalk()
	{
		if(this.getOnGround(this._x,this._y) == false)
		{
			this.fall_anim_count = 0;
			this.vy = this.fall_vy;
			this.state = com.nitrome.toxic.Global.FALL;
			return undefined;
		}
		this._x += this.checkWalls(this.vx);
		this.adjustToFloor();
		this.fire_count = this.fire_count + 1;
		if(this.fire_count > this.max_fire_count)
		{
			this.checkForPlayer();
		}
	}
	function checkForPlayer()
	{
		if(this.player == undefined)
		{
			this.player = _root.game.player_holder.player;
		}
		var _loc6_ = this._x - 250;
		var _loc4_ = this._x + 250;
		var _loc5_ = this._y - 200;
		var _loc3_ = this._y + 100;
		if(this.player._x > _loc6_ && this.player._x < _loc4_)
		{
			if(this.player._y > _loc5_ && this.player._y < _loc3_)
			{
				if(this.dir == com.nitrome.toxic.Global.LEFT && this.player._x > this._x)
				{
					this.startTurn(true);
				}
				else if(this.dir == com.nitrome.toxic.Global.RIGHT && this.player._x < this._x)
				{
					this.startTurn(true);
				}
				else
				{
					this.startAim();
				}
			}
		}
	}
	function startAim()
	{
		this.state = com.nitrome.toxic.Global.AIM;
		var _loc2_;
		if(this.player._x > this._x)
		{
			_loc2_ = this.player._x - this._x;
		}
		else if(this.player._x < this._x)
		{
			_loc2_ = this._x - this.player._x;
		}
		if(_loc2_ > 200)
		{
			this.fire_angle = 1;
		}
		else if(_loc2_ > 100)
		{
			this.fire_angle = 2;
		}
		else
		{
			this.fire_angle = 3;
		}
	}
	function startFire()
	{
		this.state = com.nitrome.toxic.Global.FIRE;
		this.updateAnim();
	}
	function doFire()
	{
		if(this.dir == com.nitrome.toxic.Global.RIGHT)
		{
			if(this.fire_angle == 1)
			{
				this.game.fireBomb(this._x + this.bomb_1._x,this._y + this.bomb_1._y,10,-5);
			}
			else if(this.fire_angle == 2)
			{
				this.game.fireBomb(this._x + this.bomb_2._x,this._y + this.bomb_2._y,8,-7);
			}
			else if(this.fire_angle == 3)
			{
				this.game.fireBomb(this._x + this.bomb_3._x,this._y + this.bomb_3._y,6,-9);
			}
		}
		else if(this.dir == com.nitrome.toxic.Global.LEFT)
		{
			if(this.fire_angle == 1)
			{
				this.game.fireBomb(this._x + this.bomb_1._x,this._y + this.bomb_1._y,-10,-5);
			}
			else if(this.fire_angle == 2)
			{
				this.game.fireBomb(this._x + this.bomb_2._x,this._y + this.bomb_2._y,-8,-7);
			}
			else if(this.fire_angle == 3)
			{
				this.game.fireBomb(this._x + this.bomb_3._x,this._y + this.bomb_3._y,-6,-9);
			}
		}
	}
	function resetAim()
	{
		this.state = com.nitrome.toxic.Global.RESET;
		this.updateAnim();
	}
	function finishReset()
	{
		this.fire_count = 0;
		this.startTurn(false);
	}
	function doFall()
	{
		this.vy = this.vy + 1;
		if(this.vy > this.max_vy)
		{
			this.vy = this.max_vy;
		}
		this._y += this.checkFloor(this.vy);
		if(this.getOnGround(this._x,this._y) == true)
		{
			this.state = com.nitrome.toxic.Global.WALK;
		}
	}
	function adjustToFloor()
	{
		var _loc3_;
		var _loc2_;
		if(this.getInGround(this._x,this._y) == true)
		{
			if(this.vy >= 0)
			{
				_loc3_ = false;
				_loc2_ = 1;
				while(_loc2_ <= this.max_slope)
				{
					if(this.getOnGround(this._x,this._y - _loc2_) == true)
					{
						this._y -= _loc2_;
						_loc3_ = true;
						break;
					}
					_loc2_ = _loc2_ + 1;
				}
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
	function getInWall(x, y)
	{
		if(this.game.getSceneryCollision(x,y) == true)
		{
			return true;
		}
		return false;
	}
	function getOverEdge(x, y)
	{
		var _loc2_ = 1;
		while(_loc2_ <= 32)
		{
			if(this.game.getSceneryCollision(x,y + _loc2_) == true)
			{
				return false;
			}
			_loc2_ = _loc2_ + 1;
		}
		return true;
	}
	function updateAnim()
	{
		if(this.state == com.nitrome.toxic.Global.FALL)
		{
			if(this.dir != this.prev_dir || this.state != this.prev_state)
			{
				this.fall_anim_count = this.fall_anim_count + 1;
				if(this.fall_anim_count >= 3)
				{
					_root._gotoAndStop(this,com.nitrome.toxic.Global.state_string[this.state] + com.nitrome.toxic.Global.dir_string[this.dir],542);
					this.prev_dir = this.dir;
					this.prev_state = this.state;
				}
			}
		}
		else
		{
			if(this.dir != this.prev_dir || this.state != this.prev_state)
			{
				_root._gotoAndStop(this,com.nitrome.toxic.Global.state_string[this.state] + com.nitrome.toxic.Global.dir_string[this.dir],542);
			}
			this.prev_dir = this.dir;
			this.prev_state = this.state;
		}
	}
	function checkWalls(v)
	{
		var _loc3_ = new Array(-10,-15);
		var _loc7_;
		var _loc8_;
		var _loc5_;
		var _loc6_;
		var _loc4_;
		if(v > 0)
		{
			_loc7_ = this.wall_boundary_right._x;
			_loc8_ = this.edge_boundary_right._x;
			if(this.getInWall(this._x + _loc7_ + v,this._y + _loc3_[0]) == true || this.getInWall(this._x + _loc7_ + v,this._y + _loc3_[1]) == true)
			{
				_loc5_ = 1;
				while(_loc5_ <= this.max_vx)
				{
					_loc6_ = 0;
					_loc4_ = 0;
					while(_loc4_ < _loc3_.length)
					{
						if(this.getInWall(this._x + _loc7_ + v - _loc5_,this._y + _loc3_[_loc4_]) == false)
						{
							_loc6_ = _loc6_ + 1;
						}
						_loc4_ = _loc4_ + 1;
					}
					if(_loc6_ == _loc3_.length)
					{
						this.startTurn(false);
						return v - _loc5_;
					}
					_loc5_ = _loc5_ + 1;
				}
			}
			else
			{
				if(this.getOverEdge(this._x + _loc8_ + v,this._y) != true)
				{
					return v;
				}
				_loc5_ = 1;
				while(_loc5_ <= this.max_vx)
				{
					if(this.getOverEdge(this._x + _loc8_ + v - _loc5_,this._y) == false)
					{
						this.startTurn(false);
						return v - _loc5_;
					}
					_loc5_ = _loc5_ + 1;
				}
			}
		}
		else
		{
			if(v >= 0)
			{
				this.vx = 0;
				return 0;
			}
			_loc7_ = this.wall_boundary_left._x;
			_loc8_ = this.edge_boundary_left._x;
			if(this.getInWall(this._x + _loc7_ + v,this._y + _loc3_[0]) == true || this.getInWall(this._x + _loc7_ + v,this._y + _loc3_[1]) == true)
			{
				_loc5_ = 1;
				while(_loc5_ <= this.max_vx)
				{
					_loc6_ = 0;
					_loc4_ = 0;
					while(_loc4_ < _loc3_.length)
					{
						if(this.getInWall(this._x + _loc7_ + v + _loc5_,this._y + _loc3_[_loc4_]) == false)
						{
							_loc6_ = _loc6_ + 1;
						}
						_loc4_ = _loc4_ + 1;
					}
					if(_loc6_ == _loc3_.length)
					{
						this.startTurn(false);
						return v + _loc5_;
					}
					_loc5_ = _loc5_ + 1;
				}
			}
			else
			{
				if(this.getOverEdge(this._x + _loc8_ + v,this._y) != true)
				{
					return v;
				}
				_loc5_ = 1;
				while(_loc5_ <= this.max_vx)
				{
					if(this.getOverEdge(this._x + _loc8_ + v + _loc5_,this._y) == false)
					{
						this.startTurn(false);
						return v + _loc5_;
					}
					_loc5_ = _loc5_ + 1;
				}
			}
		}
	}
	function startTurn(aim)
	{
		this.aim_next = aim;
		this.state = com.nitrome.toxic.Global.TURN;
	}
	function finishTurn()
	{
		this.changeDirection();
		if(this.aim_next == true)
		{
			this.startAim();
		}
		else
		{
			this.state = com.nitrome.toxic.Global.WALK;
		}
	}
	function checkFloor(v)
	{
		v = Math.round(v);
		var _loc2_ = 1;
		while(_loc2_ <= v)
		{
			if(this.getInWall(this._x,this._y + _loc2_) == true)
			{
				return _loc2_;
			}
			_loc2_ = _loc2_ + 1;
		}
		return v;
	}
	function changeDirection()
	{
		if(this.dir == com.nitrome.toxic.Global.LEFT)
		{
			this.dir = com.nitrome.toxic.Global.RIGHT;
			if(this.vx < 0)
			{
				this.vx = Math.abs(this.vx);
			}
		}
		else if(this.dir == com.nitrome.toxic.Global.RIGHT)
		{
			this.dir = com.nitrome.toxic.Global.LEFT;
			if(this.vx > 0)
			{
				this.vx = - this.vx;
			}
		}
	}
	function checkFallOff()
	{
		if(this._y > com.nitrome.toxic.Global.level_height - 64 && this.done_splash == false)
		{
			this.game.doSplash(this._x,this._y + 15);
			this.done_splash = true;
		}
		else if(this._y > com.nitrome.toxic.Global.level_height - 60)
		{
			this.game.removeRobot(this._name);
			this.removeMovieClip();
		}
	}
}
