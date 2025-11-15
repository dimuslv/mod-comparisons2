class com.nitrome.buttons.PauseButton extends com.nitrome.buttons.SimpleButton
{
	function PauseButton()
	{
		super();
	}
	function doPress()
	{
		if(!_root.aMode)
		{
			_root.popup_holder.displayPopUp("game_paused");
			_root.game.pauseGame();
		}
		else
		{
			TAS.justPause = true;
			TAS.pressedPause = true;
		}
	}
}
