_root.write = true;
_root.frozen = true;
_root.curString = "";
_root.curArray = ["i",0,-1];
_root.curIndex = 0;
_root.curFrame = 0;
_root.fastPlayback = false;
_root.saveStates = [];
_root.createTextField("inputField",_root.getNextHighestDepth(),10,380,530,15);
_root.inputField.autoSize = false;
_root.inputField.type = "input";
_root.inputField.background = true;
_root.inputField._visible = false;
_root.inputField.restrict = "^[]i";
_root.createTextField("varField",_root.getNextHighestDepth(),10,40,20,350);
_root.varField._visible = false;
_root.varField.background = true;
_root.varField.autoSize = true;
_root.updateVarField = function()
{
   var _loc2_ = _root.game.player;
   _root.varField.text = "x: " + _loc2_._x + "\ny: " + _loc2_._y + "\nvx: " + _loc2_.vx + "\nvy: " + _loc2_.vy + "\nwc: " + _loc2_.wall_count + "\nhc: " + _loc2_.hit_count;
};
_root.doKeyDown = function(code)
{
   if(_root.doTasKeyDown(code))
   {
      return undefined;
   }
   if(_root.write || true)
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
         _root.justPlacedBombs++;
      }
      else if(code == 78)
      {
         if(_root.justPlacedBombs > 0)
         {
            _root.justPlacedBombs--;
         }
      }
      else if(code == 80)
      {
         _root.justPause = !_root.justPause;
      }
   }
};
_root.doTasKeyDown = function(code)
{
   if(code == 13)
   {
      _root.loadInputs(false);
      return true;
   }
   if(_root.foif())
   {
      if(code == 73)
      {
         _root.inputField._visible = !_root.inputField._visible;
         Selection.setFocus(ClockDisp.instances[0].m_text);
         Selection.setSelection(0,0);
         _root.loadInputs(false);
      }
      else if(code == 27 || code == 112)
      {
         Selection.setFocus(ClockDisp.instances[0].m_text);
         Selection.setSelection(0,0);
         _root.loadInputs(false);
      }
      else if(code == 221)
      {
         _root.loadInputs(true);
      }
      else if(code == 219)
      {
         _root.loadInputs(true);
         Selection.setFocus(_root.varField);
         Selection.setSelection(0,0);
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
   if(code == 67)
   {
      _root.varField._visible = !_root.varField._visible;
   }
   if(code == 73)
   {
      _root.inputField._visible = !_root.inputField._visible;
      Selection.setFocus(ClockDisp.instances[0].m_text);
      Selection.setSelection(0,0);
      return true;
   }
   if(code == 191)
   {
      _root.write = true;
      _root.frozen = !_root.frozen;
      return true;
   }
   if(code == 190)
   {
      _root.frozen = true;
      _root.write = true;
      _root.doEnterFrame();
      _root.updateText();
      _root.stopAll();
      return true;
   }
   if(code == 188)
   {
      _root.frozen = true;
      _root.write = true;
      if(_root.curIndex > 0)
      {
         _root.curFrame--;
         if(_root.curFrame <= 0)
         {
            do
            {
               _root.curIndex -= 3;
            }
            while("rb".indexOf(_root.curArray[_root.curIndex]) != -1);
            
            _root.curFrame = _root.curArray[_root.curIndex + 1];
         }
         _root.truncateCurArray();
         _root.tt.doTween("reload");
      }
      return true;
   }
   if(code == 222)
   {
      _root.write = false;
      _root.frozen = !_root.frozen;
      return true;
   }
   if(code == 186)
   {
      _root.frozen = true;
      _root.write = false;
      if(_root.curIndex < _root.curArray.length - 3 || _root.curFrame < _root.curArray[_root.curArray.length - 2])
      {
         _root.doEnterFrame();
         _root.updateText();
         _root.stopAll();
      }
      return true;
   }
   if(code == 76)
   {
      _root.frozen = true;
      _root.write = false;
      if(_root.curIndex > 0)
      {
         _root.curFrame--;
         if(_root.curFrame <= 0)
         {
            do
            {
               _root.curIndex -= 3;
            }
            while("rb".indexOf(_root.curArray[_root.curIndex]) != -1);
            
            _root.curFrame = _root.curArray[_root.curIndex + 1];
         }
         _root.tt.doTween("reload");
      }
      return true;
   }
   if(code == 82)
   {
      _root.curIndex = 0;
      _root.curFrame = _root.curArray[1];
      _root.write = false;
      _root.frozen = false;
      _root.tt.doTween("reload");
      return true;
   }
   if(code >= 48 && code <= 57)
   {
      if(Key.isDown(16))
      {
         _root.saveStates[code - 48] = _root.inputField.text;
      }
      else if(_root.saveStates[code - 48])
      {
         _root.inputField.text = _root.saveStates[code - 48];
         _root.loadInputs(false);
      }
      return true;
   }
   return false;
};
_root.truncateCurArray = function()
{
   _root.curArray.length = _root.curIndex + 3;
   _root.curArray[_root.curIndex + 1] = _root.curFrame;
   if(_root.curIndex == 0)
   {
      if(_root.curArray[2] == -1)
      {
         _root.curString = "";
      }
      else
      {
         _root.curString = _root.curString.slice(0,_root.curArray[2]) + "r" + _root.curArray[1];
      }
   }
   else
   {
      _root.curString = _root.curString.slice(0,_root.curArray[_root.curIndex + 2]) + _root.curArray[_root.curIndex] + (_root.curFrame == 1 ? "" : _root.curFrame);
   }
};
_root.loadInputs = function(useCaretPos)
{
   var _loc3_ = [];
   var _loc4_ = -3;
   var _loc5_ = 0;
   var _loc6_ = "";
   var _loc7_ = 0;
   var _loc8_ = 0;
   var _loc9_ = _root.inputField.text;
   var _loc10_ = Selection.getCaretIndex();
   var _loc11_ = -3;
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
      _loc16_ = _loc12_;
      _loc12_ = _loc12_ + 1;
      while(_loc12_ < _loc9_.length && "qweasdQWEADnbrp|".indexOf(_loc9_.charAt(_loc12_)) == -1)
      {
         if(_loc9_.charCodeAt(_loc12_) >= 48 && _loc9_.charCodeAt(_loc12_) <= 57)
         {
            _loc15_ = _loc15_ * 10 + _loc9_.charCodeAt(_loc12_) - 48;
            _loc16_ = _loc12_;
         }
         _loc12_ = _loc12_ + 1;
      }
      if(_loc13_ == "|")
      {
         _loc4_ = _loc3_.length;
         _loc5_ = _loc15_;
         _loc6_ += _loc9_.slice(_loc7_,_loc14_);
         _loc7_ = _loc16_ + 1;
         _loc8_ += _loc16_ + 1 - _loc14_;
      }
      else
      {
         if(_loc13_ != "r" && _loc15_ == 0)
         {
            _loc15_ = 1;
         }
         if(_loc3_.length == 0)
         {
            if(_loc13_ == "r")
            {
               _loc3_ = ["i",_loc15_,_loc14_ - _loc8_];
            }
            else
            {
               _loc3_ = ["i",0,-1,_loc13_,_loc15_,_loc14_ - _loc8_];
            }
         }
         else
         {
            _loc3_.push(_loc13_,_loc15_,_loc14_ - _loc8_);
         }
         if(_loc11_ == -3 && _loc10_ <= _loc16_)
         {
            _loc11_ = Math.max(0,_loc3_.length - 6);
         }
      }
   }
   _loc6_ += _loc9_.slice(_loc7_);
   if(_loc3_.length == 0)
   {
      _loc3_ = ["i",0,-1];
      _loc4_ = 0;
      _loc5_ = 0;
   }
   else
   {
      if("rb".indexOf(_loc3_[_loc3_.length - 3]) != -1)
      {
         _loc3_.push("n",1,_loc6_.length);
         _loc6_ += "n";
      }
      if(useCaretPos)
      {
         _loc4_ = _loc11_;
         if(_loc11_ == -3)
         {
            _loc4_ = _loc3_.length - 3;
         }
         _loc5_ = _loc3_[_loc4_ + 1];
      }
      else if(_loc4_ == -3 || _loc4_ == _loc3_.length)
      {
         _loc4_ = _loc3_.length - 3;
         _loc5_ = _loc3_[_loc4_ + 1];
      }
      else if(_loc4_ == 0)
      {
         _loc5_ = _loc3_[1];
      }
      else if(_loc5_ == 0)
      {
         _loc4_ -= 3;
         _loc5_ = _loc3_[_loc4_ + 1];
      }
      else
      {
         _loc5_ = Math.min(_loc5_,_loc3_[_loc4_ + 1]);
      }
      if("rb".indexOf(_loc3_[_loc4_]) != -1)
      {
         while("rb".indexOf(_loc3_[_loc4_]) != -1)
         {
            _loc4_ -= 3;
         }
         _loc5_ = _loc3_[_loc4_ + 1];
      }
   }
   var _loc17_ = true;
   if(_root.curIndex == _loc4_ && _root.curFrame == _loc5_)
   {
      _loc12_ = 0;
      while(_loc12_ < _loc4_)
      {
         if(_root.curArray[_loc12_] != _loc3_[_loc12_] || _root.curArray[_loc12_ + 1] != _loc3_[_loc12_ + 1])
         {
            _loc17_ = false;
            break;
         }
         _loc12_ += 3;
      }
      if(_root.curArray[_loc4_] != _loc3_[_loc4_])
      {
         _loc17_ = false;
      }
   }
   else
   {
      _loc17_ = false;
   }
   _root.curArray = _loc3_;
   _root.curString = _loc6_;
   _root.curIndex = _loc4_;
   _root.curFrame = _loc5_;
   if(!_loc17_)
   {
      _root.tt.doTween("reload");
   }
   else
   {
      _root.updateText();
   }
};
_root.updateText = function()
{
   _loc2_;
   var _loc2_;
   if(_root.curIndex == _root.curArray.length - 3 && _root.curFrame == _root.curArray[_root.curArray.length - 2])
   {
      _loc2_ = _root.curString;
   }
   else if(_root.curFrame == _root.curArray[_root.curIndex + 1])
   {
      _loc2_ = _root.curString.slice(0,_root.curArray[_root.curIndex + 5]) + "|" + _root.curString.slice(_root.curArray[_root.curIndex + 5]);
   }
   else
   {
      _loc2_ = _root.curString.slice(0,_root.curArray[_root.curIndex + 2]) + "|" + _root.curFrame + _root.curString.slice(_root.curArray[_root.curIndex + 2]);
   }
   _root.inputField.text = _loc2_;
};
_root.foif = function()
{
   return Selection.getFocus() == "_level0.inputField";
};
_root.checkKeys = function()
{
   if(_root.neutralPlayback)
   {
      return undefined;
   }
   var _loc2_;
   var _loc3_;
   var _loc4_;
   var _loc5_;
   if(_root.write)
   {
      _loc2_ = com.nitrome.toxic.Global.UP_PRESSED;
      if(_root.foif())
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
      if(_root.justPause)
      {
         _loc3_ = "p";
      }
      if(_root.curIndex == -3)
      {
         _root.curArray = [_loc3_,1,0];
         _root.curString = _loc3_;
         _root.curIndex = 0;
         _root.curFrame = 1;
      }
      else
      {
         _root.truncateCurArray();
         if(_root.justPlacedBombs > 0)
         {
            _loc4_ = 0;
            while(_loc4_ < _root.justPlacedBombs)
            {
               _root.game.layBomb();
               _loc4_ = _loc4_ + 1;
            }
            _root.curArray.push("b",_root.justPlacedBombs,_root.curString.length);
            _root.curIndex += 3;
            _root.curFrame = _root.justPlacedBombs;
            _root.curString += "b" + (_root.justPlacedBombs > 1 ? _root.justPlacedBombs : "");
         }
         if(_loc3_ == _root.curArray[_root.curIndex])
         {
            _root.curArray[_root.curIndex + 1]++;
            _root.curFrame++;
            _root.curString = _root.curString.slice(0,_root.curArray[_root.curIndex + 2]) + _root.curArray[_root.curIndex] + _root.curFrame;
         }
         else
         {
            _root.curArray.push(_loc3_,1,_root.curString.length);
            _root.curIndex += 3;
            _root.curFrame = 1;
            _root.curString += _loc3_;
         }
      }
      if(_root.justPause)
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
      if(_root.curIndex == -3)
      {
         _root.curIndex = 0;
         _root.curFrame = 0;
      }
      else if(_root.curFrame >= _root.curArray[_root.curIndex + 1])
      {
         _root.curIndex += 3;
         _root.curFrame = 0;
      }
      while(_root.curArray[_root.curIndex] == "b" || _root.curArray[_root.curIndex] == "r")
      {
         if(_root.curArray[_root.curIndex] == "b")
         {
            _loc4_ = _root.curFrame;
            while(_loc4_ < _root.curArray[_root.curIndex + 1])
            {
               _root.game.layBomb();
               _loc4_ = _loc4_ + 1;
            }
         }
         else
         {
            _root.rngSeed = _root.curArray[_root.curIndex + 1];
         }
         _root.curIndex += 3;
         _root.curFrame = 0;
      }
      _loc3_ = _root.curArray[_root.curIndex];
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
         _loc5_ = "nadwqesADWQE".indexOf(_loc3_);
         com.nitrome.toxic.Global.DIR_PRESSED = _loc5_ % 3 - 1;
         if(com.nitrome.toxic.Global.UP_PRESSED && _loc5_ % 6 < 3)
         {
            com.nitrome.toxic.Global.can_jump = true;
         }
         com.nitrome.toxic.Global.UP_PRESSED = _loc5_ % 6 >= 3;
         com.nitrome.toxic.Global.DOWN_PRESSED = _loc5_ >= 6;
      }
      _root.curFrame++;
   }
};
_root.tasStart = function()
{
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
         _root._gotoAndPlay(_loc4_.bubbles,_root._random(267) + 1);
      }
      else if(_loc4_.anim)
      {
         _root._gotoAndPlay(_loc4_.anim,_root._random(267) + 1);
      }
   }
   com.nitrome.toxic.Global.can_jump = true;
   var _loc5_ = _root.write;
   _root.write = false;
   var _loc6_ = _root.curIndex;
   var _loc7_ = _root.curFrame;
   _root.curIndex = 0;
   _root.curFrame = _root.curArray[1];
   _root.fastPlayback = true;
   _root.neutralPlayback = true;
   var _loc8_ = 0;
   while(_loc8_ < 109)
   {
      _root.doEnterFrame();
      _loc8_ = _loc8_ + 1;
   }
   _root.neutralPlayback = false;
   while(_root.curIndex < _loc6_ || _root.curIndex == _loc6_ && _root.curFrame < _loc7_)
   {
      _root.doEnterFrame();
   }
   _root.fastPlayback = false;
   _root.write = _loc5_;
   _root.updateText();
};
