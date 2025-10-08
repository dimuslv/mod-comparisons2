class com.nitrome.buttons.BackToMapButton extends com.nitrome.buttons.SimpleButton
{
	var _parent;
	function BackToMapButton()
	{
		super();
	}
	function doPress()
	{
		this._parent.key_button.clearKeyListener();
		_root.mc.startMenuMusic(false);
		if(!_root.game.level_number)
		{
			_root.tt.doTween("title_screen");
		}
		else
		{
			_root.tt.doTween("map");
		}
	}
}
