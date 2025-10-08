class com.nitrome.toxic.BossDebris extends MovieClip
{
	var rot_dir;
	var active = false;
	var rot = 0;
	var y_speed = 1;
	var max_y_speed = 20;
	function BossDebris()
	{
		super();
		this._visible = false;
	}
	function startDrop()
	{
		this._y = 0;
		this.y_speed = 1;
		this.rot = _root._random(360);
		this.rot_dir = _root._random(2);
		if(this.rot_dir == 0)
		{
			this.rot_dir = -1;
		}
		this.gotoAndStop(_root._random(5) + 1);
		this.active = true;
		this._visible = true;
	}
	function main()
	{
		if(this.active)
		{
			this._y += this.y_speed;
			this.y_speed = this.y_speed + 1;
			if(this.y_speed > this.max_y_speed)
			{
				this.y_speed = this.max_y_speed;
			}
			this.rot += this.rot_dir;
			if(this.rot < 0)
			{
				this.rot += 360;
			}
			if(this.rot >= 360)
			{
				this.rot -= 360;
			}
			this._rotation = this.rot;
			if(this._y > com.nitrome.toxic.Global.level_height)
			{
				this._visible = false;
				this.active = false;
			}
		}
	}
}
