class com.nitrome.buttons.ScoresButton extends com.nitrome.buttons.SimpleButton
{
	function ScoresButton()
	{
		super();
	}
	function doPress()
	{
		_root.tt.doTween("scores");
	}
}
