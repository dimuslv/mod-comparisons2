class com.nitrome.toxic.BossHealthPanel extends MovieClip
{
	var health_mask;
	function BossHealthPanel()
	{
		super();
		this._visible = false;
	}
	function setActive(b)
	{
		this._visible = b;
	}
	function displayHealth(percent)
	{
		this.health_mask._xscale = percent;
	}
}
