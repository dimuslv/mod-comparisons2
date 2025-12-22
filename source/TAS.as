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
	static var pressedPause;
	static var releasedUp;
	static var pressedHit;
	static var queuedHit = false;
	
	static var inputField;
	static var targetIndex;
	static var targetFrame;
	static var delayedCaretIndex = -1;
	
	static var UP_PRESSED = false;
	static var DOWN_PRESSED = false;
	
	static var runBack = false;
	
	static var subLetters = "rbjJPh";
	static var fullLetters = "qweasdQWEADnp";
	static var letters = TAS.subLetters + TAS.fullLetters;
	static var symbols = TAS.letters + "|";

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
		return TAS.subLetters.indexOf(let) !== -1;
	}
	
	static function isLetter(let) {
		return TAS.letters.indexOf(let) !== -1;
	}
	
	static function isSymbol(let) {
		return TAS.symbols.indexOf(let) !== -1;
	}
	
	static function compact(num) {
		return (num == 1)? "" : num;
	}
	
	static function scrollToCaret() {
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
	}

	static function doKeyDown(code) {
		if (TAS.doTasKeyDown(code)) {
			return;
		}
		
		if (Utils.doKeyDown(code)) {
			return;
		}
		
		if (TAS.write || true) {
			if (code == 38 || code == 87) {
				TAS.UP_PRESSED = true;
			} else if (code == 40 || code == 83) {
				TAS.DOWN_PRESSED = true;
			} else if (code == 37 || code == 65) {
				com.nitrome.toxic.Global.LAST_DIR_PRESSED = com.nitrome.toxic.Global.LEFT;
			} else if (code == 39 || code == 68) {
				com.nitrome.toxic.Global.LAST_DIR_PRESSED = com.nitrome.toxic.Global.RIGHT;
			} else if (code == 32 || code == 66) {
				if (!TAS.justPause) {
					TAS.justPlacedBombs++;
				}
			} else if (code == 78) {
				if (TAS.justPlacedBombs > 0) {
					TAS.justPlacedBombs--;
				}
			} else if (code == 80) {
				TAS.justPause = !TAS.justPause;
				TAS.pressedPause = true;
			} else if (code == 72) {
				TAS.pressedHit = !TAS.pressedHit;
			}
		}
	}
	
	static function doKeyUp(code) {
		if (code == 38 || code == 87) {
			TAS.releasedUp = true;
			TAS.UP_PRESSED = false;
		} else if (code == 40 || code == 83) {
			TAS.DOWN_PRESSED = false;
		}
	}

	static function doTasKeyDown(code) {
		
		if (TAS.foif()) {
			if (code == 27 || code == 112) { //Esc F1
				Windows.nullFocus();
				TAS.loadInputs(false);
			} else if (code == 34) { //PgDn
				TAS.loadInputs(true);
				TAS.delayedCaretIndex = Selection.getCaretIndex();
				Windows.nullFocus();
			} else if (code == 33 || code == 123) { //PgUp F12
				TAS.loadInputs(true);
				Windows.nullFocus();
			} else if (code == 13) { //Enter
				TAS.loadInputs(false);
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
			if (Windows.clip.inputWindow._visible = !Windows.clip.inputWindow._visible) {
				TAS.updateText();
			}
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
			TAS.scrollToCaret();
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
				TAS.updateText(true);
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
		while (i < newString.length && !TAS.isSymbol(newString.charAt(i))) {
			i++;
		}
		while (i < newString.length) {
			
			var symbol = newString.charAt(i);
			var pos = i;
			var num = 0;
			var endPos = i + 1;
			
			i++;
			while (i < newString.length && !TAS.isSymbol(newString.charAt(i))) {
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

	static function updateText(forced) {
		if (!forced && (!Windows.clip.inputWindow._visible || !TAS.inputField._visible)) {
			return;
		}
		
		var textW;
		
		if (TAS.isAtStringEnd()) {
			TAS.inputField.text = TAS.curString;
			textW = TAS.inputField.textWidth;
		} else if (TAS.curFrame == TAS.valueArray[TAS.curIndex]) {
			TAS.inputField.text = TAS.curString.slice(0, TAS.indArray[TAS.curIndex+1]);
			textW = TAS.inputField.textWidth;
			TAS.inputField.text += "|" + TAS.curString.slice(TAS.indArray[TAS.curIndex+1]);
		} else {
			TAS.inputField.text = TAS.curString.slice(0, TAS.indArray[TAS.curIndex]);
			textW = TAS.inputField.textWidth;
			TAS.inputField.text += "|" + TAS.curFrame + TAS.curString.slice(TAS.indArray[TAS.curIndex]);
		}
		
		if (Utils.autoScroll) {
			TAS.inputField.hscroll = (textW - 225) * TAS.inputField.maxhscroll / (TAS.inputField.textWidth - 395);
		}
	}

	static function foif() {
		return Selection.getFocus() == "_level0.window_clip.inputWindow.inputField";
	}

	static function checkKeys() {
		if (TAS.neutralPlayback) {
			return;
		}
		
		if (TAS.write) {
			var DIR_PRESSED = -1;
			var UP_PRESSED = false;
			var DOWN_PRESSED = false;
			
			if (!TAS.foif()) {
				if ((Key.isDown(37) || Key.isDown(65)) && (Key.isDown(39) || Key.isDown(68))) {
					if (com.nitrome.toxic.Global.LAST_DIR_PRESSED == com.nitrome.toxic.Global.LEFT) {
						DIR_PRESSED = com.nitrome.toxic.Global.LEFT;
					} else if (com.nitrome.toxic.Global.LAST_DIR_PRESSED == com.nitrome.toxic.Global.RIGHT) {
						DIR_PRESSED = com.nitrome.toxic.Global.RIGHT;
					}
				} else if (Key.isDown(37) || Key.isDown(65)) {
					DIR_PRESSED = com.nitrome.toxic.Global.LEFT;
				} else if (Key.isDown(39) || Key.isDown(68)) {
					DIR_PRESSED = com.nitrome.toxic.Global.RIGHT;
				} else {
					DIR_PRESSED = -1;
				}
				
				if(!Key.isDown(38) && !Key.isDown(87)) {
					TAS.UP_PRESSED = false;
				}
				if(!Key.isDown(40) && !Key.isDown(83)) {
					TAS.DOWN_PRESSED = false;
				}
				
				UP_PRESSED = TAS.UP_PRESSED;
				DOWN_PRESSED = TAS.DOWN_PRESSED;
			}
			
			if (TAS.override) {
				TAS.truncateCurArray();
			} else {
				TAS.splitCurLetter();
			}
			
			var atEnd = TAS.curIndex === TAS.inputArray.length - 1;
			
			var newInputs;
			var newValues;
			if (!atEnd) {
				newInputs = [TAS.curIndex + 1, 0];
				newValues = [TAS.curIndex + 1, 0];
			} else {
				newInputs = TAS.inputArray;
				newValues = TAS.valueArray;
			}
			
			var startLen = newInputs.length;
			
			if (TAS.justPause) {
				UP_PRESSED = com.nitrome.toxic.Global.UP_PRESSED;
			}
			
			if (!TAS.frozen && !com.nitrome.toxic.Global.can_jump) {
				if ((com.nitrome.toxic.Global.UP_PRESSED && !UP_PRESSED) !== TAS.releasedUp) {
					if (TAS.releasedUp) {
						newInputs.push("j");
					} else {
						newInputs.push("J");
					}
					newValues.push(1);
				}
			}
			
			if (TAS.justPlacedBombs > 0) {
				newInputs.push("b");
				newValues.push(TAS.justPlacedBombs);
			}
			if (TAS.pressedHit) {
				newInputs.push("h");
				newValues.push(1);
			}
			if (com.nitrome.toxic.Global.game_paused === TAS.justPause && TAS.pressedPause) {
				if (TAS.justPlacedBombs <= 0 || !TAS.justPause) {
					newInputs.push("P");
					newValues.push(1);
				}
			}
			
			var letter = "nadwqesADWQE".charAt(DIR_PRESSED + 1 + int(UP_PRESSED) * 3 + int(DOWN_PRESSED) * 6);
			if (TAS.justPause) {
				letter = "p";
			}
			
			var endInd = TAS.endIndArray[TAS.curIndex];
			var endString = TAS.curString.slice(endInd);
			TAS.curString = TAS.curString.slice(0, endInd);
			
			if (newInputs.length === startLen && letter === TAS.inputArray[TAS.curIndex]) {
				TAS.valueArray[TAS.curIndex]++;
				TAS.curString = TAS.curString.slice(0, TAS.indArray[TAS.curIndex]) + TAS.inputArray[TAS.curIndex] + TAS.valueArray[TAS.curIndex];
				TAS.endIndArray[TAS.curIndex] = TAS.curString.length;
			} else {
				newInputs.push(letter);
				newValues.push(1);
				if (!atEnd) {
					TAS.inputArray.splice.apply(TAS.inputArray, newInputs);
					TAS.valueArray.splice.apply(TAS.valueArray, newValues);
				}
				
				var newInds;
				var newEndInds
				if (!atEnd) {
					newInds = [TAS.curIndex + 1, 0];
					newEndInds = [TAS.curIndex + 1, 0];
				} else {
					newInds = TAS.indArray;
					newEndInds = TAS.endIndArray;
				}
				
				for (var i = startLen; i < newInputs.length; i++) {
					newInds.push(TAS.curString.length);
					TAS.curString += newInputs[i] + TAS.compact(newValues[i]);
					newEndInds.push(TAS.curString.length);
				}
				
				if (!atEnd) {
					TAS.indArray.splice.apply(TAS.indArray, newInds);
					TAS.endIndArray.splice.apply(TAS.endIndArray, newEndInds);
				}
			}
			
			if (!atEnd) {
				for (var i = TAS.curIndex + newInputs.length - 1; i < TAS.indArray.length; i++) {
					TAS.indArray[i] += TAS.curString.length - endInd;
					TAS.endIndArray[i] += TAS.curString.length - endInd;
				}
			}
			
			TAS.curString += endString;
		}
		
		// Assumes that there is something to play!
		if (TAS.curFrame >= TAS.valueArray[TAS.curIndex]) {
			TAS.curIndex++;
			TAS.curFrame = 0;
		}
		
		var didntReleaseUp = false;
		
		while (TAS.isSubLetter(TAS.inputArray[TAS.curIndex])) {
			switch (TAS.inputArray[TAS.curIndex]) {
				case "b":
					if (com.nitrome.toxic.Global.game_paused) {
						_root.game.unpauseGame();
						_root.popup_holder.hidePopUp();
					}
					for (var i = 0; i < TAS.valueArray[TAS.curIndex]; i++) {
						_root.game.layBomb();
					}
					break;
				case "r":
					RNG.rngSeed = TAS.valueArray[TAS.curIndex];
					break;
				case "j":
					com.nitrome.toxic.Global.can_jump = true;
					break;
				case "J":
					didntReleaseUp = true;
					break;
				case "P":
					_root.popup_holder.displayPopUp("game_paused");
					_root.game.pauseGame();
					break;
				case "h":
					TAS.queuedHit = true;
					break;
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
			if (com.nitrome.toxic.Global.UP_PRESSED && num % 6 < 3 && !didntReleaseUp) {
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
	
	static function performQueuedHit() {
		if (TAS.queuedHit) {
			_root.game.player.startHit();
		}
	}
	
	static function resetInputCheckers() {
		TAS.justPause = com.nitrome.toxic.Global.game_paused;
		TAS.pressedPause = false;
		TAS.releasedUp = false;
		TAS.pressedHit = false;
		TAS.justPlacedBombs = 0;
		
		TAS.queuedHit = false;
	}

	static function levelInit() {
		TAS.resetInputCheckers();
		
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