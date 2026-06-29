class Window extends MovieClip
{
	var mainBehaviors;
	var mainIndices;
	var mainTextField;
	var obj;
	var minimized = false;
	var _static = false;
	var scroll = 0;
	function Window()
	{
		super();
	}
	function init(x, y, obj)
	{
		this._x = x;
		this._y = y;
		var _loc5_ = this.createTextField("mainTextField",this.getNextHighestDepth(),0,0,0,20);
		_loc5_.background = true;
		_loc5_.autoSize = true;
		this.updateMainField(obj);
	}
	function updateMainField(obj)
	{
		if(obj)
		{
			if(this.obj.title !== obj.title)
			{
				this.scroll = 0;
			}
			this.obj = obj;
		}
		else
		{
			obj = this.obj;
		}
		this.mainIndices = [];
		this.mainBehaviors = [];
		this.mainTextField.text = "";
		this.addOption(obj.title + " ",Windows.startDragging);
		if(!obj.noMinimize)
		{
			this.addOption(this.minimized ? "🗖 " : "🗕 ",obj.customMinimize ? obj.customMinimize : Windows.minimizeWindow);
		}
		this.addOption("🗙",Windows.closeWindow);
		var _loc3_;
		var _loc4_;
		if(!this.minimized)
		{
			if(obj.headerOptions)
			{
				_loc3_ = 0;
				while(_loc3_ < obj.headerOptions.length)
				{
					this.addOption(obj.headerOptions[_loc3_],obj.headerOptions[_loc3_ + 1]," ");
					_loc3_ += 2;
				}
			}
			if(obj.options)
			{
				if(this.scroll > 0)
				{
					this.addOption("↑",Windows.scrollUp,"\n");
				}
				_loc4_ = Math.min((this.scroll + 20 - (this.scroll > 0 ? 1 : 0)) * 2,obj.options.length);
				_loc3_ = this.scroll * 2;
				while(_loc3_ < _loc4_)
				{
					this.addOption(obj.options[_loc3_],obj.options[_loc3_ + 1],"\n");
					_loc3_ += 2;
				}
				if(_loc4_ < obj.options.length)
				{
					this.addOption("↓",Windows.scrollDown,"\n");
				}
			}
		}
	}
	function addOption(name, func, before)
	{
		if(before)
		{
			this.mainTextField.text += before;
		}
		this.mainIndices.push(this.mainTextField.text.length);
		this.mainBehaviors.push(func);
		this.mainTextField.text += name;
	}
}
