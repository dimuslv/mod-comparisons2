class com.nitrome.toxic.BossBullet extends MovieClip
{
	var bottom_boundary;
	var dir;
	var game;
	var left_boundary;
	var right_boundary;
	var x_speed;
	var y_speed;
	var GRAVITY = 1;
	var INERTIA = 0.96;
	var finished = false;
	var chid = 548;
	function BossBullet()
	{
		super();
	}
	function init(game, dir)
	{
		this.game = game;
		this.dir = dir;
		if(dir == 1)
		{
			this.x_speed = -8;
			this.y_speed = 5;
		}
		else if(dir == 2)
		{
			this.x_speed = 0;
			this.y_speed = 5;
		}
		else if(dir == 3)
		{
			this.x_speed = 8;
			this.y_speed = 5;
		}
	}
	function main()
	{
		this._visible = this.getOnScreen();
		if(this.finished == false)
		{
			this._x += this.x_speed;
			this._y += this.y_speed;
			if(this.y_speed == 0)
			{
				this.checkCollisionSide();
			}
			else
			{
				this.checkCollisionDown();
				if(this.y_speed != 0)
				{
					this.x_speed *= this.INERTIA;
					this.y_speed += this.GRAVITY;
				}
			}
		}
	}
	function checkCollisionDown()
	{
		var _loc2_ = this.bottom_boundary._y;
		if(this.game.getSceneryCollision(this._x,this._y + _loc2_) == true)
		{
			if(this.dir == 2)
			{
				this.gotoAndStop("finished");
				this.finished = true;
			}
			else
			{
				this.y_speed = 0;
				if(this.dir == 1)
				{
					this.x_speed = -5;
				}
				else if(this.dir == 3)
				{
					this.x_speed = 5;
				}
			}
		}
	}
	function checkCollisionSide()
	{
		var _loc2_;
		if(this.dir == 1)
		{
			_loc2_ = this.left_boundary._x;
		}
		else if(this.dir == 3)
		{
			_loc2_ = this.right_boundary._x;
		}
		if(this.game.getSceneryCollision(this._x + _loc2_,this._y) == true)
		{
			this.gotoAndStop("finished");
			this.finished = true;
		}
		else if(this.dir == 1 && this._x < -20)
		{
			this.gotoAndStop("finished");
			this.finished = true;
		}
		else if(this.dir == 3 && this._x > com.nitrome.toxic.Global.level_width + 20)
		{
			this.gotoAndStop("finished");
			this.finished = true;
		}
	}
	function getOnScreen()
	{
		if(this.hitTest(_root.screen_test) == true)
		{
			return true;
		}
		return false;
	}
	function finishFire()
	{
		this.game.removeBullet(this._name);
		this.removeMovieClip();
	}
}
