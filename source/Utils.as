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
	
	static var bmps = {};
	
	static function levelInit() {
		if (!Utils.layerVisibilities) {
			Utils.layerVisibilities = {};
			for (var holder in _root.game) {
				if (holder.slice(-7) == "_holder")
					Utils.layerVisibilities[holder] = true;
			}
		} else {
			for (var holder in _root.game) {
				if (holder.slice(-7) == "_holder")
					_root.game[holder]._visible = Utils.layerVisibilities[holder];
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
			"Buggy IL mod physics", Utils, "inaccuratePhysics",
			"Deactivate teleport", Utils, "deactivateTeleport"
		]);
		
		obj.options.push("Mask: " + (Utils.masked? "on" : "off"), Utils.toggleMask);
		
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
			"Perf optimizations", Utils, "perf"
		]);

		obj.options.push("Back", Utils.mainMenu);
		
		w.updateMainField(obj);
	}
	
	static function infoWindowsWindow(w) {
		w.updateMainField({
			title: "Info windows",
			curWindow: Utils.infoWindowsWindow,
			options: [
				"Damage visualization 🗗", [Utils.activateStaticWindow, Windows.clip.DamageVisWindow],
				"Acid visualization 🗗", [Utils.activateStaticWindow, Windows.clip.AcidVisWindow],
				"Object visualization 🗗", [Utils.activateStaticWindow, Windows.clip.ObjectVisWindow],
				"Back", Utils.mainMenu
			]
		});
	}
	
	static function activateStaticWindow(w, w2) {
		w2._visible = true;
	}
	
	static function updateVisBitmap(n, source_bmp) {
		if (!TAS.fastPlayback && Windows.clip[n+"VisWindow"]._visible) {
			Utils.bmps[n].copyPixels(source_bmp, new flash.geom.Rectangle(0, 0, source_bmp.width, source_bmp.height), zeroPoint);
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
				arr.push(holder, Utils.layerVisibilities, holder);
		}
		
		Utils.addToggleVarOptions(obj.options, arr);
		
		obj.options.push("Back", Utils.mainMenu);
		
		w.updateMainField(obj);
	}
}