class TAS
{
	static var inputField;
	static var justPause;
	static var justPlacedBombs;
	static var offsetField;
	static var pressedHit;
	static var pressedPause;
	static var releasedUp;
	static var targetFrame;
	static var targetIndex;
	static var totalFrame;
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
	static var queuedHit = false;
	static var delayedCaretPos = -1;
	static var lastCaretPos = -1;
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
	function TAS()
	{
	}
	static function getImportantKeycodes()
	{
		var obj = {};
		var arr = [37,38,39,40,87,65,83,68,32];
		for(var i in arr)
		{
			obj[arr[i]] = true;
		}
		return obj;
	}
	static function updateVarWindow(w)
	{
		var _loc3_ = _root.game.player;
		w.obj.options = ["x: " + _loc3_._x,false,"y: " + _loc3_._y,false,"vx: " + _loc3_.vx,false,"vy: " + _loc3_.vy,false,"wc: " + _loc3_.wall_count,false,"hc: " + _loc3_.hit_count,false,"st: " + ["start","stand","duck","walk","jump","fall","wall","hit","die","end"][_loc3_.state],false,"dir: " + ["l","r"][_loc3_.dir],false];
		w.updateMainField(false);
	}
	static function isAtStringEnd()
	{
		return TAS.curIndex >= TAS.inputArray.length - 1 && TAS.curFrame >= TAS.valueArray[TAS.curIndex];
	}
	static function isS(sym, str)
	{
		return str.indexOf(sym) !== -1;
	}
	static function isSubLetter(let)
	{
		return TAS.isS(let,TAS.subLetters);
	}
	static function isFullLetter(let)
	{
		return TAS.isS(let,TAS.fullLetters);
	}
	static function isLetter(let)
	{
		return TAS.isS(let,TAS.letters);
	}
	static function isSymbol(let)
	{
		return TAS.isS(let,TAS.symbols);
	}
	static function isKeyLetter(let)
	{
		return TAS.isS(let,"wasdWASDlruvLRUVb");
	}
	static function compact(num)
	{
		return num == 1 ? "" : num;
	}
	static function clearOffsets(arr)
	{
		var _loc2_ = 3;
		while(_loc2_ < arr.length)
		{
			arr[_loc2_] = 0;
			_loc2_ += 4;
		}
	}
	static function scrollToCaret()
	{
		var caretInd;
		if(TAS.isAtStringEnd())
		{
			caretInd = TAS.curString.length;
		}
		else if(TAS.curFrame == TAS.valueArray[TAS.curIndex])
		{
			caretInd = TAS.indArray[TAS.curIndex + 1];
		}
		else
		{
			caretInd = TAS.indArray[TAS.curIndex];
		}
		Selection.setFocus(TAS.inputField);
		Selection.setSelection(caretInd,caretInd);
		Windows.nullFocus();
	}
	static function doKeyDown(code)
	{
		if(TAS.doTasKeyDown(code))
		{
			return undefined;
		}
		if(Utils.doKeyDown(code))
		{
			return undefined;
		}
		if(TAS.write || true)
		{
			if(code == 38 || code == 87)
			{
				TAS.UP_PRESSED = true;
			}
			else if(code == 40 || code == 83)
			{
				TAS.DOWN_PRESSED = true;
			}
			else if(code == 37 || code == 65)
			{
				com.nitrome.toxic.Global.LAST_DIR_PRESSED = com.nitrome.toxic.Global.LEFT;
			}
			else if(code == 39 || code == 68)
			{
				com.nitrome.toxic.Global.LAST_DIR_PRESSED = com.nitrome.toxic.Global.RIGHT;
			}
			else if(code == 32 || code == 66)
			{
				if(!TAS.justPause)
				{
					TAS.justPlacedBombs++;
				}
			}
			else if(code == 78)
			{
				if(TAS.justPlacedBombs > 0)
				{
					TAS.justPlacedBombs--;
				}
			}
			else if(code == 80)
			{
				TAS.justPause = !TAS.justPause;
				TAS.pressedPause = true;
			}
			else if(code == 72)
			{
				TAS.pressedHit = !TAS.pressedHit;
			}
			if(TAS.importantKeycodes[code])
			{
				if(!TAS.keysDown[code] && TAS.write && TAS.offsetObj.hasOwnProperty(TAS.curPattern))
				{
					TAS.hitOffset(code);
				}
				TAS.keysDown[code] = true;
			}
		}
	}
	static function doKeyUp(code)
	{
		if(code == 38 || code == 87)
		{
			TAS.releasedUp = true;
			TAS.UP_PRESSED = false;
		}
		else if(code == 40 || code == 83)
		{
			TAS.DOWN_PRESSED = false;
		}
		if(TAS.importantKeycodes[code])
		{
			if(TAS.write && TAS.offsetObj.hasOwnProperty(TAS.curPattern))
			{
				TAS.hitOffset(- code);
			}
			TAS.keysDown[code] = false;
		}
	}
	static function doTasKeyDown(code)
	{
		if(Utils.foif())
		{
			if(Selection.getFocus() == "_level0.window_clip.inputWindow.inputField")
			{
				if(code == 27 || code == 112)
				{
					TAS.lastCaretPos = -1;
					Windows.nullFocus();
				}
				else if(code == 34)
				{
					TAS.lastCaretPos = Selection.getCaretIndex();
					TAS.delayedCaretPos = Selection.getCaretIndex();
					Windows.nullFocus();
				}
				else if(code == 33 || code == 123)
				{
					TAS.lastCaretPos = Selection.getCaretIndex();
					Windows.nullFocus();
				}
				else if(code == 13)
				{
					TAS.loadInputs(-1);
				}
			}
			else if(code == 27 || code == 112)
			{
				Windows.nullFocus();
			}
			return true;
		}
		var _loc3_;
		if(code == 113)
		{
			_root.popup_holder.clip.key_button.clearKeyListener();
			_root.mc.startMenuMusic(false);
			if(!_root.game.level_number)
			{
				_root.tt.doTween("title_screen");
			}
			else
			{
				_root.tt.doTween("map");
			}
		}
		else if(code == 86)
		{
			Windows.clip.varWindow._visible = !Windows.clip.varWindow._visible;
		}
		else if(code == 73)
		{
			if(Windows.clip.inputWindow._visible = !Windows.clip.inputWindow._visible)
			{
				TAS.updateText();
			}
		}
		else if(code === 79)
		{
			Windows.clip.inputWindow._visible = true;
			TAS.updateText();
			TAS.offsetField._visible = !TAS.offsetField._visible;
			if(TAS.offsetField._visible)
			{
				Windows.clip.offsetBarsWindow._visible = true;
			}
		}
		else if(code == 84)
		{
			Windows.clip.timerWindow._visible = !Windows.clip.timerWindow._visible;
		}
		else if(code == 191 || code == 222)
		{
			TAS.write = code == 191;
			TAS.frozen = !TAS.frozen;
			TAS.override = !Key.isDown(16);
		}
		else if(code == 190 || code == 186 || code == 75)
		{
			if(code != 75)
			{
				TAS.frozen = true;
			}
			TAS.write = code == 190;
			_loc3_ = code == 75 ? 30 : 1;
			if(TAS.write)
			{
				TAS.override = !Key.isDown(16);
			}
			else if(Key.isDown(16))
			{
				_loc3_ *= 5;
			}
			TAS.fastPlayback = true;
			while(_loc3_ > 0 && (TAS.write || !TAS.isAtStringEnd()))
			{
				if(_loc3_ == 1)
				{
					TAS.fastPlayback = false;
				}
				Main.gameUpdate();
				_loc3_ = _loc3_ - 1;
			}
			TAS.fastPlayback = false;
			TAS.updateText();
			Main.stopAll();
		}
		else if(code == 188 || code == 76 || code == 74)
		{
			if(code != 74)
			{
				TAS.frozen = true;
			}
			TAS.write = code == 188;
			_loc3_ = code == 74 ? 30 : 1;
			if(Key.isDown(16))
			{
				_loc3_ *= 5;
			}
			if(TAS.curIndex > 0)
			{
				while(_loc3_ > 0 && TAS.curIndex > 0)
				{
					TAS.curFrame--;
					if(TAS.curFrame <= 0)
					{
						do
						{
							TAS.curIndex--;
						}
						while(TAS.isSubLetter(TAS.inputArray[TAS.curIndex]));
						TAS.curFrame = TAS.valueArray[TAS.curIndex];
					}
					_loc3_ = _loc3_ - 1;
				}
				TAS.runBack = true;
				_root.tt.doTween("reload");
			}
			if(TAS.write)
			{
				TAS.truncateCurArray();
			}
		}
		else if(code == 220)
		{
			TAS.scrollToCaret();
		}
		else if(code == 46)
		{
			TAS.truncateCurArray();
			TAS.updateText();
		}
		else if(code == 82)
		{
			_root.tt.doTween("reload");
		}
		else
		{
			if(!(code >= 48 && code <= 57))
			{
				return false;
			}
			if(Key.isDown(16))
			{
				TAS.updateText(true);
				TAS.saveStates[code - 48] = TAS.inputField.text;
			}
			else if(TAS.saveStates[code - 48])
			{
				TAS.inputField.text = TAS.saveStates[code - 48];
				TAS.loadInputs(-1);
			}
		}
		return true;
	}
	static function truncateCurArray()
	{
		TAS.inputArray.length = TAS.curIndex + 1;
		TAS.valueArray.length = TAS.curIndex + 1;
		TAS.indArray.length = TAS.curIndex + 1;
		TAS.endIndArray.length = TAS.curIndex + 1;
		TAS.valueArray[TAS.curIndex] = TAS.curFrame;
		if(TAS.curIndex == 0)
		{
			if(TAS.indArray[0] == -1)
			{
				TAS.curString = "";
			}
			else
			{
				TAS.curString = TAS.curString.slice(0,TAS.endIndArray[0]);
			}
		}
		else
		{
			TAS.curString = TAS.curString.slice(0,TAS.indArray[TAS.curIndex]) + TAS.inputArray[TAS.curIndex] + TAS.compact(TAS.curFrame);
		}
	}
	static function splitCurLetter()
	{
		if(TAS.curFrame == TAS.valueArray[TAS.curIndex])
		{
			return undefined;
		}
		TAS.inputArray.splice(TAS.curIndex + 1,0,TAS.inputArray[TAS.curIndex]);
		TAS.valueArray.splice(TAS.curIndex + 1,0,TAS.valueArray[TAS.curIndex] - TAS.curFrame);
		TAS.valueArray[TAS.curIndex] = TAS.curFrame;
		var newString = TAS.curString.slice(0,TAS.indArray[TAS.curIndex]) + (TAS.inputArray[TAS.curIndex] + TAS.compact(TAS.curFrame));
		TAS.indArray.splice(TAS.curIndex + 1,0,newString.length);
		newString += TAS.inputArray[TAS.curIndex + 1] + TAS.compact(TAS.valueArray[TAS.curIndex + 1]);
		TAS.endIndArray.splice(TAS.curIndex + 1,0,newString.length);
		newString += TAS.curString.slice(TAS.endIndArray[TAS.curIndex]);
		var i = TAS.curIndex + 2;
		while(i < TAS.inputArray.length)
		{
			TAS.indArray[i] += TAS.endIndArray[TAS.curIndex + 1] - TAS.endIndArray[TAS.curIndex];
			TAS.endIndArray[i] += TAS.endIndArray[TAS.curIndex + 1] - TAS.endIndArray[TAS.curIndex];
			i++;
		}
		TAS.endIndArray[TAS.curIndex] = TAS.indArray[TAS.curIndex + 1];
		TAS.curString = newString;
	}
	static function parseInputString(str, caretPos)
	{
		var _loc3_ = ["i"];
		var _loc4_ = [0];
		var _loc5_ = [-1];
		var _loc6_ = [0];
		var _loc7_ = -1;
		var _loc8_ = -1;
		var _loc9_ = str;
		var _loc10_ = false;
		if(caretPos >= 0)
		{
			_loc10_ = true;
		}
		var _loc11_ = -1;
		var _loc12_ = [[0]];
		var _loc13_ = 0;
		var _loc14_ = -1;
		var _loc15_ = 0;
		while(_loc15_ < _loc9_.length && !TAS.isSymbol(_loc9_.charAt(_loc15_)))
		{
			_loc15_ = _loc15_ + 1;
		}
		var _loc16_;
		var _loc17_;
		var _loc18_;
		var _loc19_;
		var _loc20_;
		var _loc21_;
		var _loc22_;
		var _loc23_;
		var _loc24_;
		var _loc25_;
		var _loc26_;
		while(_loc15_ < _loc9_.length)
		{
			_loc16_ = _loc9_.charAt(_loc15_);
			_loc17_ = _loc15_;
			_loc18_ = 0;
			_loc19_ = _loc15_ + 1;
			_loc20_ = 0;
			_loc21_ = "";
			_loc15_ = _loc15_ + 1;
			while(_loc15_ < _loc9_.length)
			{
				_loc22_ = _loc9_.charAt(_loc15_);
				if(_loc9_.charCodeAt(_loc15_) >= 48 && _loc9_.charCodeAt(_loc15_) <= 57)
				{
					_loc18_ = _loc18_ * 10 + _loc9_.charCodeAt(_loc15_) - 48;
					_loc19_ = _loc15_ + 1;
				}
				else if(_loc16_ === "," && !_loc21_)
				{
					if(TAS.isKeyLetter(_loc22_))
					{
						_loc21_ = _loc22_;
					}
					else if(_loc22_ === ",")
					{
						_loc20_ += _loc18_ ? _loc18_ : 1;
						_loc18_ = 0;
					}
				}
				else if(_loc16_ === "." && _loc22_ === ".")
				{
					_loc20_ += _loc18_ ? _loc18_ : 1;
					_loc18_ = 0;
				}
				else if(TAS.isSymbol(_loc22_))
				{
					break;
				}
				_loc15_ = _loc15_ + 1;
			}
			if(!TAS.isS(_loc16_,"|>r") && !_loc18_)
			{
				_loc18_ = 1;
			}
			_loc18_ += _loc20_;
			if(_loc16_ == "|")
			{
				_loc7_ = _loc3_.length;
				_loc8_ = _loc18_;
				_loc15_ -= _loc19_ - _loc17_;
				caretPos -= _loc19_ - _loc17_;
				_loc9_ = _loc9_.slice(0,_loc17_) + _loc9_.slice(_loc19_);
			}
			else if(_loc16_ === ">")
			{
				if(_loc13_ != Utils.getLast(_loc12_)[0])
				{
					_loc12_.push([_loc13_]);
				}
			}
			else if(_loc16_ === ",")
			{
				if(_loc21_)
				{
					_loc23_ = {w:87,a:65,s:83,d:68,u:38,l:37,v:40,r:39,b:32}[_loc21_.toLowerCase()];
					if(_loc21_ !== _loc21_.toLowerCase())
					{
						_loc23_ *= -1;
					}
					Utils.pushO(_loc12_,_loc13_,_loc23_,_loc18_);
				}
			}
			else if(_loc16_ === ".")
			{
				_loc14_ = _loc18_;
			}
			else
			{
				if(_loc3_.length == 1 && _loc5_[0] == -1 && _loc16_ == "r")
				{
					_loc4_[0] = _loc18_;
					_loc5_[0] = _loc17_;
					_loc6_[0] = _loc19_;
				}
				else
				{
					_loc3_.push(_loc16_);
					_loc4_.push(_loc18_);
					_loc5_.push(_loc17_);
					_loc6_.push(_loc19_);
				}
				if(_loc11_ == -1 && caretPos < _loc19_)
				{
					_loc11_ = Math.max(0,_loc3_.length - 2);
				}
				if(TAS.isFullLetter(_loc16_))
				{
					if(_loc14_ !== -1)
					{
						_loc24_ = "n";
						_loc25_ = _loc3_.length - 2;
						while(_loc25_ >= 0)
						{
							if(TAS.isFullLetter(_loc3_[_loc25_]))
							{
								_loc24_ = _loc3_[_loc25_];
								break;
							}
							_loc25_ = _loc25_ - 1;
						}
						if(_loc24_ === "p")
						{
							if(_loc16_ !== "p")
							{
								Utils.pushO(_loc12_,_loc13_,6,_loc14_);
							}
						}
						else if(_loc16_ === "p")
						{
							Utils.pushO(_loc12_,_loc13_,7,_loc14_);
						}
						else
						{
							_loc26_ = [];
							_loc25_ = 0;
							while(_loc25_ < 2)
							{
								_loc23_ = "nadwqesADWQE".indexOf([_loc24_,_loc16_][_loc25_]);
								_loc26_.push(_loc23_ % 3 - 1,_loc23_ % 6 >= 3,_loc23_ >= 6);
								_loc25_ = _loc25_ + 1;
							}
							_loc25_ = 0;
							while(_loc25_ < 3)
							{
								if(_loc26_[_loc25_] !== _loc26_[3 + _loc25_])
								{
									Utils.pushO(_loc12_,_loc13_,_loc25_ ? 2 * _loc25_ + (_loc26_[3 + _loc25_] ? 1 : 0) : _loc26_[3 + _loc25_],_loc14_);
								}
								_loc25_ = _loc25_ + 1;
							}
						}
						_loc14_ = -1;
					}
					_loc13_ += _loc18_;
				}
			}
		}
		if(TAS.isSubLetter(_loc3_[_loc3_.length - 1]))
		{
			_loc3_.push("n");
			_loc4_.push(1);
			_loc5_.push(_loc9_.length);
			_loc9_ += "n";
			_loc6_.push(_loc9_.length);
		}
		if(_loc10_)
		{
			if(_loc11_ == -1)
			{
				_loc7_ = _loc3_.length - 1;
			}
			else
			{
				_loc7_ = _loc11_;
			}
			_loc8_ = _loc4_[_loc7_];
		}
		else if(_loc7_ == -1 || _loc7_ == _loc3_.length)
		{
			_loc7_ = _loc3_.length - 1;
			_loc8_ = _loc4_[_loc7_];
		}
		else if(_loc8_ == 0)
		{
			_loc7_ = _loc7_ - 1;
			_loc8_ = _loc4_[_loc7_];
		}
		else
		{
			_loc8_ = Math.min(_loc8_,_loc4_[_loc7_]);
		}
		if(TAS.isSubLetter(_loc3_[_loc7_]))
		{
			while(TAS.isSubLetter(_loc3_[_loc7_]))
			{
				_loc7_ = _loc7_ - 1;
			}
			_loc8_ = _loc4_[_loc7_];
		}
		return {inputArray:_loc3_,valueArray:_loc4_,indArray:_loc5_,endIndArray:_loc6_,curString:_loc9_,curIndex:_loc7_,curFrame:_loc8_,offsetArr:_loc12_};
	}
	static function loadInputs(caretPos)
	{
		var _loc3_ = TAS.parseInputString(TAS.inputField.text,caretPos);
		var _loc4_ = true;
		if(TAS.curIndex == _loc3_.curIndex && TAS.curFrame == _loc3_.curFrame)
		{
			i = 0;
			while(i < _loc3_.curIndex)
			{
				if(TAS.inputArray[i] != _loc3_.inputArray[i] || TAS.valueArray[i] != _loc3_.valueArray[i])
				{
					_loc4_ = false;
					break;
				}
				i++;
			}
			if(TAS.inputArray[_loc3_.curIndex] != _loc3_.inputArray[_loc3_.curIndex])
			{
				_loc4_ = false;
			}
		}
		else
		{
			_loc4_ = false;
		}
		TAS.inputArray = _loc3_.inputArray;
		TAS.valueArray = _loc3_.valueArray;
		TAS.indArray = _loc3_.indArray;
		TAS.endIndArray = _loc3_.endIndArray;
		TAS.curString = _loc3_.curString;
		TAS.curIndex = _loc3_.curIndex;
		TAS.curFrame = _loc3_.curFrame;
		if(!_loc4_)
		{
			TAS.runBack = true;
			_root.tt.doTween("reload");
		}
		else
		{
			TAS.updateText();
		}
	}
	static function loadOffsets()
	{
		if(TAS.offsetString === TAS.offsetField.text)
		{
			return undefined;
		}
		TAS.offsetString = TAS.offsetField.text;
		var _loc2_ = TAS.parseInputString(TAS.offsetString,-1);
		TAS.offsetObj = {};
		var _loc3_ = 0;
		while(_loc3_ < _loc2_.offsetArr.length)
		{
			TAS.offsetObj[_loc2_.offsetArr[_loc3_].shift()] = _loc2_.offsetArr[_loc3_];
			_loc3_ = _loc3_ + 1;
		}
		if(_loc2_.offsetArr.length > 1)
		{
			TAS.inputArray = _loc2_.inputArray;
			TAS.valueArray = _loc2_.valueArray;
			TAS.indArray = _loc2_.indArray;
			TAS.endIndArray = _loc2_.endIndArray;
			TAS.curString = _loc2_.curString;
			TAS.curIndex = TAS.inputArray.length - 1;
			TAS.curFrame = TAS.valueArray[TAS.curIndex];
			TAS.initializeOffset = true;
			TAS.runBack = true;
			_root.tt.doTween("reload");
		}
		else
		{
			TAS.updateOffsetBars();
		}
	}
	static function updateOffsetBars()
	{
		var w = Windows.clip.offsetBarsWindow.barsWindow;
		w.text = "";
		for(var i in TAS.offsetObj)
		{
			var curP = TAS.offsetObj[i];
			var curText = "";
			var j = 0;
			while(j < curP.length)
			{
				var curPos = 1;
				var curNum = curP[j + 3];
				var k = 0;
				while(k < 5)
				{
					if(curNum & curPos)
					{
						curText += "O";
					}
					else
					{
						curText += "-";
					}
					curPos <<= 1;
					k++;
				}
				var k = 0;
				while(k < curP[j + 2])
				{
					if(curNum & curPos)
					{
						curText += "■";
					}
					else
					{
						curText += "□";
					}
					curPos <<= 1;
					k++;
				}
				var k = 0;
				while(k < 5)
				{
					if(curNum & curPos)
					{
						curText += "O";
					}
					else
					{
						curText += "-";
					}
					curPos <<= 1;
					k++;
				}
				curText += "\n";
				j += 4;
			}
			w.text = curText + w.text;
		}
		w.text = w.text.slice(0,-1);
	}
	static function updateText(forced)
	{
		if(!forced && (!Windows.clip.inputWindow._visible || !TAS.inputField._visible))
		{
			return undefined;
		}
		var _loc2_;
		if(TAS.isAtStringEnd())
		{
			TAS.inputField.text = TAS.curString;
			_loc2_ = TAS.inputField.textWidth;
		}
		else if(TAS.curFrame == TAS.valueArray[TAS.curIndex])
		{
			TAS.inputField.text = TAS.curString.slice(0,TAS.indArray[TAS.curIndex + 1]);
			_loc2_ = TAS.inputField.textWidth;
			TAS.inputField.text += "|" + TAS.curString.slice(TAS.indArray[TAS.curIndex + 1]);
		}
		else
		{
			TAS.inputField.text = TAS.curString.slice(0,TAS.indArray[TAS.curIndex]);
			_loc2_ = TAS.inputField.textWidth;
			TAS.inputField.text += "|" + TAS.curFrame + TAS.curString.slice(TAS.indArray[TAS.curIndex]);
		}
		if(Utils.autoScroll)
		{
			TAS.inputField.hscroll = (_loc2_ - 225) * TAS.inputField.maxhscroll / (TAS.inputField.textWidth - 395);
		}
	}
	static function foif()
	{
		return Selection.getFocus() == "_level0.window_clip.inputWindow.inputField";
	}
	static function hitOffset(inp)
	{
		var _loc2_ = TAS.offsetObj[TAS.curPattern];
		if(!_loc2_)
		{
			return undefined;
		}
		var _loc3_ = false;
		var _loc4_ = TAS.curPatternInd;
		var _loc5_;
		var _loc6_;
		while(_loc4_ < _loc2_.length)
		{
			_loc5_ = TAS.curPatternFrame + _loc2_[_loc4_];
			_loc6_ = _loc2_[_loc4_ + 2];
			if(TAS.totalFrame > _loc5_ + _loc6_ + 4)
			{
				if(_loc4_ === TAS.curPatternInd)
				{
					TAS.curPatternInd += 4;
				}
			}
			else
			{
				if(TAS.totalFrame < _loc5_ - 5)
				{
					break;
				}
				if(_loc2_[_loc4_ + 1] === inp)
				{
					_loc2_[_loc4_ + 3] |= 1 << TAS.totalFrame - _loc5_ + 5;
					_loc3_ = true;
				}
			}
			_loc4_ += 4;
		}
		if(_loc3_)
		{
			TAS.updateOffsetBars();
		}
	}
	static function checkKeys()
	{
		if(TAS.neutralPlayback)
		{
			return undefined;
		}
		if(TAS.initializeOffset)
		{
			if(TAS.offsetObj.hasOwnProperty(TAS.totalFrame))
			{
				TAS.offsetObj[Utils.currentPlayerString()] = TAS.offsetObj[TAS.totalFrame];
				delete TAS.offsetObj[TAS.totalFrame];
			}
		}
		else if(TAS.offsetObj.hasOwnProperty(Utils.currentPlayerString()))
		{
			TAS.curPattern = Utils.currentPlayerString();
			TAS.curPatternInd = 0;
			TAS.curPatternFrame = TAS.totalFrame;
			TAS.clearOffsets(TAS.offsetObj[TAS.curPattern]);
			TAS.updateOffsetBars();
		}
		var _loc2_;
		var _loc3_;
		var _loc4_;
		var _loc5_;
		var _loc6_;
		var _loc7_;
		var _loc8_;
		var _loc9_;
		var _loc10_;
		var _loc11_;
		var _loc12_;
		var _loc13_;
		var _loc14_;
		if(TAS.write)
		{
			_loc2_ = -1;
			_loc3_ = false;
			_loc4_ = false;
			if(!Utils.foif())
			{
				if((Key.isDown(37) || Key.isDown(65)) && (Key.isDown(39) || Key.isDown(68)))
				{
					if(com.nitrome.toxic.Global.LAST_DIR_PRESSED == com.nitrome.toxic.Global.LEFT)
					{
						_loc2_ = com.nitrome.toxic.Global.LEFT;
					}
					else if(com.nitrome.toxic.Global.LAST_DIR_PRESSED == com.nitrome.toxic.Global.RIGHT)
					{
						_loc2_ = com.nitrome.toxic.Global.RIGHT;
					}
				}
				else if(Key.isDown(37) || Key.isDown(65))
				{
					_loc2_ = com.nitrome.toxic.Global.LEFT;
				}
				else if(Key.isDown(39) || Key.isDown(68))
				{
					_loc2_ = com.nitrome.toxic.Global.RIGHT;
				}
				else
				{
					_loc2_ = -1;
				}
				if(!Key.isDown(38) && !Key.isDown(87))
				{
					TAS.UP_PRESSED = false;
				}
				if(!Key.isDown(40) && !Key.isDown(83))
				{
					TAS.DOWN_PRESSED = false;
				}
				_loc3_ = TAS.UP_PRESSED;
				_loc4_ = TAS.DOWN_PRESSED;
			}
			if(TAS.override)
			{
				TAS.truncateCurArray();
			}
			else
			{
				TAS.splitCurLetter();
			}
			_loc5_ = TAS.curIndex === TAS.inputArray.length - 1;
			if(!_loc5_)
			{
				_loc6_ = [TAS.curIndex + 1,0];
				_loc7_ = [TAS.curIndex + 1,0];
			}
			else
			{
				_loc6_ = TAS.inputArray;
				_loc7_ = TAS.valueArray;
			}
			_loc8_ = _loc6_.length;
			if(TAS.justPause)
			{
				_loc3_ = com.nitrome.toxic.Global.UP_PRESSED;
			}
			if(!TAS.frozen && !com.nitrome.toxic.Global.can_jump)
			{
				if((com.nitrome.toxic.Global.UP_PRESSED && !_loc3_) !== TAS.releasedUp)
				{
					if(TAS.releasedUp)
					{
						_loc6_.push("j");
					}
					else
					{
						_loc6_.push("J");
					}
					_loc7_.push(1);
				}
			}
			if(TAS.justPlacedBombs > 0)
			{
				_loc6_.push("b");
				_loc7_.push(TAS.justPlacedBombs);
			}
			if(TAS.pressedHit)
			{
				_loc6_.push("h");
				_loc7_.push(1);
			}
			if(com.nitrome.toxic.Global.game_paused === TAS.justPause && TAS.pressedPause)
			{
				if(TAS.justPlacedBombs <= 0 || !TAS.justPause)
				{
					_loc6_.push("P");
					_loc7_.push(1);
				}
			}
			_loc9_ = "nadwqesADWQE".charAt(_loc2_ + 1 + int(_loc3_) * 3 + int(_loc4_) * 6);
			if(TAS.justPause)
			{
				_loc9_ = "p";
			}
			_loc10_ = TAS.endIndArray[TAS.curIndex];
			_loc11_ = TAS.curString.slice(_loc10_);
			TAS.curString = TAS.curString.slice(0,_loc10_);
			if(_loc6_.length === _loc8_ && _loc9_ === TAS.inputArray[TAS.curIndex])
			{
				TAS.valueArray[TAS.curIndex]++;
				TAS.curString = TAS.curString.slice(0,TAS.indArray[TAS.curIndex]) + TAS.inputArray[TAS.curIndex] + TAS.valueArray[TAS.curIndex];
				TAS.endIndArray[TAS.curIndex] = TAS.curString.length;
			}
			else
			{
				_loc6_.push(_loc9_);
				_loc7_.push(1);
				if(!_loc5_)
				{
					TAS.inputArray.splice.apply(TAS.inputArray,_loc6_);
					TAS.valueArray.splice.apply(TAS.valueArray,_loc7_);
				}
				if(!_loc5_)
				{
					_loc12_ = [TAS.curIndex + 1,0];
					_loc13_ = [TAS.curIndex + 1,0];
				}
				else
				{
					_loc12_ = TAS.indArray;
					_loc13_ = TAS.endIndArray;
				}
				_loc14_ = _loc8_;
				while(_loc14_ < _loc6_.length)
				{
					_loc12_.push(TAS.curString.length);
					TAS.curString += _loc6_[_loc14_] + TAS.compact(_loc7_[_loc14_]);
					_loc13_.push(TAS.curString.length);
					_loc14_ = _loc14_ + 1;
				}
				if(!_loc5_)
				{
					TAS.indArray.splice.apply(TAS.indArray,_loc12_);
					TAS.endIndArray.splice.apply(TAS.endIndArray,_loc13_);
				}
			}
			if(!_loc5_)
			{
				_loc14_ = TAS.curIndex + _loc6_.length - 1;
				while(_loc14_ < TAS.indArray.length)
				{
					TAS.indArray[_loc14_] += TAS.curString.length - _loc10_;
					TAS.endIndArray[_loc14_] += TAS.curString.length - _loc10_;
					_loc14_ = _loc14_ + 1;
				}
			}
			TAS.curString += _loc11_;
		}
		var _loc15_ = "n";
		if(TAS.isFullLetter(TAS.inputArray[TAS.curIndex]))
		{
			_loc15_ = TAS.inputArray[TAS.curIndex];
		}
		if(TAS.curFrame >= TAS.valueArray[TAS.curIndex])
		{
			TAS.curIndex++;
			TAS.curFrame = 0;
		}
		var _loc16_ = false;
		while(TAS.isSubLetter(TAS.inputArray[TAS.curIndex]))
		{
			switch(TAS.inputArray[TAS.curIndex])
			{
				case "b":
					if(com.nitrome.toxic.Global.game_paused)
					{
						_root.game.unpauseGame();
						_root.popup_holder.hidePopUp();
					}
					_loc14_ = 0;
					while(_loc14_ < TAS.valueArray[TAS.curIndex])
					{
						_root.game.layBomb();
						_loc14_ = _loc14_ + 1;
					}
					break;
				case "r":
					RNG.rngSeed = TAS.valueArray[TAS.curIndex];
					break;
				case "j":
					com.nitrome.toxic.Global.can_jump = true;
					break;
				case "J":
					_loc16_ = true;
					break;
				case "P":
					_root.popup_holder.displayPopUp("game_paused");
					_root.game.pauseGame();
					break;
				case "h":
					TAS.queuedHit = true;
			}
			TAS.curIndex++;
			TAS.curFrame = 0;
		}
		_loc9_ = TAS.inputArray[TAS.curIndex];
		var _loc17_ = TAS.write && TAS.offsetObj.hasOwnProperty(TAS.curPattern) && _loc15_ !== _loc9_;
		var _loc18_;
		var _loc19_;
		if(_loc9_ == "p")
		{
			if(!com.nitrome.toxic.Global.game_paused)
			{
				_root.popup_holder.displayPopUp("game_paused");
				_root.game.pauseGame();
			}
			if(_loc17_)
			{
				TAS.hitOffset(7);
			}
		}
		else
		{
			if(com.nitrome.toxic.Global.game_paused)
			{
				_root.game.unpauseGame();
				_root.popup_holder.hidePopUp();
			}
			_loc18_ = "nadwqesADWQE".indexOf(_loc9_);
			com.nitrome.toxic.Global.DIR_PRESSED = _loc18_ % 3 - 1;
			if(com.nitrome.toxic.Global.UP_PRESSED && _loc18_ % 6 < 3 && !_loc16_)
			{
				com.nitrome.toxic.Global.can_jump = true;
			}
			com.nitrome.toxic.Global.UP_PRESSED = _loc18_ % 6 >= 3;
			com.nitrome.toxic.Global.DOWN_PRESSED = _loc18_ >= 6;
			if(_loc17_)
			{
				if(_loc15_ === "p")
				{
					TAS.hitOffset(6);
				}
				else
				{
					_loc19_ = "nadwqesADWQE".indexOf(_loc15_);
					if(_loc19_ % 3 - 1 !== com.nitrome.toxic.Global.DIR_PRESSED)
					{
						TAS.hitOffset(com.nitrome.toxic.Global.DIR_PRESSED);
					}
					if(_loc19_ % 6 >= 3 !== com.nitrome.toxic.Global.UP_PRESSED)
					{
						TAS.hitOffset(com.nitrome.toxic.Global.UP_PRESSED ? 3 : 2);
					}
					if(_loc19_ >= 6 !== com.nitrome.toxic.Global.DOWN_PRESSED)
					{
						TAS.hitOffset(com.nitrome.toxic.Global.DOWN_PRESSED ? 5 : 4);
					}
				}
			}
		}
		TAS.curFrame++;
		TAS.totalFrame++;
		if(TAS.fastPlayback && TAS.curIndex == TAS.targetIndex && TAS.curFrame == TAS.targetFrame)
		{
			TAS.fastPlayback = false;
		}
	}
	static function performQueuedHit()
	{
		if(TAS.queuedHit)
		{
			_root.game.player.startHit();
		}
	}
	static function resetInputCheckers()
	{
		TAS.justPause = com.nitrome.toxic.Global.game_paused;
		TAS.pressedPause = false;
		TAS.releasedUp = false;
		TAS.pressedHit = false;
		TAS.justPlacedBombs = 0;
		TAS.queuedHit = false;
	}
	static function levelInit()
	{
		TAS.resetInputCheckers();
		var _loc2_ = [];
		for(var _loc3_ in _root.game.acid_holder)
		{
			_loc2_.push(_root.game.acid_holder[_loc3_]);
		}
		var _loc4_;
		for(_loc3_ in _loc2_)
		{
			_loc4_ = _loc2_[_loc3_];
			if(_loc4_.bubbles)
			{
				Main._gotoAndPlay(_loc4_.bubbles,RNG._random(267) + 1);
			}
			else if(_loc4_.anim)
			{
				Main._gotoAndPlay(_loc4_.anim,RNG._random(267) + 1);
			}
		}
		com.nitrome.toxic.Global.can_jump = true;
		var _loc5_ = TAS.write;
		TAS.write = false;
		TAS.targetIndex = TAS.curIndex;
		TAS.targetFrame = TAS.curFrame;
		TAS.curIndex = 0;
		TAS.curFrame = TAS.valueArray[0];
		TAS.fastPlayback = true;
		TAS.curPattern = 0;
		TAS.curPatternInd = 0;
		TAS.curPatternFrame = 0;
		var _loc6_;
		if(Utils.skipBeginning)
		{
			TAS.neutralPlayback = true;
			_loc6_ = 0;
			while(_loc6_ < 109)
			{
				Main.gameUpdate();
				_loc6_ = _loc6_ + 1;
			}
			TAS.neutralPlayback = false;
		}
		TAS.totalFrame = 0;
		if(TAS.runBack)
		{
			TAS.runBack = false;
			while(TAS.curIndex < TAS.targetIndex || TAS.curIndex == TAS.targetIndex && TAS.curFrame < TAS.targetFrame)
			{
				Main.gameUpdate();
			}
		}
		TAS.fastPlayback = false;
		TAS.targetIndex = -1;
		TAS.write = _loc5_;
		TAS.updateText();
		if(!TAS.initializeOffset)
		{
			for(_loc6_ in TAS.offsetObj)
			{
				TAS.clearOffsets(TAS.offsetObj[_loc6_]);
			}
		}
		TAS.initializeOffset = false;
		TAS.updateOffsetBars();
	}
}
