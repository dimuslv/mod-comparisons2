_root.init = function()
{
   _root.justPause = com.nitrome.toxic.Global.game_paused;
   _root.justPlacedBombs = 0;
   var _loc2_ = _root.game;
   _root.holders = [_loc2_.heart_holder,_loc2_.object_holder,_loc2_.safe_holder,_loc2_.danger_holder,_loc2_.laser_holder,_loc2_.player_holder,_loc2_.grow_holder,_loc2_.bomb_holder,_loc2_.missile_holder,_loc2_.splash_holder,_loc2_.acid_holder,_loc2_.explosion_holder];
   _root.tasStart();
   _root.stopAll();
};
_root.perform = function()
{
   if(!_root.frozen)
   {
      if(!_root.write && (_root.curArray.length == 0 || _root.curIndex >= _root.curArray.length || _root.curIndex == _root.curArray.length - 3 && _root.curFrame >= _root.curArray[_root.curIndex + 1]))
      {
         _root.frozen = true;
      }
      else
      {
         _root.doEnterFrame();
         _root.updateText();
         _root.stopAll();
      }
   }
   _root.updateVarField();
};
_root.doEnterFrame = function()
{
   _root.checkKeys();
   _root.scriptStack = [];
   _root.updateAnimations();
   var _loc2_ = _root.scriptStack;
   _root.scriptStack = [];
   _root.executeScripts(_loc2_);
   _root.game.doEnterFrame();
   _root.doEnterFrameBeacon();
   _root.executeScripts(_root.scriptStack);
   _root.justPause = com.nitrome.toxic.Global.game_paused;
   _root.justPlacedBombs = 0;
};
_root.executeScripts = function(stack)
{
   var _loc2_ = 0;
   while(_loc2_ < stack.length)
   {
      stack[_loc2_ + 1](stack[_loc2_]);
      _loc2_ += 2;
   }
};
_root.updateAnimations = function()
{
   var _loc2_ = 0;
   var _loc4_;
   while(_loc2_ < _root.holders.length)
   {
      for(var _loc3_ in _root.holders[_loc2_])
      {
         _loc4_ = _root.holders[_loc2_][_loc3_];
         _root.advanceAnimation(_loc4_,_loc4_.chid);
      }
      _loc2_ = _loc2_ + 1;
   }
};
_root.advanceAnimation = function(obj, chid)
{
   if(!chid)
   {
      return undefined;
   }
   var _loc4_ = _root.spriteInfo["m" + chid];
   if(!_loc4_)
   {
      return undefined;
   }
   var _loc5_;
   if(_loc4_.length > 1)
   {
      _loc5_ = 0;
      while(_loc5_ < _loc4_[1].length)
      {
         if(obj[_loc4_[1][_loc5_]])
         {
            obj[_loc4_[1][_loc5_]].justExisted = true;
         }
         _loc5_ += 2;
      }
   }
   if(_loc4_[0] && !obj.stopped)
   {
      if(obj._currentframe >= obj._totalframes)
      {
         obj.gotoAndStop(1);
      }
      else
      {
         obj.nextFrame();
      }
      if(typeof _loc4_[0] == "object")
      {
         if(_loc4_[0]["f" + obj._currentframe])
         {
            _root.scriptStack.push(obj,_loc4_[0]["f" + obj._currentframe]);
         }
      }
   }
   var _loc6_;
   var _loc7_;
   if(_loc4_.length > 1)
   {
      _loc5_ = 0;
      while(_loc5_ < _loc4_[1].length)
      {
         _loc6_ = obj[_loc4_[1][_loc5_]];
         if(_loc6_)
         {
            _loc7_ = _root.determineChildChid(obj,_loc4_[1][_loc5_ + 1]);
            if(_loc6_.justExisted)
            {
               _root.advanceAnimation(_loc6_,_loc7_);
            }
            else
            {
               _root.checkFrameScript(_loc6_,_loc7_);
            }
         }
         _loc5_ += 2;
      }
   }
};
_root.determineChildChid = function(obj, chid)
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
};
_root.checkFrameScript = function(obj, chid)
{
   if(!chid)
   {
      return undefined;
   }
   var _loc4_ = _root.spriteInfo["m" + chid];
   if(!_loc4_)
   {
      return undefined;
   }
   if(typeof _loc4_[0] == "object")
   {
      if(_loc4_[0]["f" + obj._currentframe])
      {
         _root.scriptStack.push(obj,_loc4_[0]["f" + obj._currentframe]);
      }
   }
   var _loc5_;
   var _loc6_;
   var _loc7_;
   if(_loc4_.length > 1)
   {
      _loc5_ = 0;
      while(_loc5_ < _loc4_[1].length)
      {
         _loc6_ = obj[_loc4_[1][_loc5_]];
         if(_loc6_)
         {
            _loc7_ = _root.determineChildChid(obj,_loc4_[1][_loc5_ + 1]);
            _root.checkFrameScript(_loc6_,_loc7_);
         }
         _loc5_ += 2;
      }
   }
};
_root._stop = function(that)
{
   if(_root.aMode)
   {
      that.stopped = true;
   }
   else
   {
      that.stop();
   }
};
_root._play = function(that)
{
   if(_root.aMode)
   {
      that.stopped = false;
   }
   else
   {
      that.play();
   }
};
_root._gotoAndStop = function(that, frame, chid)
{
   _root._gotoAnd(that,frame,chid,true);
};
_root._gotoAndPlay = function(that, frame, chid)
{
   _root._gotoAnd(that,frame,chid,false);
};
_root._gotoAnd = function(that, frame, chid, doStop)
{
   var _loc6_;
   var _loc7_;
   var _loc8_;
   var _loc9_;
   var _loc10_;
   if(_root.aMode)
   {
      if(chid)
      {
         _loc6_ = _root.spriteInfo["m" + chid];
         if(!_loc6_)
         {
            _root._gotoAnd(that,frame,0,doStop);
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
                  _root.scriptStack.push(that,_loc6_[0]["f" + obj._currentframe]);
               }
            }
            if(_loc6_.length > 1)
            {
               _loc7_ = 0;
               while(_loc7_ < _loc6_[1].length)
               {
                  _loc9_ = that[_loc6_[1][_loc7_]];
                  if(_loc9_ && !_loc9_.justExisted)
                  {
                     _loc10_ = _root.determineChildChid(that,_loc6_[1][_loc7_ + 1]);
                     _root.checkFrameScript(_loc9_,_loc10_);
                  }
                  _loc7_ += 2;
               }
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
};
_root.stopAll = function()
{
   var _loc2_ = 0;
   var _loc4_;
   while(_loc2_ < _root.holders.length)
   {
      for(var _loc3_ in _root.holders[_loc2_])
      {
         _loc4_ = _root.holders[_loc2_][_loc3_];
         _root.stopAnimation(_loc4_,_loc4_.chid);
      }
      _loc2_ = _loc2_ + 1;
   }
};
_root.stopAnimation = function(obj, chid)
{
   obj.stop();
   if(!chid)
   {
      return undefined;
   }
   var _loc4_ = _root.spriteInfo["m" + chid];
   if(!_loc4_)
   {
      return undefined;
   }
   var _loc5_;
   var _loc6_;
   var _loc7_;
   if(_loc4_.length > 1)
   {
      _loc5_ = 0;
      while(_loc5_ < _loc4_[1].length)
      {
         _loc6_ = obj[_loc4_[1][_loc5_]];
         if(_loc6_)
         {
            _loc7_ = _root.determineChildChid(obj,_loc4_[1][_loc5_ + 1]);
            _root.stopAnimation(_loc6_,_loc7_);
         }
         _loc5_ += 2;
      }
   }
};
