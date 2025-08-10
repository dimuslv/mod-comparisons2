class TAS
{
   static var justPause;
   static var justPlacedBombs;
   static var inputField;
   static var targetIndex;
   static var targetFrame;
   static var write = true;
   static var frozen = true;
   static var curString = "";
   static var curArray = ["i",0,-1];
   static var curIndex = 0;
   static var curFrame = 0;
   static var fastPlayback = false;
   static var neutralPlayback = false;
   static var saveStates = [];
   function TAS()
   {
   }
   static function updateVarWindow(w)
   {
      var _loc3_ = _root.game.player;
      w.obj.options = ["x: " + _loc3_._x,false,"y: " + _loc3_._y,false,"vx: " + _loc3_.vx,false,"vy: " + _loc3_.vy,false,"wc: " + _loc3_.wall_count,false,"hc: " + _loc3_.hit_count,false,"st: " + ["start","stand","duck","walk","jump","fall","wall","hit","die","end"][_loc3_.state],false];
      w.updateMainField(false);
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
         else if(code == 221)
         {
            TAS.loadInputs(true);
         }
         else if(code == 219)
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
         TAS.curIndex = 0;
         TAS.curFrame = TAS.curArray[1];
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
         Windows.clip.varWindow._visible = !Windows.clip.varWindow._visible;
         return true;
      }
      if(code == 73)
      {
         Windows.clip.inputWindow._visible = !Windows.clip.inputWindow._visible;
         return true;
      }
      if(code == 191)
      {
         TAS.write = true;
         TAS.frozen = !TAS.frozen;
         return true;
      }
      if(code == 190)
      {
         TAS.frozen = true;
         TAS.write = true;
         Main.gameUpdate();
         TAS.updateText();
         Main.stopAll();
         return true;
      }
      if(code == 188)
      {
         TAS.frozen = true;
         TAS.write = true;
         if(TAS.curIndex > 0)
         {
            TAS.curFrame--;
            if(TAS.curFrame <= 0)
            {
               do
               {
                  TAS.curIndex -= 3;
               }
               while("rb".indexOf(TAS.curArray[TAS.curIndex]) != -1);
               
               TAS.curFrame = TAS.curArray[TAS.curIndex + 1];
            }
            TAS.truncateCurArray();
            _root.tt.doTween("reload");
         }
         return true;
      }
      if(code == 222)
      {
         TAS.write = false;
         TAS.frozen = !TAS.frozen;
         return true;
      }
      if(code == 186)
      {
         TAS.frozen = true;
         TAS.write = false;
         if(TAS.curIndex < TAS.curArray.length - 3 || TAS.curFrame < TAS.curArray[TAS.curArray.length - 2])
         {
            Main.gameUpdate();
            TAS.updateText();
            Main.stopAll();
         }
         return true;
      }
      if(code == 76)
      {
         TAS.frozen = true;
         TAS.write = false;
         if(TAS.curIndex > 0)
         {
            TAS.curFrame--;
            if(TAS.curFrame <= 0)
            {
               do
               {
                  TAS.curIndex -= 3;
               }
               while("rb".indexOf(TAS.curArray[TAS.curIndex]) != -1);
               
               TAS.curFrame = TAS.curArray[TAS.curIndex + 1];
            }
            _root.tt.doTween("reload");
         }
         return true;
      }
      if(code == 82)
      {
         TAS.curIndex = 0;
         TAS.curFrame = TAS.curArray[1];
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
      TAS.curArray.length = TAS.curIndex + 3;
      TAS.curArray[TAS.curIndex + 1] = TAS.curFrame;
      if(TAS.curIndex == 0)
      {
         if(TAS.curArray[2] == -1)
         {
            TAS.curString = "";
         }
         else
         {
            TAS.curString = TAS.curString.slice(0,TAS.curArray[2]) + "r" + TAS.curArray[1];
         }
      }
      else
      {
         TAS.curString = TAS.curString.slice(0,TAS.curArray[TAS.curIndex + 2]) + TAS.curArray[TAS.curIndex] + (TAS.curFrame == 1 ? "" : TAS.curFrame);
      }
   }
   static function loadInputs(useCaretPos)
   {
      var _loc3_ = [];
      var _loc4_ = -3;
      var _loc5_ = 0;
      var _loc6_ = "";
      var _loc7_ = 0;
      var _loc8_ = 0;
      var _loc9_ = TAS.inputField.text;
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
      if(TAS.curIndex == _loc4_ && TAS.curFrame == _loc5_)
      {
         _loc12_ = 0;
         while(_loc12_ < _loc4_)
         {
            if(TAS.curArray[_loc12_] != _loc3_[_loc12_] || TAS.curArray[_loc12_ + 1] != _loc3_[_loc12_ + 1])
            {
               _loc17_ = false;
               break;
            }
            _loc12_ += 3;
         }
         if(TAS.curArray[_loc4_] != _loc3_[_loc4_])
         {
            _loc17_ = false;
         }
      }
      else
      {
         _loc17_ = false;
      }
      TAS.curArray = _loc3_;
      TAS.curString = _loc6_;
      TAS.curIndex = _loc4_;
      TAS.curFrame = _loc5_;
      if(!_loc17_)
      {
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
      if(TAS.curIndex == TAS.curArray.length - 3 && TAS.curFrame == TAS.curArray[TAS.curArray.length - 2])
      {
         newText = TAS.curString;
      }
      else if(TAS.curFrame == TAS.curArray[TAS.curIndex + 1])
      {
         newText = TAS.curString.slice(0,TAS.curArray[TAS.curIndex + 5]) + "|" + TAS.curString.slice(TAS.curArray[TAS.curIndex + 5]);
      }
      else
      {
         newText = TAS.curString.slice(0,TAS.curArray[TAS.curIndex + 2]) + "|" + TAS.curFrame + TAS.curString.slice(TAS.curArray[TAS.curIndex + 2]);
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
         if(TAS.curIndex == -3)
         {
            TAS.curArray = [_loc3_,1,0];
            TAS.curString = _loc3_;
            TAS.curIndex = 0;
            TAS.curFrame = 1;
         }
         else
         {
            TAS.truncateCurArray();
            if(TAS.justPlacedBombs > 0)
            {
               _loc4_ = 0;
               while(_loc4_ < TAS.justPlacedBombs)
               {
                  _root.game.layBomb();
                  _loc4_ = _loc4_ + 1;
               }
               TAS.curArray.push("b",TAS.justPlacedBombs,TAS.curString.length);
               TAS.curIndex += 3;
               TAS.curFrame = TAS.justPlacedBombs;
               TAS.curString += "b" + (TAS.justPlacedBombs > 1 ? TAS.justPlacedBombs : "");
            }
            if(_loc3_ == TAS.curArray[TAS.curIndex])
            {
               TAS.curArray[TAS.curIndex + 1]++;
               TAS.curFrame++;
               TAS.curString = TAS.curString.slice(0,TAS.curArray[TAS.curIndex + 2]) + TAS.curArray[TAS.curIndex] + TAS.curFrame;
            }
            else
            {
               TAS.curArray.push(_loc3_,1,TAS.curString.length);
               TAS.curIndex += 3;
               TAS.curFrame = 1;
               TAS.curString += _loc3_;
            }
         }
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
         if(TAS.curIndex == -3)
         {
            TAS.curIndex = 0;
            TAS.curFrame = 0;
         }
         else if(TAS.curFrame >= TAS.curArray[TAS.curIndex + 1])
         {
            TAS.curIndex += 3;
            TAS.curFrame = 0;
         }
         while(TAS.curArray[TAS.curIndex] == "b" || TAS.curArray[TAS.curIndex] == "r")
         {
            if(TAS.curArray[TAS.curIndex] == "b")
            {
               _loc4_ = TAS.curFrame;
               while(_loc4_ < TAS.curArray[TAS.curIndex + 1])
               {
                  _root.game.layBomb();
                  _loc4_ = _loc4_ + 1;
               }
            }
            else
            {
               RNG.rngSeed = TAS.curArray[TAS.curIndex + 1];
            }
            TAS.curIndex += 3;
            TAS.curFrame = 0;
         }
         _loc3_ = TAS.curArray[TAS.curIndex];
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
      TAS.curFrame = TAS.curArray[1];
      TAS.fastPlayback = true;
      TAS.neutralPlayback = true;
      var _loc6_ = 0;
      while(_loc6_ < 109)
      {
         Main.gameUpdate();
         _loc6_ = _loc6_ + 1;
      }
      TAS.neutralPlayback = false;
      while(TAS.curIndex < TAS.targetIndex || TAS.curIndex == TAS.targetIndex && TAS.curFrame < TAS.targetFrame)
      {
         Main.gameUpdate();
      }
      TAS.fastPlayback = false;
      TAS.write = _loc5_;
      TAS.updateText();
   }
}
