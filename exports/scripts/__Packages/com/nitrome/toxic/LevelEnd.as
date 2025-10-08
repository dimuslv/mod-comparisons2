class com.nitrome.toxic.LevelEnd extends MovieClip
{
	var game;
	var collected = false;
	var chid = 1880;
	function LevelEnd()
	{
		super();
	}
	function init(game)
	{
		this.game = game;
	}
	function doCollect()
	{
		if(this.collected == false && this.game.getPlayerOnGround() == true)
		{
			if(Utils.deactivateTeleport)
			{
				return undefined;
			}
			this.game.transportPlayer(false);
			this.gotoAndStop("collect");
			this.collected = true;
		}
	}
	function finishCollect()
	{
		this.game.removeObject(this._name);
		this.removeMovieClip();
	}
}
