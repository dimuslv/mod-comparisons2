class com.nitrome.buttons.CreditsButton extends com.nitrome.buttons.SimpleButton
{
	function CreditsButton()
	{
		super();
	}
	function doPress()
	{
		_root.tt.doTween("credits");
	}
}
