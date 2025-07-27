class Window extends MovieClip
{
	var behaviorObject;
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
			this.behaviorObject = obj;
		else
			obj = this.behaviorObject;
		this.mainIndices = [0];
		this.mainBehaviors = [Windows.startDragging];
		this.mainTextField.text = obj.title + " ";
		
		this.mainIndices.push(this.mainTextField.text.length);
		this.mainBehaviors.push(obj.customMinimize? obj.customMinimize : Windows.minimizeWindow);
		this.mainTextField.text += (this.minimized? "🗖 " : "🗕 ");
		
		this.mainIndices.push(this.mainTextField.text.length);
		this.mainBehaviors.push(Windows.closeWindow);
		this.mainTextField.text += "🗙";
		
		if (!this.minimized && obj.optionLabels) {
			var i = 0;
			while (i < obj.optionLabels.length) {
				this.mainTextField.text += "\n";
				this.mainIndices.push(this.mainTextField.text.length);
				if (obj.optionFunctions)
					this.mainBehaviors.push(obj.optionFunctions[i]);
				this.mainTextField.text += obj.optionLabels[i];
				i++;
			}
		}
	}
}