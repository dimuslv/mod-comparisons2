class Utils
{
	static var bomberRangeBitmap;
	static var collisionQueryBitmap;
	static var extraVisibilities;
	static var layerVisibilities;
	static var robotRangeBitmap;
	static var testVisibilities;
	static var invulnerable = false;
	static var noDeath = false;
	static var fullLoads = false;
	static var controlAtBeginning = false;
	static var emptyStringOnExit = true;
	static var closeWindowsOnExit = false;
	static var perf = true;
	static var inaccuratePhysics = false;
	static var masked = true;
	static var zeroPoint = new flash.geom.Point(0,0);
	static var deactivateTeleport = false;
	static var laserState = 1;
	static var conveyorsOn = true;
	static var skipBeginning = true;
	static var autoScroll = true;
	static var screenshake = true;
	static var visWindowArray = ["Damage",60,52,"Acid",60,52,"Object",60,52,"Bomb",31,18,"Explosion",120,120];
	static var bmps = {};
	static var empty_bmp = new flash.display.BitmapData(200,200,false);
	static var inputDisplayParams = {size:20,border:2,spacing:4};
	function Utils()
	{
	}
	static function init()
	{
		Utils.bomberRangeBitmap = new flash.display.BitmapData(499,299,true,2163588879);
		Utils.bomberRangeBitmap.fillRect(new flash.geom.Rectangle(49,0,401,299),2163372556);
		Utils.bomberRangeBitmap.fillRect(new flash.geom.Rectangle(149,0,201,299),2164001796);
		Utils.bomberRangeBitmap.fillRect(new flash.geom.Rectangle(1,1,47,297),0);
		Utils.bomberRangeBitmap.fillRect(new flash.geom.Rectangle(50,1,98,297),0);
		Utils.bomberRangeBitmap.fillRect(new flash.geom.Rectangle(150,1,99,297),0);
		Utils.bomberRangeBitmap.fillRect(new flash.geom.Rectangle(250,1,99,297),0);
		Utils.bomberRangeBitmap.fillRect(new flash.geom.Rectangle(351,1,98,297),0);
		Utils.bomberRangeBitmap.fillRect(new flash.geom.Rectangle(451,1,47,297),0);
	}
	static function onLoadLevel(game)
	{
		Utils.robotRangeBitmap.dispose();
		Utils.robotRangeBitmap = new flash.display.BitmapData(com.nitrome.toxic.Global.level_width,com.nitrome.toxic.Global.level_height,true,0);
		game.test_holder.createEmptyMovieClip("robotRanges",game.test_holder.getNextHighestDepth());
		game.test_holder.robotRanges.attachBitmap(Utils.robotRangeBitmap,1);
		game.test_holder.createEmptyMovieClip("testPoints",game.test_holder.getNextHighestDepth());
		game.test_holder.testPoints.attachBitmap(flash.display.BitmapData.loadBitmap("testPoints"),1);
		Utils.collisionQueryBitmap.dispose();
		Utils.collisionQueryBitmap = new flash.display.BitmapData(com.nitrome.toxic.Global.level_width,com.nitrome.toxic.Global.level_height,true,0);
		game.test_holder.createEmptyMovieClip("collisionQueries",game.test_holder.getNextHighestDepth());
		game.test_holder.collisionQueries.attachBitmap(Utils.collisionQueryBitmap,1);
	}
	static function onClearAll(game)
	{
		for(var _loc2_ in game.test_holder)
		{
			game.test_holder[_loc2_].removeMovieClip();
		}
	}
	static function testVisible(layer)
	{
		return _root.game.test_holder._visible && _root.game.test_holder[layer]._visible && !TAS.fastPlayback;
	}
	static function markCollisionQuery(x, y, fun)
	{
		var _loc4_ = fun(x,y);
		if(Utils.testVisible("collisionQueries"))
		{
			Utils.collisionQueryBitmap.setPixel32(x,y,_loc4_ ? 4294914816 : 4288269567);
		}
		return _loc4_;
	}
	static function markBomberRange(x, y)
	{
		if(Utils.testVisible("robotRanges"))
		{
			Utils.robotRangeBitmap.copyPixels(Utils.bomberRangeBitmap,Utils.bomberRangeBitmap.rectangle,new flash.geom.Point(x - 249,y - 199));
		}
	}
	static function clearTestBitmaps()
	{
		if(Utils.testVisible("collisionQueries"))
		{
			Utils.collisionQueryBitmap.fillRect(Utils.collisionQueryBitmap.rectangle,0);
		}
		if(Utils.testVisible("robotRanges"))
		{
			Utils.robotRangeBitmap.fillRect(Utils.robotRangeBitmap.rectangle,0);
		}
	}
	static function cutsceneIn()
	{
		if(!TAS.fastPlayback)
		{
			_root.cutscene.gotoAndPlay("in");
		}
		else
		{
			_root.cutscene.gotoAndStop(18);
		}
	}
	static function cutsceneOut()
	{
		if(!TAS.fastPlayback)
		{
			_root.cutscene.gotoAndPlay("out");
		}
		else
		{
			_root.cutscene.gotoAndStop(1);
		}
	}
	static function levelInit()
	{
		var _loc2_;
		if(!Utils.layerVisibilities)
		{
			Utils.layerVisibilities = {};
			_loc2_ = [];
			for(var _loc3_ in _root.game)
			{
				if(_loc3_.slice(-7) == "_holder")
				{
					_loc2_.push(_loc3_);
				}
			}
			for(_loc3_ in _loc2_)
			{
				Utils.layerVisibilities[_loc2_[_loc3_]] = true;
			}
			Utils.layerVisibilities.test_holder = false;
			Utils.testVisibilities = {testPoints:true,collisionQueries:false,robotRanges:false};
			Utils.extraVisibilities = {pipes:true,big_pipes:true,acid_holder:true,bomb_panel:true,health_panel:true,powercell_panel:true,text_display:true,cutscene:true,popup_holder:true};
		}
		for(_loc3_ in _root.game)
		{
			if(_loc3_.slice(-7) == "_holder")
			{
				_root.game[_loc3_]._visible = Utils.layerVisibilities[_loc3_];
			}
		}
		for(var _loc4_ in Utils.extraVisibilities)
		{
			_root[_loc4_]._visible = Utils.extraVisibilities[_loc4_];
		}
		for(var _loc5_ in Utils.testVisibilities)
		{
			_root.game.test_holder[_loc5_]._visible = Utils.testVisibilities[_loc5_];
		}
	}
	static function doKeyDown(code)
	{
		var _loc2_;
		if(code == 77)
		{
			_loc2_ = Windows.createEmptyWindow(100,100);
			Utils.mainMenu(_loc2_);
			return true;
		}
	}
	static function mainMenu(w)
	{
		w.updateMainField({title:"Main menu",curWindow:Utils.mainMenu,options:["Testing vars",Utils.testingVarsWindow,"Bruteforcing",Utils.bruteforcingWindow,"Info windows",Utils.infoWindowsWindow,"Preferences",Utils.preferenceWindow,"Layer visibility",Utils.layerVisibilityWindow,"Inspect",[Utils.inspectWindow,"_root.game"]]});
	}
	static function testingVarsWindow(w)
	{
		var _loc2_ = {title:"Testing vars",curWindow:Utils.testingVarsWindow,options:[]};
		Utils.addToggleVarOptions(_loc2_.options,["Invulnerability",Utils,"invulnerable","No death",Utils,"noDeath","Wrong physics",Utils,"inaccuratePhysics","Deactivate teleport",Utils,"deactivateTeleport","Skip beginning",Utils,"skipBeginning"]);
		Utils.addCycleOption(_loc2_.options,"Lasers",Utils,"laserState",["off","on","simple"]);
		Utils.addToggleVarOptions(_loc2_.options,["Conveyors",Utils,"conveyorsOn"]);
		_loc2_.options.push("Back",Utils.mainMenu);
		w.updateMainField(_loc2_);
	}
	static function addToggleVarOptions(options, stuffArray)
	{
		var _loc3_ = 0;
		var _loc4_;
		var _loc5_;
		var _loc6_;
		while(_loc3_ < stuffArray.length)
		{
			_loc4_ = stuffArray[_loc3_];
			_loc5_ = stuffArray[_loc3_ + 1];
			_loc6_ = stuffArray[_loc3_ + 2];
			options.push(_loc4_ + ": " + (_loc5_[_loc6_] ? "on" : "off"));
			options.push([Utils.toggleVar,_loc5_,_loc6_]);
			_loc3_ += 3;
		}
	}
	static function toggleVar(w, stump, varName)
	{
		stump[varName] = !stump[varName];
		w.obj.curWindow(w);
	}
	static function addCycleOption(options, name, stump, varName, values)
	{
		options.push(name + ": " + values[stump[varName]]);
		options.push([Utils.cycleVar,stump,varName,values]);
	}
	static function cycleVar(w, stump, varName, values)
	{
		stump[varName]++;
		stump[varName] %= values.length;
		w.obj.curWindow(w);
	}
	static function bruteforcingWindow(w)
	{
		w.updateMainField({title:"Bruteforcing",curWindow:Utils.bruteforcingWindow,options:["Copy collision data 📋",Utils.copyCollisionData,"Back",Utils.mainMenu]});
	}
	static function copyCollisionData(w)
	{
		var _loc3_ = [];
		var _loc4_ = 0;
		var _loc5_;
		var _loc6_;
		var _loc7_;
		while(_loc4_ < com.nitrome.toxic.Global.level_height)
		{
			_loc5_ = 0;
			while(_loc5_ < com.nitrome.toxic.Global.level_cols)
			{
				_loc6_ = 0;
				_loc7_ = 0;
				while(_loc7_ < 32)
				{
					if(_root.game.getSceneryCollision(_loc5_ * 32 + _loc7_,_loc4_))
					{
						_loc6_ |= 1 << _loc7_;
					}
					_loc7_ = _loc7_ + 1;
				}
				_loc3_.push(_loc6_);
				_loc5_ = _loc5_ + 1;
			}
			_loc4_ = _loc4_ + 1;
		}
		System.setClipboard(_loc3_.toString());
	}
	static function toggleMask(w)
	{
		Utils.masked = !Utils.masked;
		if(Utils.masked)
		{
			_root.setMask(mask);
		}
		else
		{
			_root.setMask(null);
		}
		w.obj.curWindow(w);
	}
	static function preferenceWindow(w)
	{
		var _loc2_ = {title:"Preferences",curWindow:Utils.preferenceWindow,options:[]};
		Utils.addToggleVarOptions(_loc2_.options,["Perf optimizations",Utils,"perf","Auto scroll",Utils,"autoScroll","Screenshake",Utils,"screenshake"]);
		_loc2_.options.push("Back",Utils.mainMenu);
		w.updateMainField(_loc2_);
	}
	static function infoWindowsWindow(w)
	{
		var _loc2_ = [];
		var _loc3_ = 0;
		while(_loc3_ < Utils.visWindowArray.length)
		{
			_loc2_.push(Utils.visWindowArray[_loc3_] + " visualization 🗗",[Utils.activateStaticWindow,Windows.clip[Utils.visWindowArray[_loc3_] + "VisWindow"]]);
			_loc3_ += 3;
		}
		_loc2_.push("Input display 🗗",[Utils.activateStaticWindow,Windows.clip.inputDisplay]);
		_loc2_.push("Back",Utils.mainMenu);
		w.updateMainField({title:"Info windows",curWindow:Utils.infoWindowsWindow,options:_loc2_});
	}
	static function activateStaticWindow(w, w2)
	{
		w2._visible = true;
	}
	static function clearBitmap(bmp)
	{
		bmp.copyPixels(Utils.empty_bmp,new flash.geom.Rectangle(0,0,bmp.width,bmp.height),Utils.zeroPoint);
	}
	static function imgMinimize(w)
	{
		w.minimized = !w.minimized;
		w.img._visible = !w.minimized;
		w.updateMainField(false);
	}
	static function updateVisBitmap(n, source_bmp)
	{
		var _loc3_ = Utils.bmps[n];
		if(!TAS.fastPlayback && Windows.clip[n + "VisWindow"]._visible)
		{
			Utils.clearBitmap(_loc3_);
			_loc3_.copyPixels(source_bmp,new flash.geom.Rectangle(0,0,source_bmp.width,source_bmp.height),Utils.zeroPoint);
		}
	}
	static function layerVisibilityWindow(w)
	{
		for(var _loc3_ in _root.game)
		{
			if(_loc3_.slice(-7) == "_holder")
			{
				_root.game[_loc3_]._visible = Utils.layerVisibilities[_loc3_];
			}
		}
		var _loc4_ = {title:"Layer visibility",curWindow:Utils.layerVisibilityWindow,options:[]};
		var _loc5_ = [];
		for(_loc3_ in Utils.layerVisibilities)
		{
			_loc5_.push(_loc3_.slice(0,-7),Utils.layerVisibilities,_loc3_);
		}
		_loc4_.options.push("Back",Utils.mainMenu);
		_loc4_.options.push("Extra",Utils.extraVisibilityWindow);
		Utils.addToggleVarOptions(_loc4_.options,_loc5_);
		w.updateMainField(_loc4_);
	}
	static function extraVisibilityWindow(w)
	{
		for(var _loc3_ in Utils.testVisibilities)
		{
			_root.game.test_holder[_loc3_]._visible = Utils.testVisibilities[_loc3_];
		}
		for(var _loc4_ in Utils.extraVisibilities)
		{
			_root[_loc4_]._visible = Utils.extraVisibilities[_loc4_];
		}
		var _loc5_ = {title:"Extra visibility",curWindow:Utils.extraVisibilityWindow,options:[]};
		var _loc6_ = [];
		if(Utils.layerVisibilities.test_holder)
		{
			for(_loc3_ in Utils.testVisibilities)
			{
				_loc6_.push(_loc3_,Utils.testVisibilities,_loc3_);
			}
		}
		for(_loc4_ in Utils.extraVisibilities)
		{
			_loc6_.push(_loc4_,Utils.extraVisibilities,_loc4_);
		}
		_loc5_.options.push("Back",Utils.layerVisibilityWindow);
		_loc5_.options.push("Mask: " + (Utils.masked ? "on" : "off"),Utils.toggleMask);
		Utils.addToggleVarOptions(_loc5_.options,_loc6_);
		w.updateMainField(_loc5_);
	}
	static function inspectWindow(w, str, isProp)
	{
		if(str === "_root")
		{
			Utils.mainMenu(w);
			return undefined;
		}
		var obj = {title:str.slice(str.lastIndexOf(".") + 1) + (isProp ? "" : "/"),update:[Utils.inspectWindow,str,isProp],options:["Back"]};
		if(isProp)
		{
			obj.options.push([Utils.inspectWindow,str,false]);
		}
		else
		{
			obj.options.push([Utils.inspectWindow,str.slice(0,str.lastIndexOf(".")),false]);
		}
		var currentObj = eval(str);
		if(currentObj)
		{
			if(!isProp)
			{
				obj.options.push("Properties",[Utils.inspectWindow,str,true]);
			}
			else if(typeof currentObj === "movieclip")
			{
				obj.options.push("_x: " + currentObj._x,false,"_y: " + currentObj._y,false,"_currentframe: " + currentObj._currentframe,false);
			}
			for(var i in currentObj)
			{
				switch(typeof currentObj[i])
				{
					default:
						if(isProp)
						{
							obj.options.push(i + ": " + currentObj[i],false);
						}
						break;
					case "object":
					case "movieclip":
						if(!isProp)
						{
							obj.options.push(i,[Utils.inspectWindow,str + "." + i]);
						}
						break;
					case "function":
				}
			}
		}
		w.updateMainField(obj);
	}
	static function getLast(arr)
	{
		return arr[arr.length - 1];
	}
	static function pushO(arr, frame, inp, num)
	{
		Utils.getLast(arr).push(frame - arr[arr.length - 4],inp,num,0);
	}
	static function foif()
	{
		return eval(Selection.getFocus()).type === "input";
	}
	static function currentPlayerString()
	{
		var _loc2_ = _root.game.player;
		return [_loc2_._x,_loc2_._y,_loc2_.state,_loc2_.vx,_loc2_.vy].join("/");
	}
}
