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
		this.mainIndices = [0];
		this.mainBehaviors = [Windows.startDragging];
		this.mainTextField.text = obj.title + " ";
		if(!obj.noMinimize)
		{
			this.mainIndices.push(this.mainTextField.text.length);
			this.mainBehaviors.push(obj.customMinimize ? obj.customMinimize : Windows.minimizeWindow);
			this.mainTextField.text += this.minimized ? "🗖 " : "🗕 ";
		}
		this.mainIndices.push(this.mainTextField.text.length);
		this.mainBehaviors.push(Windows.closeWindow);
		this.mainTextField.text += "🗙";
		var _loc3_;
		var _loc4_;
		if(!this.minimized && obj.options)
		{
			if(this.scroll > 0)
			{
				this.mainTextField.text += "\n";
				this.mainIndices.push(this.mainTextField.text.length);
				this.mainBehaviors.push(Windows.scrollUp);
				this.mainTextField.text += "↑";
			}
			_loc3_ = Math.min((this.scroll + 20 - (this.scroll > 0 ? 1 : 0)) * 2,obj.options.length);
			_loc4_ = this.scroll * 2;
			while(_loc4_ < _loc3_)
			{
				this.mainTextField.text += "\n";
				this.mainIndices.push(this.mainTextField.text.length);
				this.mainBehaviors.push(obj.options[_loc4_ + 1]);
				this.mainTextField.text += obj.options[_loc4_];
				_loc4_ += 2;
			}
			if(_loc3_ < obj.options.length)
			{
				this.mainTextField.text += "\n";
				this.mainIndices.push(this.mainTextField.text.length);
				this.mainBehaviors.push(Windows.scrollDown);
				this.mainTextField.text += "↓";
			}
		}
	}
}
