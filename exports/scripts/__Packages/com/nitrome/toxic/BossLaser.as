class com.nitrome.toxic.BossLaser extends MovieClip
{
	var deg;
	var drawing_clip;
	var game;
	var rot;
	var spark_clip;
	var active = false;
	var laser_count = 0;
	var max_laser_count = 270;
	var chid = 582;
	function BossLaser()
	{
		super();
	}
	function init(game)
	{
		this.game = game;
	}
	function setActive(b, deg, rot)
	{
		this.deg = deg;
		this.rot = rot;
		this.laser_count = 0;
		this.active = b;
	}
	function main()
	{
		this._visible = this.active;
		var _loc7_;
		var _loc3_;
		var _loc9_;
		var _loc8_;
		var _loc5_;
		var _loc4_;
		var _loc6_;
		if(this.active == true)
		{
			this.deg += this.rot;
			_loc7_ = this.deg - 90;
			if(_loc7_ < 0)
			{
				_loc7_ += 360;
			}
			if(_loc7_ >= 360)
			{
				_loc7_ -= 360;
			}
			_loc3_ = 140;
			while(_loc3_ <= 600)
			{
				_loc9_ = _loc3_ * com.nitrome.toxic.TrigLookup.cos_data[_loc7_];
				_loc8_ = _loc3_ * com.nitrome.toxic.TrigLookup.sin_data[_loc7_];
				_loc5_ = Math.round(this._x + _loc9_);
				_loc4_ = Math.round(this._y + _loc8_);
				if(_loc5_ < 0 || _loc5_ > com.nitrome.toxic.Global.level_width || _loc4_ < 0 || _loc4_ > com.nitrome.toxic.Global.level_height)
				{
					break;
				}
				if(this.game.getLaserSceneryCollision(_loc5_,_loc4_) == true || this.game.getRobotCollision(_loc5_,_loc4_) == true || this.game.getBombCollision(_loc5_,_loc4_) == true)
				{
					break;
				}
				_loc3_ += 20;
			}
			_loc6_ = _loc3_ - 10;
			while(_loc6_ <= _loc3_ + 10)
			{
				_loc9_ = _loc6_ * com.nitrome.toxic.TrigLookup.cos_data[_loc7_];
				_loc8_ = _loc6_ * com.nitrome.toxic.TrigLookup.sin_data[_loc7_];
				_loc5_ = Math.round(this._x + _loc9_);
				_loc4_ = Math.round(this._y + _loc8_);
				if(_loc5_ < 0 || _loc5_ > com.nitrome.toxic.Global.level_width || _loc4_ < 0 || _loc4_ > com.nitrome.toxic.Global.level_height)
				{
					break;
				}
				if(this.game.getLaserSceneryCollision(_loc5_,_loc4_) == true || this.game.getRobotCollision(_loc5_,_loc4_) == true || this.game.getBombCollision(_loc5_,_loc4_) == true)
				{
					break;
				}
				_loc6_ = _loc6_ + 1;
			}
			this.drawLine(_loc9_,_loc8_);
			this.spark_clip._x = _loc9_;
			this.spark_clip._y = _loc8_;
			this.laser_count = this.laser_count + 1;
			if(this.laser_count >= this.max_laser_count)
			{
				_root.game.safe_holder.boss2.startFinishLaser();
				this.active = false;
			}
		}
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
}
