class com.nitrome.game.PopUpHolder extends MovieClip
{
	var clip;
	var id;
	function PopUpHolder()
	{
		super();
	}
	function displayPopUp(id)
	{
		this.id = id;
		if(!TAS.fastPlayback)
		{
			this.gotoAndPlay("in");
		}
		else
		{
			this.gotoAndStop(2);
			this.clip.gotoAndStop(id);
			this.gotoAndStop(23);
		}
	}
	function hidePopUp()
	{
		if(!TAS.fastPlayback)
		{
			this.gotoAndPlay("out");
		}
		else
		{
			this.gotoAndStop(1);
		}
	}
}
