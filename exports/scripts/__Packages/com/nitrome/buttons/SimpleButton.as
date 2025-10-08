class com.nitrome.buttons.SimpleButton extends MovieClip
{
	function SimpleButton()
	{
		super();
	}
	function onRollOver()
	{
		this.gotoAndStop("over");
	}
	function onRollOut()
	{
		this.gotoAndStop("up");
	}
	function onPress()
	{
		this.doPress();
	}
	function doPress()
	{
	}
}
