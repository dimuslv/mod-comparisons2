/*
{
	type: "menu"/"",
	title: "Main Menu",
	mainTextField: ,
	inputTextField: 
	update: undefined/updateFunction
}
*/
class Windows
{
	static var clip;
	
	static var curDragging = null;
	
	static var curDragOfsX = 0;
	
	static var curDragOfsY = 0;
	
	static function init() {
		Windows.clip = _root.window_clip;
		
		/*var w = clip.createTextField("window" + clip.getNextHighestDepth(),clip.getNextHighestDepth(),50,50,0,20);
		w.text = "window - x"
		w.background = true;
		w.autoSize = true;*/
		
		var w = Windows.clip.attachMovie("window", "inputWindow", Windows.clip.getNextHighestDepth());
		w.init(10, 355, {
			title: "Input string",
			customMinimize: function(w) {
				w.minimized = !w.minimized;
				w.inputField._visible = !w.minimized;
				w.updateMainField(false);
			}
		});
		w._static = true;
		
		w.createTextField("inputField", w.getNextHighestDepth(), 0, 20, 530, 20);
		w.inputField.background = true;
		w.inputField.type = "input";
		w.inputField.restrict = "^[]";
		w._visible = false;
		
		TAS.inputField = w.inputField;
		
		w = Windows.clip.attachMovie("window", "varWindow", Windows.clip.getNextHighestDepth());
		w.init(10, 40, {title: "Vars", update: TAS.updateVarWindow});
		w._static = true;
		w._visible = false;
		
		_root.createTextField("nullField", _root.getNextHighestDepth(), 0, 0, 0, 0);
		_root.nullField._visible = false;
		
		Windows.clip.onMouseUp = function() {
			Windows.curDragging = null;
		};
		
		Windows.clip.onEnterFrame = Windows.update;
	}
	
	static function update() {
		if (Windows.curDragging) {
			Windows.curDragging._x = Math.max(0, Math.min(550, _xmouse)) + Windows.curDragOfsX;
			Windows.curDragging._y = Math.max(0, Math.min(400, _ymouse)) + Windows.curDragOfsY;
			//Windows.nullFocus();
		} else {
			var focus = Selection.getFocus();
			if (focus.slice(0, 19) == "_level0.window_clip" && focus.slice(focus.length - "mainTextField".length) == "mainTextField") {
				var w = Windows.clip[focus.slice(20, focus.length - "mainTextField".length - 1)];
				var ind = Selection.getCaretIndex();
				trace(ind);
				
				var i = w.mainIndices.length - 1;
				while (i >= 0) {
					if (ind >= w.mainIndices[i]) {
						if (w.mainBehaviors[i])
							w.mainBehaviors[i](w);
						break;
					}
					i--;
				}
				Windows.nullFocus();
			}
		}
		
		for (i in Windows.clip) {
			if (Windows.clip[i].behaviorObject.update) {
				Windows.clip[i].behaviorObject.update(Windows.clip[i]);
			}
		}
	}
	
	static function nullFocus() {
		Selection.setFocus(_root.nullField);
		//Selection.setSelection(0,0);
	}
	
	static function minimizeWindow(w) {
		w.minimized = !w.minimized;
		w.updateMainField(false);
	}
	
	static function closeWindow(w) {
		if (w._static) {
			w._visible = false;
		} else {
			w.removeMovieClip();
		}
	}
	
	static function startDragging(w) {
		Windows.curDragging = w;
		Windows.curDragOfsX = w._x - _xmouse;
		Windows.curDragOfsY = w._y - _ymouse;
		Windows.nullFocus();
	}
}