class com.nitrome.buttons.HelpButton extends com.nitrome.buttons.SimpleButton
{
	function HelpButton()
	{
		super();
	}
	function doPress()
	{
		_root.tt.doTween("help");
	}
}
