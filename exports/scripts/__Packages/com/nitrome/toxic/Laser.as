class com.nitrome.toxic.Laser extends MovieClip
{
	var deg;
	var drawing_clip;
	var game;
	var laser_head;
	var next_path_point;
	var next_x;
	var next_y;
	var path;
	var path_length;
	var path_move;
	var rot;
	var spark_clip;
	var start_deg;
	var NONE = 0;
	var LOOP = 1;
	var ALT = 2;
	var alt_dir = 1;
	var x_speed = 0;
	var y_speed = 0;
	var chid = 1628;
	function Laser()
	{
		super();
	}
	function doPause()
	{
		_root._stop(this.spark_clip);
	}
	function doUnpause()
	{
		_root._play(this.spark_clip);
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
		if(this.rot == 0)
		{
			this.deg = this.start_deg;
		}
		else if(this.rot == 1)
		{
			this.deg = this.game.deg_count + this.start_deg;
		}
		else if(this.rot == -1)
		{
			this.deg = 360 - (this.game.deg_count + this.start_deg);
		}
		var _loc6_ = this.deg - 90;
		if(_loc6_ < 0)
		{
			_loc6_ += 360;
		}
		if(_loc6_ >= 360)
		{
			_loc6_ -= 360;
		}
		var _loc2_;
		var _loc8_;
		var _loc7_;
		var _loc4_;
		var _loc3_;
		var _loc5_;
		if(Utils.laserState)
		{
			_loc2_ = 1;
			while(_loc2_ <= 600)
			{
				_loc8_ = _loc2_ * com.nitrome.toxic.TrigLookup.cos_data[_loc6_];
				_loc7_ = _loc2_ * com.nitrome.toxic.TrigLookup.sin_data[_loc6_];
				_loc4_ = Math.round(this._x + _loc8_);
				_loc3_ = Math.round(this._y + _loc7_);
				if(_loc4_ < 0 || _loc4_ > com.nitrome.toxic.Global.level_width || _loc3_ < 0 || _loc3_ > com.nitrome.toxic.Global.level_height)
				{
					break;
				}
				if(this.game.getSceneryCollision(_loc4_,_loc3_) == true || Utils.laserState === 1 && (this.game.getRobotCollision(_loc4_,_loc3_) == true || this.game.getBombCollision(_loc4_,_loc3_) == true))
				{
					break;
				}
				_loc2_ += 20;
			}
			_loc5_ = _loc2_ - 10;
			while(_loc5_ <= _loc2_ + 10)
			{
				_loc8_ = _loc5_ * com.nitrome.toxic.TrigLookup.cos_data[_loc6_];
				_loc7_ = _loc5_ * com.nitrome.toxic.TrigLookup.sin_data[_loc6_];
				_loc4_ = Math.round(this._x + _loc8_);
				_loc3_ = Math.round(this._y + _loc7_);
				if(_loc4_ < 0 || _loc4_ > com.nitrome.toxic.Global.level_width || _loc3_ < 0 || _loc3_ > com.nitrome.toxic.Global.level_height)
				{
					break;
				}
				if(this.game.getSceneryCollision(_loc4_,_loc3_) == true || Utils.laserState === 1 && (this.game.getRobotCollision(_loc4_,_loc3_) == true || this.game.getBombCollision(_loc4_,_loc3_) == true))
				{
					break;
				}
				_loc5_ = _loc5_ + 1;
			}
			this.drawLine(_loc8_,_loc7_);
			this.spark_clip._x = _loc8_;
			this.spark_clip._y = _loc7_;
		}
		else
		{
			this.drawing_clip.clear();
			this.spark_clip._x = 0;
			this.spark_clip._y = 0;
		}
		this.laser_head._rotation = this.deg;
	}
	function getOnScreen()
	{
		if(_root.screen_test.hitTest(_root.game._x + this._x,_root.game._y + this._y,true) == true || _root.screen_test.hitTest(_root.game._x + this._x + this.spark_clip._x,_root.game._y + this._y + this.spark_clip._y,true) == true)
		{
			return true;
		}
		return false;
	}
	function drawLine(xpos, ypos)
	{
		this.drawing_clip.clear();
		this.drawing_clip.lineStyle(5,3955744,100,true);
		this.drawing_clip.moveTo(0,0);
		this.drawing_clip.lineTo(xpos,ypos);
		this.drawing_clip.lineStyle(3,6595873,100,true);
		this.drawing_clip.moveTo(0,0);
		this.drawing_clip.lineTo(xpos,ypos);
		this.drawing_clip.lineStyle(1,8641826,100,true);
		this.drawing_clip.moveTo(0,0);
		this.drawing_clip.lineTo(xpos,ypos);
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
		if(id == 211)
		{
			this.rot = 1;
			this.start_deg = 180;
		}
		else if(id == 212)
		{
			this.rot = 1;
			this.start_deg = 270;
		}
		else if(id == 213)
		{
			this.rot = 1;
			this.start_deg = 0;
		}
		else if(id == 214)
		{
			this.rot = 1;
			this.start_deg = 90;
		}
		else if(id == 215)
		{
			this.rot = -1;
			this.start_deg = 180;
		}
		else if(id == 216)
		{
			this.rot = -1;
			this.start_deg = 270;
		}
		else if(id == 217)
		{
			this.rot = -1;
			this.start_deg = 0;
		}
		else if(id == 218)
		{
			this.rot = -1;
			this.start_deg = 90;
		}
		else if(id == 219)
		{
			this.rot = 0;
			this.start_deg = 180;
		}
		else if(id == 220)
		{
			this.rot = 0;
			this.start_deg = 270;
		}
		else if(id == 221)
		{
			this.rot = 0;
			this.start_deg = 0;
		}
		else if(id == 222)
		{
			this.rot = 0;
			this.start_deg = 90;
		}
		this.deg = this.start_deg;
	}
}
