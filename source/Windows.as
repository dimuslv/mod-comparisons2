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
		//w.inputField.restrict = "^[]";
		w._visible = false;
		
		TAS.inputField = w.inputField;
		
		w = Windows.clip.attachMovie("window", "varWindow", Windows.clip.getNextHighestDepth());
		w.init(10, 40, {title: "Vars", update: TAS.updateVarWindow});
		w._static = true;
		w._visible = false;
		
		var visWindowArray = [
			"Damage", 60, 52,
			"Acid", 60, 52,
			"Object", 60, 52
		];
		
		var i = 0;
		while (i < visWindowArray.length) {
			var n = visWindowArray[i];
			
			w = Windows.clip.attachMovie("window", n + "VisWindow", Windows.clip.getNextHighestDepth());
			
			w.init(0, 0, {
				title: n,
				customMinimize: function(w) {
					w.minimized = !w.minimized;
					w.img._visible = !w.minimized;
					w.updateMainField(false);
				}
			});
			
			w.createEmptyMovieClip("img", w.getNextHighestDepth());
			w.img._y = 20;
			Utils.bmps[n] = new flash.display.BitmapData(visWindowArray[i+1], visWindowArray[i+2], false);
			w.img.attachBitmap(Utils.bmps[n], w.img.getNextHighestDepth());
			w._static = true;
			w._visible = false;
			i += 3;
		}
		
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
						if (w.mainBehaviors[i]) {
							if (w.mainBehaviors[i] instanceof Function) {
								w.mainBehaviors[i](w);
							} else if (w.mainBehaviors[i] instanceof Array) {
								var fun = w.mainBehaviors[i][0];
								w.mainBehaviors[i][0] = w;
								fun.apply(null, w.mainBehaviors[i]);
								w.mainBehaviors[i][0] = fun;
							}
						}
						break;
					}
					i--;
				}
				Windows.nullFocus();
			}
		}
		
		for (i in Windows.clip) {
			if (Windows.clip[i].obj.update) {
				Windows.clip[i].obj.update(Windows.clip[i]);
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
	
	static function createWindow(x, y, obj) {
		var w = Windows.clip.attachMovie("window", "window" + Windows.clip.getNextHighestDepth(), Windows.clip.getNextHighestDepth());
		w.init(x, y, obj);
		return w;
	}
	
	static function createEmptyWindow(x, y) {
		return Windows.createWindow(x, y, {title: ""});
	}
}