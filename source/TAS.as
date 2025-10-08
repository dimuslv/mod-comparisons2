class TAS
{
	static var write = true;
	static var override = true;
	static var frozen = false;
	static var curString = "";
	
	static var curIndex = 0;
	static var curFrame = 0;
	
	static var inputArray = ["i"];
	static var valueArray = [0];
	static var indArray = [-1];
	static var endIndArray = [0];
	
	static var fastPlayback = false;
	static var neutralPlayback = false;
	static var saveStates = [];
	static var justPlacedBombs;
	static var justPause;
	static var inputField;
	static var targetIndex;
	static var targetFrame;
	static var delayedCaretIndex = -1;
	
	static var subLetters = "rb";
	
	static var runBack = false;

	static function updateVarWindow(w) {
		var p = _root.game.player;
		w.obj.options = [
			"x: " + p._x, false,
			"y: " + p._y, false,
			"vx: " + p.vx, false,
			"vy: " + p.vy, false,
			"wc: " + p.wall_count, false,
			"hc: " + p.hit_count, false,
			"st: " + ["start", "stand", "duck", "walk", "jump", "fall", "wall", "hit", "die", "end"][p.state], false
		];
		
		w.updateMainField(false);
	}
	
	static function isAtStringEnd() {
		return TAS.curIndex >= TAS.inputArray.length - 1 && TAS.curFrame >= TAS.valueArray[TAS.curIndex];
	}
	
	static function isSubLetter(let) {
		return "rb".indexOf(let) != -1;
	}
	
	static function compact(num) {
		return (num == 1)? "" : num;
	}

	static function doKeyDown(code) {
		if (TAS.doTasKeyDown(code)) {
			return;
		}
		
		if (Utils.doKeyDown(code)) {
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
			if (code == 27 || code == 112) { //Esc F1
				Windows.nullFocus();
				TAS.loadInputs(false);
			} else if (code == 38) { //Up
				TAS.loadInputs(true);
				TAS.delayedCaretIndex = Selection.getCaretIndex();
				Windows.nullFocus();
			} else if (code == 40 || code == 123) { //Down F12
				TAS.loadInputs(true);
				Windows.nullFocus();
			}
			return true;
		}
		
		if (code == 113) { //F2
			_root.popup_holder.clip.key_button.clearKeyListener();
			_root.mc.startMenuMusic(false);
			//TAS.curIndex = 0;
			//TAS.curFrame = TAS.valueArray[0];
			
			if(!_root.game.level_number) {
				_root.tt.doTween("title_screen");
			} else {
				_root.tt.doTween("map");
			}
		}
		if (code == 86) { //v
			Windows.clip.varWindow._visible = !Windows.clip.varWindow._visible;
			return true;
		}
		if (code == 73) { //i
			Windows.clip.inputWindow._visible = !Windows.clip.inputWindow._visible;
			//Windows.nullFocus();
			return true;
		}
		if (code == 84) { //t
			Windows.clip.timerWindow._visible = !Windows.clip.timerWindow._visible;
			return true;
		}
		var i;
		if (code == 191 || code == 222) { /// '
			TAS.write = code == 191;
			TAS.frozen = !TAS.frozen;
			TAS.override = !Key.isDown(16);
			return true;
		}
		if (code == 190 || code == 186 || code == 75) { //. ; k
			if (code != 75)
				TAS.frozen = true;
			TAS.write = code == 190;
			
			i = (code == 75)? 30 : 1;
			if (TAS.write) {
				TAS.override = !Key.isDown(16);
			} else if (Key.isDown(16)) {
				i *= 5;
			}
			
			TAS.fastPlayback = true;
			while (i > 0 && (TAS.write || !TAS.isAtStringEnd())) {
				if (i == 1)
					TAS.fastPlayback = false;
				Main.gameUpdate();
				i--;
			}
			TAS.fastPlayback = false;
			
			TAS.updateText();
			Main.stopAll();
			return true;
		}
		if (code == 188 || code == 76 || code == 74) { //, l j
			if (code != 74)
				TAS.frozen = true;
			TAS.write = code == 188;
			
			i = (code == 74)? 30 : 1;
			if (Key.isDown(16)) {
				i *= 5;
			}
			
			if (TAS.curIndex > 0) {
				while (i > 0 && TAS.curIndex > 0) {
					TAS.curFrame--;
					if (TAS.curFrame <= 0) {
						do {
							TAS.curIndex--;
						} while (TAS.isSubLetter(TAS.inputArray[TAS.curIndex]));
						
						TAS.curFrame = TAS.valueArray[TAS.curIndex];
					}
					i--;
				}
				TAS.runBack = true;
				_root.tt.doTween("reload");
			}
			if (TAS.write)
				TAS.truncateCurArray();
			
			return true;
		}
		
		if (code == 220) { //|
			var caretInd;
			
			if (TAS.isAtStringEnd()) {
				caretInd = TAS.curString.length;
			} else if (TAS.curFrame == TAS.valueArray[TAS.curIndex]) {
				caretInd = TAS.indArray[TAS.curIndex + 1];
			} else {
				caretInd = TAS.indArray[TAS.curIndex];
			}
			
			Selection.setFocus(Windows.clip.inputWindow.inputField);
			Selection.setSelection(caretInd, caretInd);
			Windows.nullFocus();
			return true;
		}
		
		if (code == 46) { //Delete
			TAS.truncateCurArray();
			TAS.updateText();
			return true;
		}
		
		if (code == 82) { //r
			//TAS.curIndex = 0;
			//TAS.curFrame = TAS.valueArray[0];
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
		TAS.inputArray.length = TAS.curIndex + 1;
		TAS.valueArray.length = TAS.curIndex + 1;
		TAS.indArray.length = TAS.curIndex + 1;
		TAS.endIndArray.length = TAS.curIndex + 1;
		
		TAS.valueArray[TAS.curIndex] = TAS.curFrame;
		if (TAS.curIndex == 0) {
			if (TAS.indArray[0] == -1) {
				TAS.curString = "";
			} else {
				TAS.curString = TAS.curString.slice(0, TAS.endIndArray[0]);
			}
		} else {
			TAS.curString = TAS.curString.slice(0, TAS.indArray[TAS.curIndex]) + TAS.inputArray[TAS.curIndex] + TAS.compact(TAS.curFrame);
		}
	}
	
	static function splitCurLetter() {
		if (TAS.curFrame == TAS.valueArray[TAS.curIndex])
			return;
		
		TAS.inputArray.splice(TAS.curIndex + 1, 0, TAS.inputArray[TAS.curIndex]);
		TAS.valueArray.splice(TAS.curIndex + 1, 0, TAS.valueArray[TAS.curIndex]-TAS.curFrame);
		
		TAS.valueArray[TAS.curIndex] = TAS.curFrame;
		
		var newString = TAS.curString.slice(0, TAS.indArray[TAS.curIndex]) + (TAS.inputArray[TAS.curIndex] + TAS.compact(TAS.curFrame));
		
		TAS.indArray.splice(TAS.curIndex + 1, 0, newString.length);
		
		newString += TAS.inputArray[TAS.curIndex+1] + TAS.compact(TAS.valueArray[TAS.curIndex+1]);
		
		TAS.endIndArray.splice(TAS.curIndex + 1, 0, newString.length);
		
		newString += TAS.curString.slice(TAS.endIndArray[TAS.curIndex]);
		
		var i = TAS.curIndex + 2;
		while (i < TAS.inputArray.length) {
			TAS.indArray[i] += TAS.endIndArray[TAS.curIndex+1] - TAS.endIndArray[TAS.curIndex];
			TAS.endIndArray[i] += TAS.endIndArray[TAS.curIndex+1] - TAS.endIndArray[TAS.curIndex];
			i++;
		}
		
		TAS.endIndArray[TAS.curIndex] = TAS.indArray[TAS.curIndex+1];
		
		TAS.curString = newString;
	}

	static function loadInputs(useCaretPos) {
		var newInputArray = ["i"];
		var newValueArray = [0];
		var newIndArray = [-1];
		var newEndIndArray = [0];
		var newIndex = -1;
		var newFrame = -1;
		var newString = TAS.inputField.text;
		
		var caretPos = Selection.getCaretIndex();
		var caretInd = -1;
		
		var i = 0;
		while (i < newString.length && "qweasdQWEADnbrp|".indexOf(newString.charAt(i)) == -1) {
			i++;
		}
		while (i < newString.length) {
			
			var symbol = newString.charAt(i);
			var pos = i;
			var num = 0;
			var endPos = i + 1;
			
			i++;
			while (i < newString.length && "qweasdQWEADnbrp|".indexOf(newString.charAt(i)) == -1) {
				if (newString.charCodeAt(i) >= 48 && newString.charCodeAt(i) <= 57) {
					num = num * 10 + newString.charCodeAt(i) - 48;
					endPos = i + 1;
				}
				i++;
			}
			
			if (symbol == "|") {
				newIndex = newInputArray.length;
				newFrame = num;
				i -= endPos - pos;
				caretPos -= endPos - pos;
				newString = newString.slice(0, pos) + newString.slice(endPos);
			} else {
				if (symbol != "r" && num == 0) {
					num = 1;
				}
				
				if (newInputArray.length == 1 && newIndArray[0] == -1 && symbol == "r") {
					newValueArray[0] = num;
					newIndArray[0] = pos;
					newEndIndArray[0] = endPos;
				} else {
					newInputArray.push(symbol);
					newValueArray.push(num);
					newIndArray.push(pos);
					newEndIndArray.push(endPos);
				}
				
				if (caretInd == -1 && caretPos < endPos) {
					caretInd = Math.max(0, newInputArray.length - 2);
				}
			}
		}
		
		if (TAS.isSubLetter(newInputArray[newInputArray.length-1])) {
			newInputArray.push("n");
			newValueArray.push(1);
			newIndArray.push(newString.length);
			newString += "n";
			newEndIndArray.push(newString.length);
		}
		
		if (useCaretPos) {
			if (caretInd == -1) {
				newIndex = newInputArray.length - 1;
			} else {
				newIndex = caretInd;
			}
			newFrame = newValueArray[newIndex];
		} else {
			if (newIndex == -1 || newIndex == newInputArray.length) {
				newIndex = newInputArray.length - 1;
				newFrame = newValueArray[newIndex];
			} else if (newFrame == 0) {
				newIndex--;
				newFrame = newValueArray[newIndex];
			} else {
				newFrame = Math.min(newFrame, newValueArray[newIndex]);
			}
		}
		
		if (TAS.isSubLetter(newInputArray[newIndex])) {
			while (TAS.isSubLetter(newInputArray[newIndex])) {
				newIndex--;
			}
			newFrame = newValueArray[newIndex];
		}
		
		var areEqual = true;
		
		if (TAS.curIndex == newIndex && TAS.curFrame == newFrame) {
			i = 0;
			while (i < newIndex) {
				if (TAS.inputArray[i] != newInputArray[i] || TAS.valueArray[i] != newValueArray[i]) {
					areEqual = false;
					break;
				}
				i++;
			}
			if (TAS.inputArray[newIndex] != newInputArray[newIndex]) {
				areEqual = false;
			}
		} else {
			areEqual = false;
		}
		
		TAS.inputArray = newInputArray;
		TAS.valueArray = newValueArray;
		TAS.indArray = newIndArray;
		TAS.endIndArray = newEndIndArray;
		TAS.curString = newString;
		TAS.curIndex = newIndex;
		TAS.curFrame = newFrame;
		
		if (!areEqual) {
			TAS.runBack = true;
			_root.tt.doTween("reload");
		} else {
			TAS.updateText();
		}
	}

	static function updateText() {
		var newText;
		
		if (TAS.isAtStringEnd()) {
			newText = TAS.curString;
		} else if (TAS.curFrame == TAS.valueArray[TAS.curIndex]) {
			newText = TAS.curString.slice(0, TAS.indArray[TAS.curIndex+1]) + "|" + TAS.curString.slice(TAS.indArray[TAS.curIndex+1]);
		} else {
			newText = TAS.curString.slice(0, TAS.indArray[TAS.curIndex]) + "|" + TAS.curFrame + TAS.curString.slice(TAS.indArray[TAS.curIndex]);
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
			
			if (TAS.override) {
				TAS.truncateCurArray();
			} else {
				TAS.splitCurLetter();
			}
			
			//var addedLength = 0;
			var endInd = TAS.endIndArray[TAS.curIndex];
			var endString = TAS.curString.slice(endInd);
			TAS.curString = TAS.curString.slice(0, endInd);
			var i;
			
			if (TAS.justPlacedBombs > 0) {
				i = 0;
				while (i < TAS.justPlacedBombs) {
					_root.game.layBomb();
					i++;
				}
				TAS.curIndex++;
				
				TAS.inputArray.splice(TAS.curIndex, 0, "b");
				TAS.valueArray.splice(TAS.curIndex, 0, TAS.justPlacedBombs);
				TAS.indArray.splice(TAS.curIndex, 0, TAS.curString.length);
				
				TAS.curFrame = TAS.justPlacedBombs;
				TAS.curString += "b" + ((TAS.justPlacedBombs > 1)? TAS.justPlacedBombs : "");
				TAS.endIndArray.splice(TAS.curIndex, 0, TAS.curString.length);
			}
			
			if (letter == TAS.inputArray[TAS.curIndex]) {
				TAS.valueArray[TAS.curIndex]++;
				TAS.curFrame++;
				TAS.curString = TAS.curString.slice(0, TAS.indArray[TAS.curIndex]) + TAS.inputArray[TAS.curIndex] + TAS.curFrame;
				TAS.endIndArray[TAS.curIndex] = TAS.curString.length;
			} else {
				TAS.curIndex++;
				
				TAS.inputArray.splice(TAS.curIndex, 0, letter);
				TAS.valueArray.splice(TAS.curIndex, 0, 1);
				TAS.indArray.splice(TAS.curIndex, 0, TAS.curString.length);
				
				TAS.curFrame = 1;
				TAS.curString += letter;
				TAS.endIndArray.splice(TAS.curIndex, 0, TAS.curString.length);
			}
			
			i = TAS.curIndex + 1;
			while (i < TAS.inputArray.length) {
				TAS.indArray[i] += TAS.curString.length - endInd;
				TAS.endIndArray[i] += TAS.curString.length - endInd;
				i++;
			}
			
			TAS.curString += endString;
			
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
			if (TAS.curFrame >= TAS.valueArray[TAS.curIndex]) {
				TAS.curIndex++;
				TAS.curFrame = 0;
			}
			
			while (TAS.inputArray[TAS.curIndex] == "b" || TAS.inputArray[TAS.curIndex] == "r") {
				if (TAS.inputArray[TAS.curIndex] == "b") {
					i = 0;
					while (i < TAS.valueArray[TAS.curIndex]) {
						_root.game.layBomb();
						i++;
					}
				} else {
					RNG.rngSeed = TAS.valueArray[TAS.curIndex];
				}
				TAS.curIndex++;
				TAS.curFrame = 0;
			}
			
			var letter = TAS.inputArray[TAS.curIndex];
			
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
			
			if (TAS.fastPlayback && TAS.curIndex == TAS.targetIndex && TAS.curFrame == TAS.targetFrame) {
				TAS.fastPlayback = false;
			}
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
		TAS.targetIndex = TAS.curIndex;
		TAS.targetFrame = TAS.curFrame;
		TAS.curIndex = 0;
		TAS.curFrame = TAS.valueArray[0];
		TAS.fastPlayback = true;
		
		if (Utils.skipBeginning) {
			TAS.neutralPlayback = true;
			var i = 0;
			while (i < 109) {
				Main.gameUpdate();
				i++;
			}
			TAS.neutralPlayback = false;
		}
		
		if (TAS.runBack) {
			TAS.runBack = false;
			while (TAS.curIndex < TAS.targetIndex || (TAS.curIndex == TAS.targetIndex && TAS.curFrame < TAS.targetFrame)) {
				Main.gameUpdate();
			}
		}
		
		TAS.fastPlayback = false;
		TAS.targetIndex = -1;
		TAS.write = oldWrite;
		
		TAS.updateText();
	}
}