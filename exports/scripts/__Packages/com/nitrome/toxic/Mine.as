class com.nitrome.toxic.Mine extends MovieClip
{
	var anim;
	var game;
	var next_path_point;
	var next_x;
	var next_y;
	var path;
	var path_length;
	var path_move;
	var NONE = 0;
	var LOOP = 1;
	var ALT = 2;
	var alt_dir = 1;
	var x_speed = 0;
	var y_speed = 0;
	var active = false;
	var blow_count = 0;
	var max_blow_count = 100;
	var debris = new Array({id:9,x:-1,y:3},{id:8,x:0,y:-6},{id:7,x:0,y:-4});
	var chid = 1900;
	function Mine()
	{
		super();
	}
	function doPause()
	{
		_root._stop(this.anim);
	}
	function doUnpause()
	{
		_root._play(this.anim);
	}
	function main()
	{
		if(this.getOnScreen() == true)
		{
			this._visible = true;
		}
		else
		{
			this._visible = false;
		}
		if(this.path_move != this.NONE)
		{
			this._x += this.x_speed;
			this._y += this.y_speed;
			if(this.x_speed != 0)
			{
				if(this._x == this.next_x)
				{
					this.getNextPathPoint();
				}
			}
			else if(this.y_speed != 0)
			{
				if(this._y == this.next_y)
				{
					this.getNextPathPoint();
				}
			}
		}
		if(this.active == true)
		{
			this.blow_count = this.blow_count + 1;
			if(this.blow_count >= this.max_blow_count)
			{
				this.doExplode();
			}
		}
	}
	function checkProximity(x, y)
	{
		var _loc2_;
		var _loc3_;
		if(x > this._x)
		{
			_loc2_ = x - this._x;
		}
		else if(this._x > x)
		{
			_loc2_ = this._x - x;
		}
		else
		{
			_loc2_ = 0;
		}
		if(y > this._y)
		{
			_loc3_ = y - this._y;
		}
		else if(this._y > y)
		{
			_loc3_ = this._y - y;
		}
		else
		{
			_loc3_ = 0;
		}
		var _loc6_ = Math.sqrt(_loc2_ * _loc2_ + _loc3_ * _loc3_);
		if(_loc6_ <= 80)
		{
			this.activate();
		}
	}
	function activate()
	{
		this.active = true;
		this.gotoAndStop("active");
	}
	function doExplode()
	{
		this.game.createExplosion(this._x,this._y,this._name,100);
		this.game.createDebris(this._x,this._y,this.debris);
		this.removeMovieClip();
	}
	function getOnScreen()
	{
		if(_root.screen_test.hitTest(_root.game._x + this._x,_root.game._y + this._y,true) == true)
		{
			return true;
		}
		return false;
	}
	function getNextPathPoint()
	{
		if(this.path_move == this.LOOP)
		{
			this.next_path_point = this.next_path_point + 1;
			if(this.next_path_point > this.path_length - 1)
			{
				this.next_path_point = 1;
			}
		}
		else if(this.path_move == this.ALT)
		{
			this.next_path_point += this.alt_dir;
			if(this.alt_dir == 1)
			{
				if(this.next_path_point > this.path_length - 1)
				{
					this.next_path_point -= 2;
					this.alt_dir = -1;
				}
			}
			else if(this.alt_dir == -1)
			{
				if(this.next_path_point == -1)
				{
					this.next_path_point = 1;
					this.alt_dir = 1;
				}
			}
		}
		this.next_x = this.path.getCol(this.next_path_point) * 32 + 16;
		this.next_y = this.path.getRow(this.next_path_point) * 32 + 16;
		if(this.next_x < this._x)
		{
			this.x_speed = -1;
		}
		else if(this.next_x > this._x)
		{
			this.x_speed = 1;
		}
		else if(this.next_x == this._x)
		{
			this.x_speed = 0;
		}
		if(this.next_y < this._y)
		{
			this.y_speed = -1;
		}
		else if(this.next_y > this._y)
		{
			this.y_speed = 1;
		}
		else if(this.next_y == this._y)
		{
			this.y_speed = 0;
		}
	}
	function init(game, id, path)
	{
		this.game = game;
		this.path = path;
		this.path_length = path.getPathLength();
		if(this.path_length == 0)
		{
			this.path_move = this.NONE;
		}
		else
		{
			if(path.getRow(this.path_length - 1) == path.getStartRow() && path.getCol(this.path_length - 1) == path.getStartCol())
			{
				this.path_move = this.LOOP;
			}
			else
			{
				this.path_move = this.ALT;
			}
			this.next_path_point = 1;
			this.next_x = path.getCol(this.next_path_point) * 32 + 16;
			this.next_y = path.getRow(this.next_path_point) * 32 + 16;
			if(this.next_x < this._x)
			{
				this.x_speed = -1;
			}
			else if(this.next_x > this._x)
			{
				this.x_speed = 1;
			}
			else if(this.next_x == this._x)
			{
				this.x_speed = 0;
			}
			if(this.next_y < this._y)
			{
				this.y_speed = -1;
			}
			else if(this.next_y > this._y)
			{
				this.y_speed = 1;
			}
			else if(this.next_y == this._y)
			{
				this.y_speed = 0;
			}
		}
	}
}
