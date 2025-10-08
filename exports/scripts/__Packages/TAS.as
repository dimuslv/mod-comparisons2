class TAS
{
	static var inputField;
	static var justPause;
	static var justPlacedBombs;
	static var targetFrame;
	static var targetIndex;
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
	static var delayedCaretIndex = -1;
	static var subLetters = "rb";
	static var runBack = false;
	function TAS()
	{
	}
	static function updateVarWindow(w)
	{
		var _loc3_ = _root.game.player;
		w.obj.options = ["x: " + _loc3_._x,false,"y: " + _loc3_._y,false,"vx: " + _loc3_.vx,false,"vy: " + _loc3_.vy,false,"wc: " + _loc3_.wall_count,false,"hc: " + _loc3_.hit_count,false,"st: " + ["start","stand","duck","walk","jump","fall","wall","hit","die","end"][_loc3_.state],false];
		w.updateMainField(false);
	}
	static function isAtStringEnd()
	{
		return TAS.curIndex >= TAS.inputArray.length - 1 && TAS.curFrame >= TAS.valueArray[TAS.curIndex];
	}
	static function isSubLetter(let)
	{
		return "rb".indexOf(let) != -1;
	}
	static function compact(num)
	{
		return num == 1 ? "" : num;
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
			if(code == 37 || code == 65)
			{
				com.nitrome.toxic.Global.LAST_DIR_PRESSED = com.nitrome.toxic.Global.LEFT;
			}
			else if(code == 39 || code == 68)
			{
				com.nitrome.toxic.Global.LAST_DIR_PRESSED = com.nitrome.toxic.Global.RIGHT;
			}
			else if(code == 32 || code == 66)
			{
				TAS.justPlacedBombs++;
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
			}
		}
	}
	static function doTasKeyDown(code)
	{
		if(code == 13)
		{
			TAS.loadInputs(false);
			return true;
		}
		if(TAS.foif())
		{
			if(code == 27 || code == 112)
			{
				Windows.nullFocus();
				TAS.loadInputs(false);
			}
			else if(code == 38)
			{
				TAS.loadInputs(true);
				TAS.delayedCaretIndex = Selection.getCaretIndex();
				Windows.nullFocus();
			}
			else if(code == 40 || code == 123)
			{
				TAS.loadInputs(true);
				Windows.nullFocus();
			}
			return true;
		}
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
		if(code == 86)
		{
			Windows.clip.varWindow._visible = !Windows.clip.varWindow._visible;
			return true;
		}
		if(code == 73)
		{
			Windows.clip.inputWindow._visible = !Windows.clip.inputWindow._visible;
			return true;
		}
		if(code == 84)
		{
			Windows.clip.timerWindow._visible = !Windows.clip.timerWindow._visible;
			return true;
		}
		var _loc3_;
		if(code == 191 || code == 222)
		{
			TAS.write = code == 191;
			TAS.frozen = !TAS.frozen;
			TAS.override = !Key.isDown(16);
			return true;
		}
		if(code == 190 || code == 186 || code == 75)
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
			return true;
		}
		if(code == 188 || code == 76 || code == 74)
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
			return true;
		}
		var _loc4_;
		if(code == 220)
		{
			if(TAS.isAtStringEnd())
			{
				_loc4_ = TAS.curString.length;
			}
			else if(TAS.curFrame == TAS.valueArray[TAS.curIndex])
			{
				_loc4_ = TAS.indArray[TAS.curIndex + 1];
			}
			else
			{
				_loc4_ = TAS.indArray[TAS.curIndex];
			}
			Selection.setFocus(Windows.clip.inputWindow.inputField);
			Selection.setSelection(_loc4_,_loc4_);
			Windows.nullFocus();
			return true;
		}
		if(code == 46)
		{
			TAS.truncateCurArray();
			TAS.updateText();
			return true;
		}
		if(code == 82)
		{
			_root.tt.doTween("reload");
			return true;
		}
		if(code >= 48 && code <= 57)
		{
			if(Key.isDown(16))
			{
				TAS.saveStates[code - 48] = TAS.inputField.text;
			}
			else if(TAS.saveStates[code - 48])
			{
				TAS.inputField.text = TAS.saveStates[code - 48];
				TAS.loadInputs(false);
			}
			return true;
		}
		return false;
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
	static function loadInputs(useCaretPos)
	{
		var _loc3_ = ["i"];
		var _loc4_ = [0];
		var _loc5_ = [-1];
		var _loc6_ = [0];
		var _loc7_ = -1;
		var _loc8_ = -1;
		var _loc9_ = TAS.inputField.text;
		var _loc10_ = Selection.getCaretIndex();
		var _loc11_ = -1;
		var _loc12_ = 0;
		while(_loc12_ < _loc9_.length && "qweasdQWEADnbrp|".indexOf(_loc9_.charAt(_loc12_)) == -1)
		{
			_loc12_ = _loc12_ + 1;
		}
		var _loc13_;
		var _loc14_;
		var _loc15_;
		var _loc16_;
		while(_loc12_ < _loc9_.length)
		{
			_loc13_ = _loc9_.charAt(_loc12_);
			_loc14_ = _loc12_;
			_loc15_ = 0;
			_loc16_ = _loc12_ + 1;
			_loc12_ = _loc12_ + 1;
			while(_loc12_ < _loc9_.length && "qweasdQWEADnbrp|".indexOf(_loc9_.charAt(_loc12_)) == -1)
			{
				if(_loc9_.charCodeAt(_loc12_) >= 48 && _loc9_.charCodeAt(_loc12_) <= 57)
				{
					_loc15_ = _loc15_ * 10 + _loc9_.charCodeAt(_loc12_) - 48;
					_loc16_ = _loc12_ + 1;
				}
				_loc12_ = _loc12_ + 1;
			}
			if(_loc13_ == "|")
			{
				_loc7_ = _loc3_.length;
				_loc8_ = _loc15_;
				_loc12_ -= _loc16_ - _loc14_;
				_loc10_ -= _loc16_ - _loc14_;
				_loc9_ = _loc9_.slice(0,_loc14_) + _loc9_.slice(_loc16_);
			}
			else
			{
				if(_loc13_ != "r" && _loc15_ == 0)
				{
					_loc15_ = 1;
				}
				if(_loc3_.length == 1 && _loc5_[0] == -1 && _loc13_ == "r")
				{
					_loc4_[0] = _loc15_;
					_loc5_[0] = _loc14_;
					_loc6_[0] = _loc16_;
				}
				else
				{
					_loc3_.push(_loc13_);
					_loc4_.push(_loc15_);
					_loc5_.push(_loc14_);
					_loc6_.push(_loc16_);
				}
				if(_loc11_ == -1 && _loc10_ < _loc16_)
				{
					_loc11_ = Math.max(0,_loc3_.length - 2);
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
		if(useCaretPos)
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
		var _loc17_ = true;
		if(TAS.curIndex == _loc7_ && TAS.curFrame == _loc8_)
		{
			_loc12_ = 0;
			while(_loc12_ < _loc7_)
			{
				if(TAS.inputArray[_loc12_] != _loc3_[_loc12_] || TAS.valueArray[_loc12_] != _loc4_[_loc12_])
				{
					_loc17_ = false;
					break;
				}
				_loc12_ = _loc12_ + 1;
			}
			if(TAS.inputArray[_loc7_] != _loc3_[_loc7_])
			{
				_loc17_ = false;
			}
		}
		else
		{
			_loc17_ = false;
		}
		TAS.inputArray = _loc3_;
		TAS.valueArray = _loc4_;
		TAS.indArray = _loc5_;
		TAS.endIndArray = _loc6_;
		TAS.curString = _loc9_;
		TAS.curIndex = _loc7_;
		TAS.curFrame = _loc8_;
		if(!_loc17_)
		{
			TAS.runBack = true;
			_root.tt.doTween("reload");
		}
		else
		{
			TAS.updateText();
		}
	}
	static function updateText()
	{
		var newText;
		if(TAS.isAtStringEnd())
		{
			newText = TAS.curString;
		}
		else if(TAS.curFrame == TAS.valueArray[TAS.curIndex])
		{
			newText = TAS.curString.slice(0,TAS.indArray[TAS.curIndex + 1]) + "|" + TAS.curString.slice(TAS.indArray[TAS.curIndex + 1]);
		}
		else
		{
			newText = TAS.curString.slice(0,TAS.indArray[TAS.curIndex]) + "|" + TAS.curFrame + TAS.curString.slice(TAS.indArray[TAS.curIndex]);
		}
		TAS.inputField.text = newText;
	}
	static function foif()
	{
		return Selection.getFocus() == "_level0.window_clip.inputWindow.inputField";
	}
	static function checkKeys()
	{
		if(TAS.neutralPlayback)
		{
			return undefined;
		}
		var _loc2_;
		var _loc3_;
		var _loc4_;
		var _loc5_;
		var _loc6_;
		var _loc7_;
		if(TAS.write)
		{
			_loc2_ = com.nitrome.toxic.Global.UP_PRESSED;
			if(TAS.foif())
			{
				com.nitrome.toxic.Global.DIR_PRESSED = -1;
				com.nitrome.toxic.Global.UP_PRESSED = false;
				com.nitrome.toxic.Global.DOWN_PRESSED = false;
			}
			else
			{
				if((Key.isDown(37) || Key.isDown(65)) && (Key.isDown(39) || Key.isDown(68)))
				{
					if(com.nitrome.toxic.Global.LAST_DIR_PRESSED == com.nitrome.toxic.Global.LEFT)
					{
						com.nitrome.toxic.Global.DIR_PRESSED = com.nitrome.toxic.Global.LEFT;
					}
					else if(com.nitrome.toxic.Global.LAST_DIR_PRESSED == com.nitrome.toxic.Global.RIGHT)
					{
						com.nitrome.toxic.Global.DIR_PRESSED = com.nitrome.toxic.Global.RIGHT;
					}
				}
				else if(Key.isDown(37) || Key.isDown(65))
				{
					com.nitrome.toxic.Global.DIR_PRESSED = com.nitrome.toxic.Global.LEFT;
				}
				else if(Key.isDown(39) || Key.isDown(68))
				{
					com.nitrome.toxic.Global.DIR_PRESSED = com.nitrome.toxic.Global.RIGHT;
				}
				else
				{
					com.nitrome.toxic.Global.DIR_PRESSED = -1;
				}
				com.nitrome.toxic.Global.UP_PRESSED = Key.isDown(38) || Key.isDown(87);
				com.nitrome.toxic.Global.DOWN_PRESSED = Key.isDown(40) || Key.isDown(83);
			}
			if(_loc2_ && !com.nitrome.toxic.Global.UP_PRESSED)
			{
				com.nitrome.toxic.Global.can_jump = true;
			}
			_loc3_ = "nadwqesADWQE".charAt(com.nitrome.toxic.Global.DIR_PRESSED + 1 + int(com.nitrome.toxic.Global.UP_PRESSED) * 3 + int(com.nitrome.toxic.Global.DOWN_PRESSED) * 6);
			if(TAS.justPause)
			{
				_loc3_ = "p";
			}
			if(TAS.override)
			{
				TAS.truncateCurArray();
			}
			else
			{
				TAS.splitCurLetter();
			}
			_loc4_ = TAS.endIndArray[TAS.curIndex];
			_loc5_ = TAS.curString.slice(_loc4_);
			TAS.curString = TAS.curString.slice(0,_loc4_);
			if(TAS.justPlacedBombs > 0)
			{
				_loc6_ = 0;
				while(_loc6_ < TAS.justPlacedBombs)
				{
					_root.game.layBomb();
					_loc6_ = _loc6_ + 1;
				}
				TAS.curIndex++;
				TAS.inputArray.splice(TAS.curIndex,0,"b");
				TAS.valueArray.splice(TAS.curIndex,0,TAS.justPlacedBombs);
				TAS.indArray.splice(TAS.curIndex,0,TAS.curString.length);
				TAS.curFrame = TAS.justPlacedBombs;
				TAS.curString += "b" + (TAS.justPlacedBombs > 1 ? TAS.justPlacedBombs : "");
				TAS.endIndArray.splice(TAS.curIndex,0,TAS.curString.length);
			}
			if(_loc3_ == TAS.inputArray[TAS.curIndex])
			{
				TAS.valueArray[TAS.curIndex]++;
				TAS.curFrame++;
				TAS.curString = TAS.curString.slice(0,TAS.indArray[TAS.curIndex]) + TAS.inputArray[TAS.curIndex] + TAS.curFrame;
				TAS.endIndArray[TAS.curIndex] = TAS.curString.length;
			}
			else
			{
				TAS.curIndex++;
				TAS.inputArray.splice(TAS.curIndex,0,_loc3_);
				TAS.valueArray.splice(TAS.curIndex,0,1);
				TAS.indArray.splice(TAS.curIndex,0,TAS.curString.length);
				TAS.curFrame = 1;
				TAS.curString += _loc3_;
				TAS.endIndArray.splice(TAS.curIndex,0,TAS.curString.length);
			}
			_loc6_ = TAS.curIndex + 1;
			while(_loc6_ < TAS.inputArray.length)
			{
				TAS.indArray[_loc6_] += TAS.curString.length - _loc4_;
				TAS.endIndArray[_loc6_] += TAS.curString.length - _loc4_;
				_loc6_ = _loc6_ + 1;
			}
			TAS.curString += _loc5_;
			if(TAS.justPause)
			{
				if(!com.nitrome.toxic.Global.game_paused)
				{
					_root.popup_holder.displayPopUp("game_paused");
					_root.game.pauseGame();
				}
			}
			else if(com.nitrome.toxic.Global.game_paused)
			{
				_root.game.unpauseGame();
				_root.popup_holder.hidePopUp();
			}
		}
		else
		{
			if(TAS.curFrame >= TAS.valueArray[TAS.curIndex])
			{
				TAS.curIndex++;
				TAS.curFrame = 0;
			}
			while(TAS.inputArray[TAS.curIndex] == "b" || TAS.inputArray[TAS.curIndex] == "r")
			{
				if(TAS.inputArray[TAS.curIndex] == "b")
				{
					_loc6_ = 0;
					while(_loc6_ < TAS.valueArray[TAS.curIndex])
					{
						_root.game.layBomb();
						_loc6_ = _loc6_ + 1;
					}
				}
				else
				{
					RNG.rngSeed = TAS.valueArray[TAS.curIndex];
				}
				TAS.curIndex++;
				TAS.curFrame = 0;
			}
			_loc3_ = TAS.inputArray[TAS.curIndex];
			if(_loc3_ == "p")
			{
				if(!com.nitrome.toxic.Global.game_paused)
				{
					_root.popup_holder.displayPopUp("game_paused");
					_root.game.pauseGame();
				}
			}
			else
			{
				if(com.nitrome.toxic.Global.game_paused)
				{
					_root.game.unpauseGame();
					_root.popup_holder.hidePopUp();
				}
				_loc7_ = "nadwqesADWQE".indexOf(_loc3_);
				com.nitrome.toxic.Global.DIR_PRESSED = _loc7_ % 3 - 1;
				if(com.nitrome.toxic.Global.UP_PRESSED && _loc7_ % 6 < 3)
				{
					com.nitrome.toxic.Global.can_jump = true;
				}
				com.nitrome.toxic.Global.UP_PRESSED = _loc7_ % 6 >= 3;
				com.nitrome.toxic.Global.DOWN_PRESSED = _loc7_ >= 6;
			}
			TAS.curFrame++;
			if(TAS.fastPlayback && TAS.curIndex == TAS.targetIndex && TAS.curFrame == TAS.targetFrame)
			{
				TAS.fastPlayback = false;
			}
		}
	}
	static function levelInit()
	{
		TAS.justPause = com.nitrome.toxic.Global.game_paused;
		TAS.justPlacedBombs = 0;
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
	}
}
