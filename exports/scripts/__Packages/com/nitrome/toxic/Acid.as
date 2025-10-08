class com.nitrome.toxic.Acid extends MovieClip
{
	var acid_clip;
	var smoke_bubble_holder;
	var wall_overlay;
	function Acid()
	{
		super();
	}
	function init()
	{
		this.acid_clip._x = 0;
		this.acid_clip._y = com.nitrome.toxic.Global.level_height - 60;
		this.smoke_bubble_holder._x = 0;
		this.smoke_bubble_holder._y = com.nitrome.toxic.Global.level_height - 60;
		this.wall_overlay._y = com.nitrome.toxic.Global.level_height - 191;
		this.wall_overlay._width = com.nitrome.toxic.Global.level_width;
	}
	function doPause()
	{
		for(var _loc2_ in this.smoke_bubble_holder)
		{
			_root._stop(this.smoke_bubble_holder[_loc2_]);
		}
		for(_loc2_ in this.acid_clip)
		{
			_root._stop(this.acid_clip[_loc2_]);
		}
	}
	function doUnpause()
	{
		for(var _loc2_ in this.smoke_bubble_holder)
		{
			_root._play(this.smoke_bubble_holder[_loc2_]);
		}
		for(_loc2_ in this.acid_clip)
		{
			_root._play(this.acid_clip[_loc2_]);
		}
	}
}
