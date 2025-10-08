class com.nitrome.buttons.SkipIntroButton extends com.nitrome.buttons.SimpleButton
{
	function SkipIntroButton()
	{
		super();
	}
	function doPress()
	{
		_root.tt.doTween("game");
	}
}
