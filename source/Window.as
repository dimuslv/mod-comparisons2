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
		
		this.mainIndices = [];
		this.mainBehaviors = [];
		this.mainTextField.text = "";
		
		this.addOption(obj.title + " ", Windows.startDragging);
		
		if (!obj.noMinimize) {
			this.addOption(this.minimized? "🗖 " : "🗕 ", obj.customMinimize? obj.customMinimize : Windows.minimizeWindow);
		}
		
		this.addOption("🗙", Windows.closeWindow);
		
		if (!this.minimized) {
			if (obj.headerOptions) {
				for (var i = 0; i < obj.headerOptions.length; i += 2) {
					this.addOption(obj.headerOptions[i], obj.headerOptions[i+1], " ");
				}
			}
			
			if (obj.options) {
				if (this.scroll > 0) {
					this.addOption("↑", Windows.scrollUp, "\n");
				}
				
				var end = Math.min((this.scroll + 20 - (this.scroll > 0? 1 : 0)) * 2, obj.options.length);
				
				for (var i = this.scroll * 2; i < end; i += 2) {
					this.addOption(obj.options[i], obj.options[i+1], "\n");
				}
				
				if (end < obj.options.length) {
					this.addOption("↓", Windows.scrollDown, "\n");
				}
			}
		}
	}
	
	function addOption(name, func, before) {
		if (before) {
			this.mainTextField.text += before;
		}
		this.mainIndices.push(this.mainTextField.text.length);
		this.mainBehaviors.push(func);
		this.mainTextField.text += name;
	}
}