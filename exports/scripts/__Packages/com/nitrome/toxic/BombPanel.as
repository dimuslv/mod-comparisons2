class com.nitrome.toxic.BombPanel extends MovieClip
{
	var bomb_count_text;
	var bomb_type = 1;
	var bomb_types = new Array("","basic","platform","digger","runner");
	var bomb_count = 5;
	function BombPanel()
	{
		super();
	}
	function collectBomb(type)
	{
		this.bomb_type = type;
		this.bomb_count = 5;
		this.bomb_count_text.text = String(this.bomb_count);
		this.gotoAndStop(this.bomb_types[this.bomb_type]);
	}
	function useBomb()
	{
		if(this.bomb_type != 1)
		{
			this.bomb_count = this.bomb_count - 1;
		}
		if(this.bomb_count == 0)
		{
			this.bomb_type = 1;
			this.gotoAndStop(this.bomb_types[this.bomb_type]);
			_root.game.setBombType(1);
			this.bomb_count = 5;
		}
		this.bomb_count_text.text = String(this.bomb_count);
	}
}
