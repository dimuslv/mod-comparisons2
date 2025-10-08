class com.nitrome.toxic.Bullet extends MovieClip
{
	var dir;
	var game;
	var left_boundary;
	var right_boundary;
	var speed = 5;
	var finished = false;
	var chid = 857;
	function Bullet()
	{
		super();
	}
	function init(game, dir)
	{
		this.game = game;
		this.dir = dir;
	}
	function main()
	{
		this._visible = this.getOnScreen();
		if(this.finished == false)
		{
			if(this.dir == com.nitrome.toxic.Global.LEFT)
			{
				this._x -= this.speed;
			}
			else if(this.dir == com.nitrome.toxic.Global.RIGHT)
			{
				this._x += this.speed;
			}
			this.checkCollision();
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
	function checkCollision()
	{
		var _loc2_;
		if(this.dir == com.nitrome.toxic.Global.LEFT)
		{
			_loc2_ = this.left_boundary._x;
		}
		else if(this.dir == com.nitrome.toxic.Global.RIGHT)
		{
			_loc2_ = this.right_boundary._x;
		}
		if(this.game.getSceneryCollision(this._x + _loc2_,this._y) == true)
		{
			this.gotoAndStop("finished");
			this.finished = true;
		}
		else if(this.dir == com.nitrome.toxic.Global.LEFT && this._x < -20)
		{
			this.gotoAndStop("finished");
			this.finished = true;
		}
		else if(this.dir == com.nitrome.toxic.Global.RIGHT && this._x > com.nitrome.toxic.Global.level_width + 20)
		{
			this.gotoAndStop("finished");
			this.finished = true;
		}
	}
	function finishFire()
	{
		this.game.removeBullet(this._name);
		this.removeMovieClip();
	}
}
