class com.nitrome.buttons.ClearPowercellsButton extends com.nitrome.buttons.SimpleButton
{
	var _parent;
	function ClearPowercellsButton()
	{
		super();
	}
	function doPress()
	{
		var _loc2_ = new com.nitrome.toxic.PowerCellMemory();
		_loc2_.clearAll();
		this._parent.pc_text.textColor = 16777215;
		this._parent.pc_text.text = "POWER CELLS CLEARED!";
	}
}
