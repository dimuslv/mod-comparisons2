class com.nitrome.buttons.SubmitScoreButton extends com.nitrome.buttons.SimpleButton
{
	var _visible;
	function SubmitScoreButton()
	{
		super();
		if(_root.ng.getLastSavedScore() >= com.nitrome.engine.Score.value)
		{
			this._visible = false;
		}
	}
	function doPress()
	{
		_root.ng.setLastSavedScore(com.nitrome.engine.Score.value);
		_root.mc.startMenuMusic(false);
		_root.popup_holder.hidePopUp();
		_root.tt.doTween("submit_score");
	}
}
