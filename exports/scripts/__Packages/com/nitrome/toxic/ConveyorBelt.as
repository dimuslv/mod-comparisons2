class com.nitrome.toxic.ConveyorBelt extends MovieClip
{
	var anim;
	var dir;
	var game;
	var speed = new Array(-3,3);
	var chid = 959;
	function ConveyorBelt()
	{
		super();
	}
	function init(game, dir)
	{
		this.game = game;
		this.dir = dir;
	}
	function doPause()
	{
		_root._stop(this.anim);
	}
	function doUnpause()
	{
		_root._play(this.anim);
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
		if(this.getOnScreen() == true)
		{
			this._visible = true;
		}
		else
		{
			this._visible = false;
		}
	}
	function getSpeed()
	{
		return this.speed[this.dir];
	}
}
