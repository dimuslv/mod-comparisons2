class Window extends MovieClip
{
	var obj;
	var mainIndices;
	var mainBehaviors;
	var minimized = false;
	var _static = false;
	
	function Window() {
		super();
	}
	
	function init(x, y, obj) {
		this._x = x;
		this._y = y;
		var f = this.createTextField("mainTextField", this.getNextHighestDepth(), 0, 0, 0, 20);
		f.background = true;
		f.autoSize = true;
		this.updateMainField(obj);
	}
	
	function updateMainField(obj) {
		if (obj)
			this.obj = obj;
		else
			obj = this.obj;
		this.mainIndices = [0];
		this.mainBehaviors = [Windows.startDragging];
		this.mainTextField.text = obj.title + " ";
		
		if (!obj.noMinimize) {
			this.mainIndices.push(this.mainTextField.text.length);
			this.mainBehaviors.push(obj.customMinimize? obj.customMinimize : Windows.minimizeWindow);
			this.mainTextField.text += (this.minimized? "🗖 " : "🗕 ");
		}
		
		this.mainIndices.push(this.mainTextField.text.length);
		this.mainBehaviors.push(Windows.closeWindow);
		this.mainTextField.text += "🗙";
		
		if (!this.minimized && obj.options) {
			var i = 0;
			while (i < obj.options.length) {
				this.mainTextField.text += "\n";
				this.mainIndices.push(this.mainTextField.text.length);
				this.mainBehaviors.push(obj.options[i+1]);
				this.mainTextField.text += obj.options[i];
				i += 2;
			}
		}
	}
}