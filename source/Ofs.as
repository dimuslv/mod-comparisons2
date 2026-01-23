class Ofs
{ //-----+🞅---- 🞓 🞑 	🞒 	🞓 	🞔 	🞕 	🞖 🞡 	🞢 	🞣-----🞤 	🞥 	🞦 	🞧◉ 	◊ 	○ 	◌ 	◍ 	◎ 	●
	static var patterns = {};
	static var activePattern = "";
	static var patternsInOrder = [];
	
	static function convertPlayerStateToString(p, levelWidth, levelHeight) {
		return [p._x, p._y, p.state, p.dir, p.vx, p.vy, p.wall_count, p.fall_count].join("/");
	}
	
	static function isSymbol(let) {
		return TAS.isSymbol(let) || ">.,".indexOf(let) != -1;
	}
	
	static function loadOffsets() {
		var newInputArray = ["i"];
		var newValueArray = [0];
		var newIndArray = [-1];
		var newEndIndArray = [0];
		var newIndex = -1;
		var newFrame = -1;
		var newString = TAS.inputField.text;
		
		var totalFrame = 0;
		
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
}