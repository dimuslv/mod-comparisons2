class com.nitrome.buttons.BackButton extends com.nitrome.buttons.SimpleButton
{
	var _name;
	function BackButton()
	{
		super();
	}
	function doPress()
	{
		if(this._name == "map_back_button")
		{
			_root.tt.doTween("choose_game");
		}
		else
		{
			_root.tt.doTween("title_screen");
		}
	}
}
