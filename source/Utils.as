class Utils
{
	static var invulnerable = false;
	static var noDeath = false;
	static var fullLoads = false;
	static var controlAtBeginning = false;
	static var emptyStringOnExit = true;
	static var closeWindowsOnExit = false;
	static var perf = true;
	static var inaccuratePhysics = false;
	static var masked = true;
	static var zeroPoint = new flash.geom.Point(0, 0);
	static var deactivateTeleport = false;
	static var layerVisibilities;
	static var extraLayerVisibilities;
	static var laserState = 1;
	static var conveyorsOn = true;
	static var skipBeginning = true;
	static var autoScroll = true;
	static var screenshake = true;
	
	static var visWindowArray = [
			"Damage", 60, 52,
			"Acid", 60, 52,
			"Object", 60, 52,
			"Bomb", 31, 18
		];
	static var bmps = {};
	static var empty_bmp = new flash.display.BitmapData(100, 100, false);
	
	static function cutsceneIn() {
		if (!TAS.fastPlayback) {
			_root.cutscene.gotoAndPlay("in");
		} else {
			_root.cutscene.gotoAndStop(18);
		}
	}
	
	static function cutsceneOut() {
		if (!TAS.fastPlayback) {
			_root.cutscene.gotoAndPlay("out");
		} else {
			_root.cutscene.gotoAndStop(1);
		}
	}
	
	static function levelInit() {
		if (!Utils.layerVisibilities) {
			Utils.layerVisibilities = {};
			for (var holder in _root.game) {
				if (holder.slice(-7) == "_holder")
					Utils.layerVisibilities[holder] = true;
			}
			Utils.layerVisibilities.test_holder = false;
			_root.game.test_holder._visible = false;
			
			Utils.extraLayerVisibilities = {
				pipes : true,
				big_pipes : true,
				acid_holder : true,
				bomb_panel : true,
				health_panel : true,
				powercell_panel : true,
				/*boss_health_panel : true,*/
				text_display : true,
				cutscene : true,
				popup_holder : true/*,
				loading_clip : true*/
			};
		} else {
			for (var holder in _root.game) {
				if (holder.slice(-7) == "_holder")
					_root.game[holder]._visible = Utils.layerVisibilities[holder];
			}
			for (var layer in Utils.extraLayerVisibilities) {
				_root[layer]._visible = Utils.extraLayerVisibilities[layer];
			}
		}
	}
	
	static function doKeyDown(code) {
		if (code == 77) {
			var w = Windows.createEmptyWindow(100, 100);
			Utils.mainMenu(w);
			return true;
		}
	}
	
	static function mainMenu(w) {
		w.updateMainField({
			title: "Main menu",
			curWindow: Utils.mainMenu,
			options: [
				"Testing vars", Utils.testingVarsWindow,
				"Bruteforcing", Utils.bruteforcingWindow,
				"Info windows", Utils.infoWindowsWindow,
				"Preferences", Utils.preferenceWindow,
				"Layer visibility", Utils.layerVisibilityWindow
			]
		});
	}
	
	static function testingVarsWindow(w) {
		var obj = {
			title: "Testing vars",
			curWindow: Utils.testingVarsWindow,
			options: []
		}
		
		Utils.addToggleVarOptions(obj.options, [
			"Invulnerability", Utils, "invulnerable",
			"No death", Utils, "noDeath",
			"Wrong physics", Utils, "inaccuratePhysics",
			"Deactivate teleport", Utils, "deactivateTeleport",
			"Skip beginning", Utils, "skipBeginning"
		]);
		
		Utils.addCycleOption(obj.options, "Lasers", Utils, "laserState", ["off", "on", "simple"]);
		
		Utils.addToggleVarOptions(obj.options, [
			"Conveyors", Utils, "conveyorsOn"
		]);
		
		obj.options.push("Back", Utils.mainMenu);
		
		w.updateMainField(obj);
	}
	
	static function addToggleVarOptions(options, stuffArray) {
		var i = 0;
		while (i < stuffArray.length) {
			var name = stuffArray[i];
			var stump = stuffArray[i+1];
			var varName = stuffArray[i+2];
			options.push(name + ": " + (stump[varName]? "on" : "off"));
			options.push([Utils.toggleVar, stump, varName]);
			
			i += 3;
		}
	}
	
	static function toggleVar(w, stump, varName) {
		stump[varName] = !stump[varName];
		w.obj.curWindow(w);
	}
	
	static function addCycleOption(options, name, stump, varName, values) {
		options.push(name + ": " + values[stump[varName]]);
		options.push([Utils.cycleVar, stump, varName, values]);
	}
	
	static function cycleVar(w, stump, varName, values) {
		stump[varName]++;
		stump[varName] %= values.length;
		w.obj.curWindow(w);
	}
	
	static function bruteforcingWindow(w) {
		w.updateMainField({
			title: "Bruteforcing",
			curWindow: Utils.bruteforcingWindow,
			options: [
				"Copy collision data 📋", Utils.copyCollisionData,
				"Back", Utils.mainMenu
			]
		});
	}
	
	static function copyCollisionData(w) {
		var collisionData = [];
		var y = 0;
		while (y < com.nitrome.toxic.Global.level_height) {
			var xcol = 0;
			while (xcol < com.nitrome.toxic.Global.level_cols) {
				var curInt = 0;
				var xmod = 0;
				while (xmod < 32) {
					if (_root.game.getSceneryCollision(xcol * 32 + xmod, y)) {
						curInt |= 1 << xmod;
					}
					xmod++;
				}
				collisionData.push(curInt);
				xcol++;
			}
			y++;
		}
		
		System.setClipboard(collisionData.toString());
	}
	
	static function toggleMask(w) {
		Utils.masked = !Utils.masked;
		if (Utils.masked) {
			_root.setMask(mask);
		} else {
			_root.setMask(null);
		}
		
		w.obj.curWindow(w);
	}
	
	static function preferenceWindow(w) {
		var obj = {
			title: "Preferences",
			curWindow: Utils.preferenceWindow,
			options: []
		}
		
		Utils.addToggleVarOptions(obj.options, [
			"Perf optimizations", Utils, "perf",
			"Auto scroll", Utils, "autoScroll",
			"Screenshake", Utils, "screenshake"
		]);

		obj.options.push("Back", Utils.mainMenu);
		
		w.updateMainField(obj);
	}
	
	static function infoWindowsWindow(w) {
		var options = [];
		for (var i = 0; i < Utils.visWindowArray.length; i += 3) {
			options.push(Utils.visWindowArray[i] + " visualization 🗗", [Utils.activateStaticWindow, Windows.clip[Utils.visWindowArray[i] + "VisWindow"]]);
		}
		
		options.push("Back", Utils.mainMenu);
		
		w.updateMainField({
			title: "Info windows",
			curWindow: Utils.infoWindowsWindow,
			options: options
		});
	}
	
	static function activateStaticWindow(w, w2) {
		w2._visible = true;
	}
	
	static function updateVisBitmap(n, source_bmp) {
		var dest_bmp = Utils.bmps[n];
		if (!TAS.fastPlayback && Windows.clip[n+"VisWindow"]._visible) {
			dest_bmp.copyPixels(Utils.empty_bmp, new flash.geom.Rectangle(0, 0, dest_bmp.width, dest_bmp.height), zeroPoint);
			dest_bmp.copyPixels(source_bmp, new flash.geom.Rectangle(0, 0, source_bmp.width, source_bmp.height), zeroPoint);
		}
	}
	
	static function layerVisibilityWindow(w) {
		for (var holder in _root.game) {
			if (holder.slice(-7) == "_holder")
				_root.game[holder]._visible = Utils.layerVisibilities[holder];
		}
		
		var obj = {
			title: "Layer visibility",
			curWindow: Utils.layerVisibilityWindow,
			options: []
		}
		
		var arr = [];
		
		for (var holder in _root.game) {
			if (holder.slice(-7) == "_holder")
				arr.push(holder.slice(0, -7), Utils.layerVisibilities, holder);
		}
		
		obj.options.push("Extra", Utils.extraLayerVisibilityWindow);
		
		obj.options.push("Back", Utils.mainMenu);
		
		Utils.addToggleVarOptions(obj.options, arr);
		
		w.updateMainField(obj);
	}
	
	static function extraLayerVisibilityWindow(w) {
		for (var layer in Utils.extraLayerVisibilities) {
			_root[layer]._visible = Utils.extraLayerVisibilities[layer];
		}
		
		var obj = {
			title: "Extra layer visibility",
			curWindow: Utils.extraLayerVisibilityWindow,
			options: []
		}
		
		var arr = [];
		
		for (var layer in Utils.extraLayerVisibilities) {
			arr.push(layer, Utils.extraLayerVisibilities, layer);
		}
		
		obj.options.push("Back", Utils.layerVisibilityWindow);
		
		obj.options.push("Mask: " + (Utils.masked? "on" : "off"), Utils.toggleMask);
		
		Utils.addToggleVarOptions(obj.options, arr);
		
		w.updateMainField(obj);
	}
}