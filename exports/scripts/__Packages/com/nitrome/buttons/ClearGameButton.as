class com.nitrome.buttons.ClearGameButton extends com.nitrome.buttons.SimpleButton
{
	var _parent;
	function ClearGameButton()
	{
		super();
	}
	function doPress()
	{
		_root.ng.clearLevels();
		this._parent.clear_text.textColor = 16777215;
		this._parent.clear_text.text = "SAVED GAME CLEARED!";
	}
}
