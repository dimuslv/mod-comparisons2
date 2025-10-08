class com.nitrome.toxic.Medipak extends MovieClip
{
	var game;
	var collected = false;
	var chid = 1885;
	function Medipak()
	{
		super();
	}
	function init(game)
	{
		this.game = game;
	}
	function doCollect()
	{
		if(this.collected == false)
		{
			this.gotoAndStop("collect");
			_root.health_panel.boostHealth();
			this.collected = true;
		}
	}
	function finishCollect()
	{
		this.game.removeObject(this._name);
		this.removeMovieClip();
	}
}
