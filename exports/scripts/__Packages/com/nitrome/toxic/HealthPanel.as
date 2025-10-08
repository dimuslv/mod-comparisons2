class com.nitrome.toxic.HealthPanel extends MovieClip
{
	var health_mask;
	var health_percent = 100;
	var health_dec = 25;
	function HealthPanel()
	{
		super();
	}
	function loseHealth()
	{
		this.health_percent -= this.health_dec;
		if(this.health_percent <= 0)
		{
			_root.game.gameOver();
		}
		this.doDisplay();
	}
	function boostHealth()
	{
		this.health_percent += this.health_dec;
		if(this.health_percent > 100)
		{
			this.health_percent = 100;
		}
		this.doDisplay();
	}
	function loseAllHealth()
	{
		this.health_percent = 0;
		this.doDisplay();
	}
	function doDisplay()
	{
		this.health_mask._xscale = this.health_percent;
	}
}
