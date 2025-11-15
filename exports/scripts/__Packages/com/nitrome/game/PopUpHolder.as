class com.nitrome.game.PopUpHolder extends MovieClip
{
	var clip;
	var id;
	var chid = 2141;
	function PopUpHolder()
	{
		super();
	}
	function displayPopUp(id)
	{
		this.id = id;
		if(false)
		{
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
		else
		{
			_root._gotoAndPlay(this,"in",2141);
		}
	}
	function hidePopUp()
	{
		if(false)
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
		else
		{
			_root._gotoAndPlay(this,"out",2141);
		}
	}
}
