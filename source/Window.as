class Window extends MovieClip
{
	var obj;
	var mainIndices;
	var mainBehaviors;
	var minimized = false;
	var _static = false;
	var scroll = 0;
	
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
		if (obj) {
			if (this.obj.title !== obj.title) {
				this.scroll = 0;
			}
			this.obj = obj;
		} else {
			obj = this.obj;
		}
		
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
		
		if (!this.minimized) {
			if (obj.headerOptions) {
				for (var i = 0; i < obj.headerOptions.length; i += 2) {
					this.mainTextField.text += " ";
					this.mainIndices.push(this.mainTextField.text.length);
					this.mainBehaviors.push(obj.headerOptions[i+1]);
					this.mainTextField.text += obj.headerOptions[i];
				}
			}
			
			if (obj.options) {
				if (this.scroll > 0) {
					this.mainTextField.text += "\n";
					this.mainIndices.push(this.mainTextField.text.length);
					this.mainBehaviors.push(Windows.scrollUp);
					this.mainTextField.text += "↑";
				}
				var end = Math.min((this.scroll + 20 - (this.scroll > 0? 1 : 0)) * 2, obj.options.length);
				for (var i = this.scroll * 2; i < end; i += 2) {
					this.mainTextField.text += "\n";
					this.mainIndices.push(this.mainTextField.text.length);
					this.mainBehaviors.push(obj.options[i+1]);
					this.mainTextField.text += obj.options[i];
				}
				if (end < obj.options.length) {
					this.mainTextField.text += "\n";
					this.mainIndices.push(this.mainTextField.text.length);
					this.mainBehaviors.push(Windows.scrollDown);
					this.mainTextField.text += "↓";
				}
			}
		}
	}
}