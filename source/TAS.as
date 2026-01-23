class TAS
{
	static var write = true;
	static var override = true;
	static var frozen = false;
	static var curString = "";
	
	static var curIndex = 0;
	static var curFrame = 0;
	
	static var totalFrame;
	
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
	static var delayedCaretPos = -1;
	static var lastCaretPos = -1;
	
	static var offsetField;
	static var offsetObj = {};
	static var offsetString = "";
	static var initializeOffset = false;
	static var curPattern = 0;
	static var curPatternInd = 0;
	static var curPatternFrame = 0;
	
	static var UP_PRESSED = false;
	static var DOWN_PRESSED = false;
	
	static var runBack = false;
	
	static var subLetters = "rbjJPh";
	static var fullLetters = "qweasdQWEADnp";
	static var letters = TAS.subLetters + TAS.fullLetters;
	static var symbols = TAS.letters + "|>,.";
	
	static var keysDown = {};
	static var importantKeycodes = TAS.getImportantKeycodes();
	
	static function getImportantKeycodes() {
		var obj = {};
		var arr = [37, 38, 39, 40, 87, 65, 83, 68, 32];
		for (var i in arr) {
			obj[arr[i]] = true;
		}
		return obj;
	}

	static function updateVarWindow(w) {
		var p = _root.game.player;
		w.obj.options = [
			"x: " + p._x, false,
			"y: " + p._y, false,
			"vx: " + p.vx, false,
			"vy: " + p.vy, false,
			"wc: " + p.wall_count, false,
			"hc: " + p.hit_count, false,
			"st: " + ["start", "stand", "duck", "walk", "jump", "fall", "wall", "hit", "die", "end"][p.state], false,
			"dir: " + ["l", "r"][p.dir], false
		];
		
		w.updateMainField(false);
	}
	
	static function isAtStringEnd() {
		return TAS.curIndex >= TAS.inputArray.length - 1 && TAS.curFrame >= TAS.valueArray[TAS.curIndex];
	}
	
	static function isS(sym, str) {
		return str.indexOf(sym) !== -1;
	}
	
	static function isSubLetter(let) {
		return TAS.isS(let, TAS.subLetters);
	}
	
	static function isFullLetter(let) {
		return TAS.isS(let, TAS.fullLetters);
	}
	
	static function isLetter(let) {
		return TAS.isS(let, TAS.letters);
	}
	
	static function isSymbol(let) {
		return TAS.isS(let, TAS.symbols);
	}
	
	static function isKeyLetter(let) {
		return TAS.isS(let, "wasdWASDlruvLRUVb");
	}
	
	static function compact(num) {
		return (num == 1)? "" : num;
	}
	
	static function clearOffsets(arr) {
		for (var i = 3; i < arr.length; i += 4) {
			arr[i] = 0;
		}
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
		
		Selection.setFocus(TAS.inputField);
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
			
			if (TAS.importantKeycodes[code]) {
				if (!TAS.keysDown[code] && TAS.write && TAS.offsetObj.hasOwnProperty(TAS.curPattern)) {
					TAS.hitOffset(code);
				}
				TAS.keysDown[code] = true;
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
		
		if (TAS.importantKeycodes[code]) {
			if (TAS.write && TAS.offsetObj.hasOwnProperty(TAS.curPattern)) {
				TAS.hitOffset(-code);
			}
			TAS.keysDown[code] = false;
		}
	}

	static function doTasKeyDown(code) {
		
		if (Utils.foif()) {
			if (Selection.getFocus() == "_level0.window_clip.inputWindow.inputField") {
				if (code == 27 || code == 112) { //Esc F1
					TAS.lastCaretPos = -1;
					Windows.nullFocus();
				} else if (code == 34) { //PgDn
					TAS.lastCaretPos = Selection.getCaretIndex();
					TAS.delayedCaretPos = Selection.getCaretIndex();
					Windows.nullFocus();
				} else if (code == 33 || code == 123) { //PgUp F12
					TAS.lastCaretPos = Selection.getCaretIndex();
					Windows.nullFocus();
				} else if (code == 13) { //Enter
					TAS.loadInputs(-1);
				}
			} else if (code == 27 || code == 112) { //Esc F1
				Windows.nullFocus();
			}
			return true;
		}
		
		var i;
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
		} else if (code == 86) { //v
			Windows.clip.varWindow._visible = !Windows.clip.varWindow._visible;
		} else if (code == 73) { //i
			if (Windows.clip.inputWindow._visible = !Windows.clip.inputWindow._visible) {
				TAS.updateText();
			}
			//Windows.nullFocus();
		} else if (code === 79) { //o
			Windows.clip.inputWindow._visible = true;
			TAS.updateText();
			
			TAS.offsetField._visible = !TAS.offsetField._visible;
			if (TAS.offsetField._visible) {
				Windows.clip.offsetBarsWindow._visible = true;
			}
		} else if (code == 84) { //t
			Windows.clip.timerWindow._visible = !Windows.clip.timerWindow._visible;
		} else if (code == 191 || code == 222) { /// '
			TAS.write = code == 191;
			TAS.frozen = !TAS.frozen;
			TAS.override = !Key.isDown(16);
		} else if (code == 190 || code == 186 || code == 75) { //. ; k
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
		} else if (code == 188 || code == 76 || code == 74) { //, l j
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
			
		} else if (code == 220) { //|
			TAS.scrollToCaret();
		} else if (code == 46) { //Delete
			TAS.truncateCurArray();
			TAS.updateText();
		} else if (code == 82) { //r
			//TAS.curIndex = 0;
			//TAS.curFrame = TAS.valueArray[0];
			//write = false;
			//frozen = false;
			_root.tt.doTween("reload");
		} else if (code >= 48 && code <= 57) { //0..9
			if (Key.isDown(16)) { //Shift
				TAS.updateText(true);
				TAS.saveStates[code-48] = TAS.inputField.text;
			} else if (TAS.saveStates[code-48]) {
				TAS.inputField.text = TAS.saveStates[code-48];
				TAS.loadInputs(-1);
			}
		} else {
			return false;
		}
		return true;
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

	static function parseInputString(str, caretPos) {
		var newInputArray = ["i"];
		var newValueArray = [0];
		var newIndArray = [-1];
		var newEndIndArray = [0];
		var newIndex = -1;
		var newFrame = -1;
		var newString = str;
		
		var useCaretPos = false;
		if (caretPos >= 0) useCaretPos = true;
		var caretInd = -1;
		
		var offsetArr = [[0]];
		
		var totalFrame = 0;
		
		var dotNum = -1;
		
		var i = 0;
		while (i < newString.length && !TAS.isSymbol(newString.charAt(i))) {
			i++;
		}
		while (i < newString.length) {
			
			var symbol = newString.charAt(i);
			var pos = i;
			var num = 0;
			var endPos = i + 1;
			
			var linNum = 0;
			var commaLetter = "";
			
			
			i++;
			while (i < newString.length) {
				var curSymbol = newString.charAt(i);
				
				if (newString.charCodeAt(i) >= 48 && newString.charCodeAt(i) <= 57) {
					num = num * 10 + newString.charCodeAt(i) - 48;
					endPos = i + 1;
				} else if (symbol === "," && !commaLetter) {
					if (TAS.isKeyLetter(curSymbol)) {
						commaLetter = curSymbol;
					} else if (curSymbol === ",") {
						linNum += num? num : 1;
						num = 0;
					}
				} else if (symbol === "." && curSymbol === ".") {
					linNum += num? num : 1;
					num = 0;
				} else if (TAS.isSymbol(curSymbol)) {
					break;
				}
				
				i++;
			}
			
			if (!TAS.isS(symbol, "|>r") && !num) {
				num = 1;
			}
			num += linNum;
			
			if (symbol == "|") {
				newIndex = newInputArray.length;
				newFrame = num;
				i -= endPos - pos;
				caretPos -= endPos - pos;
				newString = newString.slice(0, pos) + newString.slice(endPos);
			} else if (symbol === ">") {
				if (totalFrame != Utils.getLast(offsetArr)[0]) {
					offsetArr.push([totalFrame]);
				}
			} else if (symbol === ",") {
				if (commaLetter) {
					var letterNum = {w: 87, a: 65, s: 83, d: 68, u: 38, l: 37, v: 40, r: 39, b: 32}[commaLetter.toLowerCase()];
					if (commaLetter !== commaLetter.toLowerCase()) {
						letterNum *= -1;
					}
					Utils.pushO(offsetArr, totalFrame, letterNum, num);
				}
			} else if (symbol === ".") {
				dotNum = num;
			} else {
				
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
				
				if (TAS.isFullLetter(symbol)) {
					if (dotNum !== -1) {
						var prevFullLetter = "n";
						for (var j = newInputArray.length - 2; j >= 0; j--) {
							if (TAS.isFullLetter(newInputArray[j])) {
								prevFullLetter = newInputArray[j];
								break;
							}
						}
						
						if (prevFullLetter === "p") {
							if (symbol !== "p") {
								Utils.pushO(offsetArr, totalFrame, 6, dotNum);
							}
						} else if (symbol === "p") {
							Utils.pushO(offsetArr, totalFrame, 7, dotNum);
						} else {
							var inpStates = [];
							for (var j = 0; j < 2; j++) {
								var letterNum = "nadwqesADWQE".indexOf([prevFullLetter, symbol][j]);
								inpStates.push(letterNum % 3 - 1, letterNum % 6 >= 3, letterNum >= 6);
							}
							
							for (var j = 0; j < 3; j++) {
								if (inpStates[j] !== inpStates[3 + j]) {
									Utils.pushO(offsetArr, totalFrame, j? 2*j + (inpStates[3 + j]? 1 : 0) : inpStates[3 + j], dotNum);
								}
							}
						}
						
						dotNum = -1;
					}
					
					totalFrame += num;
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
		
		return {
			inputArray: newInputArray,
			valueArray: newValueArray,
			indArray: newIndArray,
			endIndArray: newEndIndArray,
			curString: newString,
			curIndex: newIndex,
			curFrame: newFrame,
			offsetArr: offsetArr
		};
	}
	
	static function loadInputs(caretPos) {
		var obj = TAS.parseInputString(TAS.inputField.text, caretPos);
		
		var areEqual = true;
		
		if (TAS.curIndex == obj.curIndex && TAS.curFrame == obj.curFrame) {
			i = 0;
			while (i < obj.curIndex) {
				if (TAS.inputArray[i] != obj.inputArray[i] || TAS.valueArray[i] != obj.valueArray[i]) {
					areEqual = false;
					break;
				}
				i++;
			}
			if (TAS.inputArray[obj.curIndex] != obj.inputArray[obj.curIndex]) {
				areEqual = false;
			}
		} else {
			areEqual = false;
		}
		
		TAS.inputArray = obj.inputArray;
		TAS.valueArray = obj.valueArray;
		TAS.indArray = obj.indArray;
		TAS.endIndArray = obj.endIndArray;
		TAS.curString = obj.curString;
		TAS.curIndex = obj.curIndex;
		TAS.curFrame = obj.curFrame;
		
		if (!areEqual) {
			TAS.runBack = true;
			_root.tt.doTween("reload");
		} else {
			TAS.updateText();
		}
	}
	
	static function loadOffsets() {
		if (TAS.offsetString === TAS.offsetField.text) {
			return;
		}
		TAS.offsetString = TAS.offsetField.text;
		
		var obj = TAS.parseInputString(TAS.offsetString, -1);
		
		TAS.offsetObj = {};
		
		for (var i = 0; i < obj.offsetArr.length; i++) {
			TAS.offsetObj[obj.offsetArr[i].shift()] = obj.offsetArr[i];
		}
		
		if (obj.offsetArr.length > 1) {
			TAS.inputArray = obj.inputArray;
			TAS.valueArray = obj.valueArray;
			TAS.indArray = obj.indArray;
			TAS.endIndArray = obj.endIndArray;
			TAS.curString = obj.curString;
			
			TAS.curIndex = TAS.inputArray.length - 1;
			TAS.curFrame = TAS.valueArray[TAS.curIndex];
			
			TAS.initializeOffset = true;
			
			TAS.runBack = true;
			_root.tt.doTween("reload");
		} else {
			//TAS.updateText();
			TAS.updateOffsetBars();
		}
	}
	
	static function updateOffsetBars() {
		var w = Windows.clip.offsetBarsWindow.barsWindow;
		w.text = "";
		
		for (var i in TAS.offsetObj) {
			var curP = TAS.offsetObj[i];
			var curText = "";
			for (var j = 0; j < curP.length; j += 4) {
				var curPos = 1;
				var curNum = curP[j + 3];
				for (var k = 0; k < 5; k++) {
					if (curNum & curPos) {
						curText += /*"🞅"*/"O";
					} else {
						curText += "-";
					}
					curPos <<= 1;
				}
				
				for (var k = 0; k < curP[j + 2]; k++) {
					if (curNum & curPos) {
						curText += /*"🞑"*/"■"/*█▮◾⬛▬⏹*/;
					} else {
						curText += "□";
					}
					curPos <<= 1;
				}
				
				for (var k = 0; k < 5; k++) {
					if (curNum & curPos) {
						curText += /*"🞅"*/"O";
					} else {
						curText += "-";
					}
					curPos <<= 1;
				}
				
				curText += "\n";
			}
			
			w.text = curText + w.text;
		}
		
		w.text = w.text.slice(0, -1);
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
	
	static function hitOffset(inp) {
		var curArr = TAS.offsetObj[TAS.curPattern];
		
		if (!curArr) {
			return;
		}
		
		var somethingChanged = false;
		
		for (var i = TAS.curPatternInd; i < curArr.length; i += 4) {
			var curTotalFrame = TAS.curPatternFrame + curArr[i];
			var curNum = curArr[i + 2];
			
			if (TAS.totalFrame > curTotalFrame + curNum + 4) {
				if (i === TAS.curPatternInd) {
					TAS.curPatternInd += 4;
				}
				continue;
			}
			
			if (TAS.totalFrame < curTotalFrame - 5) {
				break;
			}
			
			if (curArr[i + 1] !== inp) {
				continue;
			}
			
			curArr[i + 3] |= 1 << (TAS.totalFrame - curTotalFrame + 5);
			somethingChanged = true;
		}
		
		if (somethingChanged) {
			TAS.updateOffsetBars();
		}
	}

	static function checkKeys() {
		if (TAS.neutralPlayback) {
			return;
		}
		
		if (TAS.initializeOffset) {
			if (TAS.offsetObj.hasOwnProperty(TAS.totalFrame)) {
				TAS.offsetObj[Utils.currentPlayerString()] = TAS.offsetObj[TAS.totalFrame];
				delete TAS.offsetObj[TAS.totalFrame];
			}
		} else {
			if (TAS.offsetObj.hasOwnProperty(Utils.currentPlayerString())) {
				TAS.curPattern = Utils.currentPlayerString();
				TAS.curPatternInd = 0;
				TAS.curPatternFrame = TAS.totalFrame;
				TAS.clearOffsets(TAS.offsetObj[TAS.curPattern]);
				TAS.updateOffsetBars();
			}
		}
		
		if (TAS.write) {
			var DIR_PRESSED = -1;
			var UP_PRESSED = false;
			var DOWN_PRESSED = false;
			
			if (!Utils.foif()) {
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
		
		var prevFullLetter = "n";
		if (TAS.isFullLetter(TAS.inputArray[TAS.curIndex])) {
			prevFullLetter = TAS.inputArray[TAS.curIndex];
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
		
		var doOffsets = TAS.write && TAS.offsetObj.hasOwnProperty(TAS.curPattern) && prevFullLetter !== letter;
		
		if (letter == "p") {
			if (!com.nitrome.toxic.Global.game_paused) {
				_root.popup_holder.displayPopUp("game_paused");
				_root.game.pauseGame();
			}
			if (doOffsets) {
				TAS.hitOffset(7);
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
			
			if (doOffsets) {
				if (prevFullLetter === "p") {
					TAS.hitOffset(6);
				} else {
					var prevNum = "nadwqesADWQE".indexOf(prevFullLetter);
					if (prevNum % 3 - 1 !== com.nitrome.toxic.Global.DIR_PRESSED) {
						TAS.hitOffset(com.nitrome.toxic.Global.DIR_PRESSED);
					}
					if ((prevNum % 6 >= 3) !== com.nitrome.toxic.Global.UP_PRESSED) {
						TAS.hitOffset(com.nitrome.toxic.Global.UP_PRESSED? 3 : 2);
					}
					if ((prevNum >= 6) !== com.nitrome.toxic.Global.DOWN_PRESSED) {
						TAS.hitOffset(com.nitrome.toxic.Global.DOWN_PRESSED? 5 : 4);
					}
				}
			}
		}
		TAS.curFrame++;
		TAS.totalFrame++;
		
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
		
		TAS.curPattern = 0;
		TAS.curPatternInd = 0;
		TAS.curPatternFrame = 0;
		
		if (Utils.skipBeginning) {
			TAS.neutralPlayback = true;
			var i = 0;
			while (i < 109) {
				Main.gameUpdate();
				i++;
			}
			TAS.neutralPlayback = false;
		}
		
		TAS.totalFrame = 0;
		
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
		if (!TAS.initializeOffset) {
			for (var i in TAS.offsetObj) {
				TAS.clearOffsets(TAS.offsetObj[i]);
			}
		}
		TAS.initializeOffset = false;
		TAS.updateOffsetBars();
	}
}