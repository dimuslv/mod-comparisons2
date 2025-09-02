class Main
{
   static var spriteInfo;
   static var holders;
   static var scriptStack;
   function Main()
   {
   }
   static function init()
   {
      _root.aMode = true;
      _root._random = RNG._random;
      _root._random_double = RNG._random_double;
      _root._stop = Main._stop;
      _root._play = Main._play;
      _root._gotoAndStop = Main._gotoAndStop;
      _root._gotoAndPlay = Main._gotoAndPlay;
      _root.updateTestBitmap = function(a)
      {
         return undefined;
      };
      Main.spriteInfo = _root.spriteInfo;
      Windows.init();
   }
   static function levelInit()
   {
      var _loc2_ = _root.game;
      Main.holders = [_loc2_.heart_holder,_loc2_.object_holder,_loc2_.safe_holder,_loc2_.danger_holder,_loc2_.laser_holder,_loc2_.player_holder,_loc2_.grow_holder,_loc2_.bomb_holder,_loc2_.missile_holder,_loc2_.splash_holder,_loc2_.acid_holder,_loc2_.explosion_holder];
      TAS.levelInit();
      Utils.levelInit();
      Main.stopAll();
   }
   static function metaUpdate()
   {
      if(TAS.delayedCaretIndex != -1)
      {
         Selection.setFocus(Windows.clip.inputWindow.inputField);
         Selection.setSelection(TAS.delayedCaretIndex,TAS.delayedCaretIndex);
         TAS.delayedCaretIndex = -1;
      }
      if(!TAS.frozen)
      {
         if(!TAS.write && TAS.isAtStringEnd())
         {
            TAS.frozen = true;
         }
         else
         {
            Main.gameUpdate();
            TAS.updateText();
            Main.stopAll();
         }
      }
   }
   static function gameUpdate()
   {
      TAS.checkKeys();
      Main.scriptStack = [];
      Main.updateAnimations();
      var _loc2_ = Main.scriptStack;
      Main.scriptStack = [];
      Main.executeScripts(_loc2_);
      _root.game.doEnterFrame();
      _root.doEnterFrameBeacon();
      Main.executeScripts(Main.scriptStack);
      TAS.justPause = com.nitrome.toxic.Global.game_paused;
      TAS.justPlacedBombs = 0;
   }
   static function executeScripts(stack)
   {
      var _loc2_ = 0;
      while(_loc2_ < stack.length)
      {
         stack[_loc2_ + 1](stack[_loc2_]);
         _loc2_ += 2;
      }
   }
   static function updateAnimations()
   {
      var i = 0;
      while(i < Main.holders.length)
      {
         for(var objName in Main.holders[i])
         {
            var obj = Main.holders[i][objName];
            Main.advanceAnimation(obj,obj.chid);
         }
         i++;
      }
   }
   static function iterateOnChildren(obj, childArray, fun1, fun2)
   {
      var _loc5_ = 0;
      var _loc6_;
      var _loc7_;
      while(_loc5_ < childArray.length)
      {
         _loc6_ = obj[childArray[_loc5_]];
         if(_loc6_)
         {
            _loc7_ = Main.determineChildChid(obj,childArray[_loc5_ + 1]);
            if(!_loc6_.justExisted)
            {
               fun1(_loc6_,_loc7_);
            }
            else if(fun2)
            {
               fun2(_loc6_,_loc7_);
            }
         }
         _loc5_ += 2;
      }
   }
   static function determineChildChid(obj, chid)
   {
      var _loc3_;
      if(typeof chid != "number")
      {
         _loc3_ = 0;
         while(_loc3_ < chid.length)
         {
            if(obj._currentframe >= chid[_loc3_])
            {
               return chid[_loc3_ + 1];
            }
            _loc3_ += 2;
         }
         return 0;
      }
      return chid;
   }
   static function advanceAnimation(obj, chid)
   {
      if(!chid)
      {
         return undefined;
      }
      var _loc3_ = Main.spriteInfo["m" + chid];
      if(!_loc3_)
      {
         return undefined;
      }
      var _loc4_;
      if(_loc3_.length > 1)
      {
         _loc4_ = 0;
         while(_loc4_ < _loc3_[1].length)
         {
            if(obj[_loc3_[1][_loc4_]])
            {
               obj[_loc3_[1][_loc4_]].justExisted = true;
            }
            _loc4_ += 2;
         }
      }
      if(_loc3_[0] && !obj.stopped)
      {
         if(obj._currentframe >= obj._totalframes)
         {
            obj.gotoAndStop(1);
         }
         else
         {
            obj.nextFrame();
         }
         if(typeof _loc3_[0] == "object")
         {
            if(_loc3_[0]["f" + obj._currentframe])
            {
               Main.scriptStack.push(obj,_loc3_[0]["f" + obj._currentframe]);
            }
         }
      }
      if(_loc3_.length > 1)
      {
         Main.iterateOnChildren(obj,_loc3_[1],Main.checkFrameScript,Main.advanceAnimation);
      }
   }
   static function checkFrameScript(obj, chid)
   {
      if(!chid)
      {
         return undefined;
      }
      var _loc3_ = Main.spriteInfo["m" + chid];
      if(!_loc3_)
      {
         return undefined;
      }
      if(typeof _loc3_[0] == "object")
      {
         if(_loc3_[0]["f" + obj._currentframe])
         {
            Main.scriptStack.push(obj,_loc3_[0]["f" + obj._currentframe]);
         }
      }
      if(_loc3_.length > 1)
      {
         Main.iterateOnChildren(obj,_loc3_[1],Main.checkFrameScript,Main.checkFrameScript);
      }
   }
   static function _gotoAnd(that, frame, chid, doStop)
   {
      var _loc6_;
      var _loc7_;
      var _loc8_;
      if(_root.aMode)
      {
         if(chid)
         {
            _loc6_ = Main.spriteInfo["m" + chid];
            if(!_loc6_)
            {
               Main._gotoAnd(that,frame,0,doStop);
               return undefined;
            }
            if(_loc6_.length > 1)
            {
               _loc7_ = 0;
               while(_loc7_ < _loc6_[1].length)
               {
                  if(that[_loc6_[1][_loc7_]])
                  {
                     that[_loc6_[1][_loc7_]].justExisted = true;
                  }
                  _loc7_ += 2;
               }
            }
            _loc8_ = that._currentframe;
            that.gotoAndStop(frame);
            that.stopped = doStop;
            if(_loc8_ != that._currentframe)
            {
               if(typeof _loc6_[0] == "object")
               {
                  if(_loc6_[0]["f" + that._currentframe])
                  {
                     Main.scriptStack.push(that,_loc6_[0]["f" + obj._currentframe]);
                  }
               }
               if(_loc6_.length > 1)
               {
                  Main.iterateOnChildren(that,_loc6_[1],Main.checkFrameScript,false);
               }
            }
         }
         else
         {
            that.gotoAndStop(frame);
            that.stopped = doStop;
         }
      }
      else if(doStop)
      {
         that.gotoAndStop(frame);
      }
      else
      {
         that.gotoAndPlay(frame);
      }
   }
   static function _gotoAndStop(that, frame, chid)
   {
      Main._gotoAnd(that,frame,chid,true);
   }
   static function _gotoAndPlay(that, frame, chid)
   {
      Main._gotoAnd(that,frame,chid,false);
   }
   static function _stop(that)
   {
      if(_root.aMode)
      {
         that.stopped = true;
      }
      else
      {
         that.stop();
      }
   }
   static function _play(that)
   {
      if(_root.aMode)
      {
         that.stopped = false;
      }
      else
      {
         that.play();
      }
   }
   static function stopAll()
   {
      var i = 0;
      while(i < Main.holders.length)
      {
         for(var objName in Main.holders[i])
         {
            var obj = Main.holders[i][objName];
            Main.stopAnimation(obj,obj.chid);
         }
         i++;
      }
   }
   static function stopAnimation(obj, chid)
   {
      obj.stop();
      if(!chid)
      {
         return undefined;
      }
      var _loc3_ = Main.spriteInfo["m" + chid];
      if(!_loc3_)
      {
         return undefined;
      }
      if(_loc3_.length > 1)
      {
         Main.iterateOnChildren(obj,_loc3_[1],Main.stopAnimation,Main.stopAnimation);
      }
   }
}
