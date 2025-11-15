class Windows
{
	static var clip;
	static var curDragging = null;
	static var curDragOfsX = 0;
	static var curDragOfsY = 0;
	function Windows()
	{
	}
	static function init()
	{
		Windows.clip = _root.window_clip;
		var w = Windows.clip.attachMovie("window","inputWindow",Windows.clip.getNextHighestDepth());
		w.init(10,355,{title:"Input string",customMinimize:function(w)
		{
			w.minimized = !w.minimized;
			if(w.inputField._visible = !w.minimized)
			{
				TAS.updateText();
			}
			w.updateMainField(false);
		}});
		w._static = true;
		w.createTextField("inputField",w.getNextHighestDepth(),0,20,530,20);
		w.inputField.background = true;
		w.inputField.type = "input";
		w._visible = false;
		TAS.inputField = w.inputField;
		w = Windows.clip.attachMovie("window","varWindow",Windows.clip.getNextHighestDepth());
		w.init(10,40,{title:"Vars",update:TAS.updateVarWindow});
		w._static = true;
		w._visible = false;
		var _loc2_ = 0;
		var _loc3_;
		while(_loc2_ < Utils.visWindowArray.length)
		{
			_loc3_ = Utils.visWindowArray[_loc2_];
			w = Windows.clip.attachMovie("window",_loc3_ + "VisWindow",Windows.clip.getNextHighestDepth());
			w.init(160 + 23 * _loc2_,7,{title:_loc3_,customMinimize:function(w)
			{
				w.minimized = !w.minimized;
				w.img._visible = !w.minimized;
				w.updateMainField(false);
			}});
			w.createEmptyMovieClip("img",w.getNextHighestDepth());
			w.img._y = 20;
			Utils.bmps[_loc3_] = new flash.display.BitmapData(Utils.visWindowArray[_loc2_ + 1],Utils.visWindowArray[_loc2_ + 2],false);
			w.img.attachBitmap(Utils.bmps[_loc3_],w.img.getNextHighestDepth());
			w._static = true;
			w._visible = false;
			_loc2_ += 3;
		}
		w = Windows.clip.attachMovie("window","timerWindow",Windows.clip.getNextHighestDepth());
		w.init(29,7,{title:"00:00.000",update:Timer.updateTimerWindow,noMinimize:true});
		w.mainTextField.setNewTextFormat(new TextFormat("Consolas",18));
		w.mainTextField._height = 25;
		w._static = true;
		w._visible = true;
		_root.createTextField("nullField",_root.getNextHighestDepth(),0,0,0,0);
		_root.nullField._visible = false;
		Windows.clip.onMouseUp = function()
		{
			Windows.curDragging = null;
		};
		Windows.clip.onEnterFrame = Windows.update;
	}
	static function update()
	{
		if(Windows.curDragging)
		{
			Windows.curDragging._x = Math.max(0,Math.min(550,_xmouse)) + Windows.curDragOfsX;
			Windows.curDragging._y = Math.max(0,Math.min(400,_ymouse)) + Windows.curDragOfsY;
		}
		else
		{
			var focus = Selection.getFocus();
			if(focus.slice(0,19) == "_level0.window_clip" && focus.slice(focus.length - "mainTextField".length) == "mainTextField")
			{
				var w = Windows.clip[focus.slice(20,focus.length - "mainTextField".length - 1)];
				var ind = Selection.getCaretIndex();
				trace(ind);
				var i = w.mainIndices.length - 1;
				while(i >= 0)
				{
					if(ind >= w.mainIndices[i])
					{
						if(w.mainBehaviors[i])
						{
							if(w.mainBehaviors[i] instanceof Function)
							{
								w.mainBehaviors[i](w);
								break;
							}
							if(w.mainBehaviors[i] instanceof Array)
							{
								var fun = w.mainBehaviors[i][0];
								w.mainBehaviors[i][0] = w;
								fun.apply(null,w.mainBehaviors[i]);
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
		for(i in Windows.clip)
		{
			if(Windows.clip[i].obj.update && Windows.clip[i]._visible)
			{
				Windows.clip[i].obj.update(Windows.clip[i]);
			}
		}
	}
	static function nullFocus()
	{
		Selection.setFocus(_root.nullField);
	}
	static function minimizeWindow(w)
	{
		w.minimized = !w.minimized;
		w.updateMainField(false);
	}
	static function closeWindow(w)
	{
		if(w._static)
		{
			w._visible = false;
		}
		else
		{
			w.removeMovieClip();
		}
	}
	static function startDragging(w)
	{
		Windows.curDragging = w;
		Windows.curDragOfsX = w._x - _xmouse;
		Windows.curDragOfsY = w._y - _ymouse;
		Windows.nullFocus();
	}
	static function createWindow(x, y, obj)
	{
		var _loc4_ = Windows.clip.attachMovie("window","window" + Windows.clip.getNextHighestDepth(),Windows.clip.getNextHighestDepth());
		_loc4_.init(x,y,obj);
		return _loc4_;
	}
	static function createEmptyWindow(x, y)
	{
		return Windows.createWindow(x,y,{title:""});
	}
}
