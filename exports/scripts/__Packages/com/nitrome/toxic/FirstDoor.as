class com.nitrome.toxic.FirstDoor extends MovieClip
{
	var game;
	var chid = 1471;
	function FirstDoor()
	{
		super();
	}
	function Door()
	{
	}
	function init(game)
	{
		this.game = game;
		game.drawDoor(this._x,this._y);
	}
	function doClose()
	{
		this.gotoAndStop("close");
	}
	function doOpen()
	{
		this.game.clearDoor(this._x,this._y);
		this.gotoAndStop("open");
	}
	function finishOpen()
	{
		this.game.openDoor(3);
	}
}
