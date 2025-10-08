class com.nitrome.toxic.TextDisplay extends MovieClip
{
	var clip;
	var info_string;
	var onEnterFrame;
	var displaying = false;
	var char_count = 0;
	function TextDisplay()
	{
		super();
	}
	function displayText(s, colour)
	{
		if(colour == 2)
		{
			this.clip.gotoAndStop("red");
		}
		else
		{
			this.clip.gotoAndStop("green");
		}
		s = s.toUpperCase();
		if(this.displaying == true)
		{
			if(s != this.info_string)
			{
				this.info_string = s;
				this.clip.tf.text = "";
			}
		}
		else if(this.displaying == false)
		{
			this.info_string = s;
			this.clip.tf.text = "";
			if(!TAS.fastPlayback)
			{
				this.gotoAndPlay("in");
			}
			else
			{
				this.gotoAndStop("there");
			}
			this.displaying = true;
		}
	}
	function startText()
	{
		this.char_count = 0;
		this.clip.head.play();
		this.onEnterFrame = function()
		{
			this.displayNextChar();
		};
	}
	function displayNextChar()
	{
		var _loc2_ = this.clip.tf.text;
		var _loc3_ = this.info_string.charAt(this.char_count);
		_loc2_ += _loc3_;
		this.clip.tf.text = _loc2_;
		this.char_count = this.char_count + 1;
		if(this.char_count > this.info_string.length - 1)
		{
			this.clip.tf.text = this.info_string;
			this.clip.head.gotoAndStop(1);
			delete this.onEnterFrame;
		}
	}
	function hideText()
	{
		delete this.onEnterFrame;
		if(this.displaying == true)
		{
			if(!TAS.fastPlayback)
			{
				this.gotoAndPlay("out");
			}
			else
			{
				this.gotoAndStop(1);
			}
			this.displaying = false;
		}
	}
}
