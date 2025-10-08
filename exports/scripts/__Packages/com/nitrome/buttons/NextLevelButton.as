class com.nitrome.buttons.NextLevelButton extends com.nitrome.buttons.SimpleButton
{
	var onKeyDown;
	var done = false;
	function NextLevelButton()
	{
		super();
		this.clearKeyListener();
		this.onKeyDown = function()
		{
			if(Key.getCode() == 32)
			{
				this.doPress();
			}
		};
		Key.addListener(this);
	}
	function doPress()
	{
		if(this.done == false)
		{
			com.nitrome.toxic.Global.level_id = com.nitrome.toxic.Global.level_id + 1;
			com.nitrome.toxic.Global.secret_id = 0;
			_root.tt.doTween("reload");
			Key.removeListener(this);
			this.done = true;
		}
	}
	function clearKeyListener()
	{
		Key.removeListener(this);
	}
}
