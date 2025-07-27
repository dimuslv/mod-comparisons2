class TAS
{
	static var write = true;
	static var frozen = true;
	static var curString = "";
	static var curArray = ["i", 0, -1];
	static var curIndex = 0;
	static var curFrame = 0;
	static var fastPlayback = false;
	static var neutralPlayback = false;
	static var saveStates = [];
	static var justPlacedBombs;
	static var justPause;
	static var inputField;

	static function updateVarWindow(w) {
		var p = _root.game.player;
		w.behaviorObject.optionLabels = [
			"x: " + p._x,
			"y: " + p._y,
			"vx: " + p.vx,
			"vy: " + p.vy,
			"wc: " + p.wall_count,
			"hc: " + p.hit_count,
			"st: " + ["start", "stand", "duck", "walk", "jump", "fall", "wall", "hit", "die", "end"][p.state]
		];
		
		w.updateMainField(false);
	}

	static function doKeyDown(code) {
		if (TAS.doTasKeyDown(code)) {
			return;
		}
		
		if (TAS.write || true) {
			if (code == 37 || code == 65) {
				com.nitrome.toxic.Global.LAST_DIR_PRESSED = com.nitrome.toxic.Global.LEFT;
			} else if (code == 39 || code == 68) {
				com.nitrome.toxic.Global.LAST_DIR_PRESSED = com.nitrome.toxic.Global.RIGHT;
			} else if (code == 32 || code == 66) {
				TAS.justPlacedBombs++;
			} else if (code == 78) {
				if (TAS.justPlacedBombs > 0) {
					TAS.justPlacedBombs--;
				}
			} else if (code == 80) {
				TAS.justPause = !TAS.justPause;
			}
		}
	}

	static function doTasKeyDown(code) {
		if (code == 13) { //Enter
			TAS.loadInputs(false);
			return true;
		}
		if (TAS.foif()) {
			if (code == 27 || code == 112) { //Esc, F1
				Windows.nullFocus();
				TAS.loadInputs(false);
			} else if (code == 221) { //]
				TAS.loadInputs(true);
			} else if (code == 219) { //[
				TAS.loadInputs(true);
				Windows.nullFocus();
			}
			return true;
		}
		
		if (code == 113) { //F2
			_root.popup_holder.clip.key_button.clearKeyListener();
			_root.mc.startMenuMusic(false);
			//_root.inputField.text = "";
			//_root.curString = "";
			//_root.curArray = ["i", 0, -1];
			//_root.curIndex = 0;
			//_root.curFrame = 0;
			if(!_root.game.level_number) {
				_root.tt.doTween("title_screen");
			} else {
				_root.tt.doTween("map");
			}
		}
		if (code == 67) { //c
			Windows.clip.varWindow._visible = !Windows.clip.varWindow._visible;
			return true;
		}
		if (code == 73) { //i
			Windows.clip.inputWindow._visible = !Windows.clip.inputWindow._visible;
			//Windows.nullFocus();
			return true;
		}
		if (code == 191) { ///
			TAS.write = true;
			TAS.frozen = !TAS.frozen;
			return true;
		}
		if (code == 190) { //.
			TAS.frozen = true;
			TAS.write = true;
			Main.gameUpdate();
			TAS.updateText();
			Main.stopAll();
			return true;
		}
		if (code == 188) { //,
			TAS.frozen = true;
			TAS.write = true;
			if (TAS.curIndex > 0) {
				TAS.curFrame--;
				if (TAS.curFrame <= 0) {
					do {
						TAS.curIndex -= 3;
					} while ("rb".indexOf(TAS.curArray[TAS.curIndex]) != -1);
					
					TAS.curFrame = TAS.curArray[TAS.curIndex + 1];
				}
				TAS.truncateCurArray();
				_root.tt.doTween("reload");
			}
			return true;
		}
		if (code == 222) { //'
			TAS.write = false;
			TAS.frozen = !TAS.frozen;
			return true;
		}
		if (code == 186) { //;
			TAS.frozen = true;
			TAS.write = false;
			if (TAS.curIndex < TAS.curArray.length - 3 || TAS.curFrame < TAS.curArray[TAS.curArray.length - 2]) {
				Main.gameUpdate();
				TAS.updateText();
				Main.stopAll();
			}
			return true;
		}
		if (code == 76) { //l
			TAS.frozen = true;
			TAS.write = false;
			if (TAS.curIndex > 0) {
				TAS.curFrame--;
				if (TAS.curFrame <= 0) {
					do {
						TAS.curIndex -= 3;
					} while ("rb".indexOf(TAS.curArray[TAS.curIndex]) != -1);
					
					TAS.curFrame = TAS.curArray[TAS.curIndex + 1];
				}
				
				_root.tt.doTween("reload");
			}
			return true;
		}
		if (code == 82) { //r
			TAS.curIndex = 0;
			TAS.curFrame = TAS.curArray[1];
			//write = false;
			//frozen = false;
			_root.tt.doTween("reload");
			return true;
		}
		if (code >= 48 && code <= 57) { //0..9
			if (Key.isDown(16)) { //Shift
				TAS.saveStates[code-48] = TAS.inputField.text;
			} else if (TAS.saveStates[code-48]) {
				TAS.inputField.text = TAS.saveStates[code-48];
				TAS.loadInputs(false);
			}
			return true;
		}
		return false;
	}

	static function truncateCurArray() {
		TAS.curArray.length = TAS.curIndex + 3;
		TAS.curArray[TAS.curIndex + 1] = TAS.curFrame;
		if (TAS.curIndex == 0) {
			if (TAS.curArray[2] == -1) {
				TAS.curString = "";
			} else {
				TAS.curString = TAS.curString.slice(0, TAS.curArray[2]) + "r" + TAS.curArray[1];
			}
		} else {
			TAS.curString = TAS.curString.slice(0, TAS.curArray[TAS.curIndex + 2]) + TAS.curArray[TAS.curIndex] + ((TAS.curFrame == 1)? "" : TAS.curFrame);
		}
	}

	static function loadInputs(useCaretPos) {
		var newArray = [];
		var newIndex = -3;
		var newFrame = 0;
		var newString = "";
		
		var sectionBeginning = 0;
		var lettersLost = 0;
		
		var str = TAS.inputField.text;
		
		var caretPos = Selection.getCaretIndex();
		var caretInd = -3;
		
		var i = 0;
		while (i < str.length && "qweasdQWEADnbrp|".indexOf(str.charAt(i)) == -1) {
			i++;
		}
		while (i < str.length) {
			
			var symbol = str.charAt(i);
			var pos = i;
			var num = 0;
			var lastNumPos = i;
			
			i++;
			while (i < str.length && "qweasdQWEADnbrp|".indexOf(str.charAt(i)) == -1) {
				if (str.charCodeAt(i) >= 48 && str.charCodeAt(i) <= 57) {
					num = num * 10 + str.charCodeAt(i) - 48;
					lastNumPos = i;
				}
				i++;
			}
			
			if (symbol == "|") {
				newIndex = newArray.length;
				newFrame = num;
				newString += str.slice(sectionBeginning, pos);
				sectionBeginning = lastNumPos + 1;
				lettersLost += lastNumPos + 1 - pos;
			} else {
				if (symbol != "r" && num == 0) {
					num = 1;
				}
				
				if (newArray.length == 0) {
					if (symbol == "r") {
						newArray = ["i", num, pos - lettersLost];
					} else {
						newArray = ["i", 0, -1, symbol, num, pos - lettersLost];
					}
				} else {
					newArray.push(symbol, num, pos - lettersLost);
				}
				
				if (caretInd == -3 && caretPos <= lastNumPos) {
					caretInd = Math.max(0, newArray.length - 6);
				}
			}
		}
		newString += str.slice(sectionBeginning);
		
		if (newArray.length == 0) {
			newArray = ["i", 0, -1];
			newIndex = 0;
			newFrame = 0;
		} else {
			if ("rb".indexOf(newArray[newArray.length-3]) != -1) {
				newArray.push("n", 1, newString.length);
				newString += "n";
			}
			
			if (useCaretPos) {
				newIndex = caretInd;
				if (caretInd == -3) {
					newIndex = newArray.length - 3;
				}
				newFrame = newArray[newIndex + 1];
			} else {
				if (newIndex == -3 || newIndex == newArray.length) {
					newIndex = newArray.length - 3;
					newFrame = newArray[newIndex + 1];
				} else if (newIndex == 0) {
					newFrame = newArray[1];
				} else if (newFrame == 0) {
					newIndex -= 3;
					newFrame = newArray[newIndex + 1];
				} else {
					newFrame = Math.min(newFrame, newArray[newIndex + 1]);
				}
			}
			
			if ("rb".indexOf(newArray[newIndex]) != -1) {
				while ("rb".indexOf(newArray[newIndex]) != -1) {
					newIndex -= 3;
				}
				newFrame = newArray[newIndex + 1];
			}
		}
		
		var areEqual = true;
		
		if (TAS.curIndex == newIndex && TAS.curFrame == newFrame) {
			i = 0;
			while (i < newIndex) {
				if (TAS.curArray[i] != newArray[i] || TAS.curArray[i+1] != newArray[i+1]) {
					areEqual = false;
					break;
				}
				i += 3;
			}
			if (TAS.curArray[newIndex] != newArray[newIndex]) {
				areEqual = false;
			}
		} else {
			areEqual = false;
		}
		
		TAS.curArray = newArray;
		TAS.curString = newString;
		TAS.curIndex = newIndex;
		TAS.curFrame = newFrame;
		
		if (!areEqual) {
			_root.tt.doTween("reload");
		} else {
			TAS.updateText();
		}
	}

	static function updateText() {
		var newText;
		
		if (TAS.curIndex == TAS.curArray.length - 3 && TAS.curFrame == TAS.curArray[TAS.curArray.length - 2]) {
			newText = TAS.curString;
		} else if (TAS.curFrame == TAS.curArray[TAS.curIndex + 1]) {
			newText = TAS.curString.slice(0, TAS.curArray[TAS.curIndex + 5]) + "|" + TAS.curString.slice(TAS.curArray[TAS.curIndex + 5]);
		} else {
			newText = TAS.curString.slice(0, TAS.curArray[TAS.curIndex + 2]) + "|" + TAS.curFrame + TAS.curString.slice(TAS.curArray[TAS.curIndex + 2]);
		}
		
		TAS.inputField.text = newText;
	}

	static function foif() {
		return Selection.getFocus() == "_level0.window_clip.inputWindow.inputField";
	}

	static function checkKeys() {
		if (TAS.neutralPlayback) {
			return;
		}
		
		if (TAS.write) {
			var prevUp = com.nitrome.toxic.Global.UP_PRESSED;
			
			if (TAS.foif()) {
				com.nitrome.toxic.Global.DIR_PRESSED = -1;
				com.nitrome.toxic.Global.UP_PRESSED = false;
				com.nitrome.toxic.Global.DOWN_PRESSED = false;
			} else {
				if ((Key.isDown(37) || Key.isDown(65)) && (Key.isDown(39) || Key.isDown(68))) {
					if (com.nitrome.toxic.Global.LAST_DIR_PRESSED == com.nitrome.toxic.Global.LEFT) {
						com.nitrome.toxic.Global.DIR_PRESSED = com.nitrome.toxic.Global.LEFT;
					} else if (com.nitrome.toxic.Global.LAST_DIR_PRESSED == com.nitrome.toxic.Global.RIGHT) {
						com.nitrome.toxic.Global.DIR_PRESSED = com.nitrome.toxic.Global.RIGHT;
					}
				} else if (Key.isDown(37) || Key.isDown(65)) {
					com.nitrome.toxic.Global.DIR_PRESSED = com.nitrome.toxic.Global.LEFT;
				} else if (Key.isDown(39) || Key.isDown(68)) {
					com.nitrome.toxic.Global.DIR_PRESSED = com.nitrome.toxic.Global.RIGHT;
				} else {
					com.nitrome.toxic.Global.DIR_PRESSED = -1;
				}
				
				com.nitrome.toxic.Global.UP_PRESSED = Key.isDown(38) || Key.isDown(87);
				com.nitrome.toxic.Global.DOWN_PRESSED = Key.isDown(40) || Key.isDown(83);
			}
			
			if (prevUp && !com.nitrome.toxic.Global.UP_PRESSED) {
				com.nitrome.toxic.Global.can_jump = true;
			}
			
			var letter = "nadwqesADWQE".charAt(com.nitrome.toxic.Global.DIR_PRESSED + 1 + int(com.nitrome.toxic.Global.UP_PRESSED) * 3 + int(com.nitrome.toxic.Global.DOWN_PRESSED) * 6);
			if (TAS.justPause) {
				letter = "p";
			}
			
			if (TAS.curIndex == -3) {
				TAS.curArray = [letter, 1, 0];
				TAS.curString = letter;
				TAS.curIndex = 0;
				TAS.curFrame = 1;
			} else {
				TAS.truncateCurArray();
				
				if (TAS.justPlacedBombs > 0) {
					var i = 0;
					while (i < TAS.justPlacedBombs) {
						_root.game.layBomb();
						i++;
					}
					TAS.curArray.push("b", TAS.justPlacedBombs, TAS.curString.length);
					TAS.curIndex += 3;
					TAS.curFrame = TAS.justPlacedBombs;
					TAS.curString += "b" + ((TAS.justPlacedBombs > 1)? TAS.justPlacedBombs : "");
				}
				
				if (letter == TAS.curArray[TAS.curIndex]) {
					TAS.curArray[TAS.curIndex + 1]++;
					TAS.curFrame++;
					TAS.curString = TAS.curString.slice(0, TAS.curArray[TAS.curIndex + 2]) + TAS.curArray[TAS.curIndex] + TAS.curFrame;
				} else {
					TAS.curArray.push(letter, 1, TAS.curString.length);
					TAS.curIndex += 3;
					TAS.curFrame = 1;
					TAS.curString += letter;
				}
			}
			
			if (TAS.justPause) {
				if (!com.nitrome.toxic.Global.game_paused) {
					_root.popup_holder.displayPopUp("game_paused");
					_root.game.pauseGame();
				}
			} else if (com.nitrome.toxic.Global.game_paused) {
				_root.game.unpauseGame();
				_root.popup_holder.hidePopUp();
			}
		} else {
			// Assumes that there is something to play!
			if (TAS.curIndex == -3) {
				TAS.curIndex = 0;
				TAS.curFrame = 0;
			} else if (TAS.curFrame >= TAS.curArray[TAS.curIndex + 1]) {
				TAS.curIndex += 3;
				TAS.curFrame = 0;
			}
			
			while (TAS.curArray[TAS.curIndex] == "b" || TAS.curArray[TAS.curIndex] == "r") {
				if (TAS.curArray[TAS.curIndex] == "b") {
					var i = TAS.curFrame; // 0
					while (i < TAS.curArray[TAS.curIndex + 1]) {
						_root.game.layBomb();
						i++;
					}
				} else {
					RNG.rngSeed = TAS.curArray[TAS.curIndex + 1];
				}
				TAS.curIndex += 3;
				TAS.curFrame = 0;
			}
			
			var letter = TAS.curArray[TAS.curIndex];
			
			if (letter == "p") {
				if (!com.nitrome.toxic.Global.game_paused) {
					_root.popup_holder.displayPopUp("game_paused");
					_root.game.pauseGame();
				}
			} else {
				if (com.nitrome.toxic.Global.game_paused) {
					_root.game.unpauseGame();
					_root.popup_holder.hidePopUp();
				}
				
				var num = "nadwqesADWQE".indexOf(letter);
				com.nitrome.toxic.Global.DIR_PRESSED = (num % 3) - 1;
				if (com.nitrome.toxic.Global.UP_PRESSED && num % 6 < 3) {
					com.nitrome.toxic.Global.can_jump = true;
				}
				com.nitrome.toxic.Global.UP_PRESSED = num % 6 >= 3;
				com.nitrome.toxic.Global.DOWN_PRESSED = num >= 6;
			}
			TAS.curFrame++;
		}
	}

	static function levelInit() {
		TAS.justPause = com.nitrome.toxic.Global.game_paused;
		TAS.justPlacedBombs = 0;
		
		var bubArray = [];
		
		for (var j in _root.game.acid_holder) {
			bubArray.push(_root.game.acid_holder[j]);
		}
		
		for (var j in bubArray) {
			var cur = bubArray[j];
			
			if (cur.bubbles) {
				Main._gotoAndPlay(cur.bubbles, RNG._random(267) + 1);
				//trace("Initializing " + cur.bubbles);
			} else if (cur.anim) {
				Main._gotoAndPlay(cur.anim, RNG._random(267) + 1);
				//trace("Initializing " + cur.anim);
			}
		}
		
		com.nitrome.toxic.Global.can_jump = true;
		var oldWrite = TAS.write;
		TAS.write = false;
		var targetIndex = TAS.curIndex;
		var targetFrame = TAS.curFrame;
		TAS.curIndex = 0;
		TAS.curFrame = TAS.curArray[1];
		TAS.fastPlayback = true;
		
		TAS.neutralPlayback = true;
		var i = 0;
		while (i < 109) {
			Main.gameUpdate();
			i++;
		}
		TAS.neutralPlayback = false;
		
		while (TAS.curIndex < targetIndex || (TAS.curIndex == targetIndex && TAS.curFrame < targetFrame)) {
			Main.gameUpdate();
		}
		
		TAS.fastPlayback = false;
		TAS.write = oldWrite;
		
		TAS.updateText();
	}
}