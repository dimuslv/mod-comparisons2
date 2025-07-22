class com.nitrome.toxic.FinalBoss extends MovieClip
{
   var state;
   var anim;
   var game;
   var no_transform;
   var red_transform;
   var boss_laser;
   var debris_1;
   var debris_2;
   var debris_3;
   var debris_4;
   var player;
   var laser_dir;
   var prev_weapon;
   var prev_state = 100;
   var state_array = new Array("pre","doorwait","start","grow","wait","pulse","laser","fire","growback","die");
   var PRE = 0;
   var DOORWAIT = 1;
   var START = 2;
   var GROW = 3;
   var WAIT = 4;
   var PULSE = 5;
   var LASER = 6;
   var FIRE = 7;
   var GROWBACK = 8;
   var DIE = 9;
   var hits = 5;
   var hit = false;
   var hit_count = 0;
   var max_hit_count = 120;
   var wait_count = 0;
   var door_wait_count = 50;
   var max_wait_count = 100;
   var state_wait_count = 75;
   var stage = 1;
   var adj_scroll = false;
   var hit_record = 0;
   var laser_deg = 180;
   var missile_count = 0;
   var finish_die = false;
   var die_count = 0;
   var exp_count = 0;
   var chid = 840;
   function FinalBoss()
   {
      super();
   }
   function doPause()
   {
      if(this.state == this.START)
      {
         _root._stop(this.anim);
         _root._stop(this.anim.electric);
      }
      else if(this.state == this.GROW)
      {
         _root._stop(this.anim.electric);
         _root._stop(this.anim.grow);
         _root._stop(this.anim.base.heart);
      }
      else if(this.state == this.WAIT)
      {
         _root._stop(this.anim.electric);
         _root._stop(this.anim.base.heart);
      }
      else if(this.state == this.PULSE)
      {
         _root._stop(this.anim);
         _root._stop(this.anim.electric);
         _root._stop(this.anim.base.heart);
      }
      else if(this.state == this.LASER)
      {
         _root._stop(this.anim);
         _root._stop(this.anim.electric);
         _root._stop(this.anim.base.heart);
      }
      else if(this.state == this.FIRE)
      {
         _root._stop(this.anim);
         _root._stop(this.anim.electric);
         _root._stop(this.anim.base.heart);
         _root._stop(this.anim.eye);
      }
      else if(this.state == this.GROWBACK)
      {
         _root._stop(this.anim.electric);
         _root._stop(this.anim.base.heart);
         _root._stop(_root.game.grow_holder.boss2.anim.anim);
      }
      else if(this.state == this.DIE)
      {
      }
   }
   function doUnpause()
   {
      if(this.state == this.START)
      {
         _root._play(this.anim);
         _root._play(this.anim.electric);
      }
      else if(this.state == this.GROW)
      {
         _root._play(this.anim.electric);
         _root._play(this.anim.grow);
         _root._play(this.anim.base.heart);
      }
      else if(this.state == this.WAIT)
      {
         _root._play(this.anim.electric);
         _root._play(this.anim.base.heart);
      }
      else if(this.state == this.PULSE)
      {
         _root._play(this.anim);
         _root._play(this.anim.electric);
         _root._play(this.anim.base.heart);
      }
      else if(this.state == this.LASER)
      {
         _root._play(this.anim);
         _root._play(this.anim.electric);
         _root._play(this.anim.base.heart);
      }
      else if(this.state == this.FIRE)
      {
         _root._play(this.anim);
         _root._play(this.anim.electric);
         _root._play(this.anim.base.heart);
         _root._play(this.anim.eye);
      }
      else if(this.state == this.GROWBACK)
      {
         _root._play(this.anim.electric);
         _root._play(this.anim.base.heart);
         _root._play(_root.game.grow_holder.boss2.anim.anim);
      }
      else if(this.state == this.DIE)
      {
      }
   }
   function init(game, boss_laser, debris_1, debris_2, debris_3, debris_4)
   {
      this.game = game;
      this.state = this.PRE;
      this.no_transform = this.transform.colorTransform;
      this.red_transform = new flash.geom.ColorTransform(0,1,1,1,150,0,0,0);
      this.boss_laser = boss_laser;
      this.debris_1 = debris_1;
      this.debris_2 = debris_2;
      this.debris_3 = debris_3;
      this.debris_4 = debris_4;
   }
   function finishDie()
   {
      if(this.finish_die == false)
      {
         this.game.smoothScroll();
         this.game.smoothScrollBoss();
         this.game.openDoor(1);
         this.finish_die = true;
      }
   }
   function setPlayer(player)
   {
      this.player = player;
   }
   function triggerScreenShake()
   {
      this.game.startScreenShake();
   }
   function main()
   {
      this.updateAnim();
      if(this.hit == true)
      {
         this.hit_count = this.hit_count + 1;
         if(this.hit_count % 10 == 0)
         {
            this.transform.colorTransform = this.red_transform;
            _root.game.bossbmp_holder.transform.colorTransform = this.red_transform;
         }
         else if(this.hit_count % 5 == 0)
         {
            this.transform.colorTransform = this.no_transform;
            _root.game.bossbmp_holder.transform.colorTransform = this.no_transform;
         }
         if(this.hit_count >= this.max_hit_count)
         {
            this.transform.colorTransform = this.no_transform;
            _root.game.bossbmp_holder.transform.colorTransform = this.no_transform;
            this.hit_record = 0;
            this.hit = false;
            this.stage = this.stage + 1;
            this.state = this.GROWBACK;
            _root.game.grow_holder.boss2.gotoAndStop("grow");
         }
      }
      if(this.state == this.PRE)
      {
         if(this.player._x > this._x - 57 - 164)
         {
            _root.cutscene.gotoAndPlay("in");
            this.player.quickPause();
            this.wait_count = 0;
            this.state = this.DOORWAIT;
         }
      }
      else if(this.state == this.DOORWAIT)
      {
         this.wait_count = this.wait_count + 1;
         if(this.wait_count == this.door_wait_count)
         {
            this.game.nextDoor(0);
            this.game.nextDoor(1);
         }
         if(this.wait_count >= this.max_wait_count)
         {
            this.state = this.START;
         }
      }
      else if(this.state != this.START)
      {
         if(this.state != this.GROW)
         {
            if(this.state == this.WAIT)
            {
               if(this.adj_scroll == false)
               {
                  if(this.player._x > this._x - 57 - 48 && this.player._x < this._x + 57 - 48)
                  {
                     this.game.adjustScroll(1);
                     this.adj_scroll = true;
                  }
               }
               this.wait_count = this.wait_count + 1;
               if(this.wait_count >= this.state_wait_count && this.adj_scroll == true && this.hit == false)
               {
                  if(this.stage == 1)
                  {
                     if(this.player._x < this._x)
                     {
                        this.laser_dir = 1;
                     }
                     else if(this.player._x > this._x)
                     {
                        this.laser_dir = -1;
                     }
                     this.state = this.LASER;
                  }
                  else if(this.stage == 2)
                  {
                     if(this.prev_weapon == this.LASER)
                     {
                        this.state = this.PULSE;
                     }
                     else
                     {
                        if(this.player._x < this._x)
                        {
                           this.laser_dir = 1;
                        }
                        else if(this.player._x > this._x)
                        {
                           this.laser_dir = -1;
                        }
                        this.state = this.LASER;
                     }
                  }
                  else if(this.stage == 3)
                  {
                     if(this.prev_weapon == this.LASER)
                     {
                        this.state = this.PULSE;
                     }
                     else
                     {
                        if(this.player._x < this._x)
                        {
                           this.laser_dir = 1;
                        }
                        else if(this.player._x > this._x)
                        {
                           this.laser_dir = -1;
                        }
                        this.state = this.LASER;
                     }
                  }
                  else if(this.stage == 4)
                  {
                     if(this.prev_weapon == this.LASER)
                     {
                        this.state = this.PULSE;
                     }
                     else if(this.prev_weapon == this.PULSE)
                     {
                        this.state = this.FIRE;
                     }
                     else
                     {
                        if(this.player._x < this._x)
                        {
                           this.laser_dir = 1;
                        }
                        else if(this.player._x > this._x)
                        {
                           this.laser_dir = -1;
                        }
                        this.state = this.LASER;
                     }
                  }
                  else if(this.stage == 5)
                  {
                     if(this.prev_weapon == this.LASER)
                     {
                        this.state = this.PULSE;
                     }
                     else if(this.prev_weapon == this.PULSE)
                     {
                        this.state = this.FIRE;
                     }
                     else
                     {
                        if(this.player._x < this._x)
                        {
                           this.laser_dir = 1;
                        }
                        else if(this.player._x > this._x)
                        {
                           this.laser_dir = -1;
                        }
                        this.state = this.LASER;
                     }
                  }
               }
            }
            else if(this.state == this.GROWBACK)
            {
               this.checkPlayerInside();
            }
            else if(this.state == this.DIE)
            {
               this.createExplosion();
            }
         }
      }
   }
   function createExplosion()
   {
      this.die_count = this.die_count + 1;
      var _loc3_;
      var _loc2_;
      if(this.die_count % 5 == 0)
      {
         this.exp_count = this.exp_count + 1;
         _loc3_ = _root._random(100) + (this._x - 50);
         _loc2_ = this._y - _root._random(125);
         this.game.createExplosion(_loc3_,_loc2_,"explosion_" + this.exp_count,com.nitrome.toxic.Global.BOMB_BOSS,0);
         this.die_count = 0;
      }
   }
   function fireMissile()
   {
      this.triggerScreenShake();
      this.game.fireMissile(this._x,this._y - 141,this.getPlayerDeg());
   }
   function finishFire()
   {
      this.prev_weapon = this.FIRE;
      this.wait_count = 0;
      this.state = this.WAIT;
   }
   function startPulse()
   {
      this.triggerScreenShake();
      this.debris_1.startDrop();
      this.debris_2.startDrop();
      this.debris_3.startDrop();
      this.debris_4.startDrop();
   }
   function finishPulse()
   {
      this.prev_weapon = this.PULSE;
      this.wait_count = 0;
      this.state = this.WAIT;
   }
   function startLaser()
   {
      this.boss_laser.setActive(true,this.laser_deg,this.laser_dir);
   }
   function startFinishLaser()
   {
      this.prev_weapon = this.LASER;
      _root._gotoAndPlay(this.anim,"out");
   }
   function finishLaser()
   {
      this.wait_count = 0;
      this.state = this.WAIT;
   }
   function checkPlayerInside()
   {
      if(_root.game.grow_holder.hitTest(_root.game._x + this.player._x,_root.game._y + this.player._y,true))
      {
         this.player.forcedGameOver();
      }
   }
   function doHit()
   {
      this.hit_record = this.hit_record + 1;
      if(this.hit_record == 3 && this.state != this.GROW)
      {
         if(this.hit == false)
         {
            this.hits = this.hits - 1;
            this.hit_count = 0;
            _root.boss_health_panel.displayHealth(this.hits * 20);
            this.boss_laser.setActive(false);
            if(this.state == this.LASER && this.hits > 0)
            {
               this.startFinishLaser();
            }
            if(this.hits == 0)
            {
               this.state = this.DIE;
            }
            else
            {
               this.hit = true;
            }
         }
      }
   }
   function finishStart()
   {
      this.state = this.GROW;
   }
   function drawBody()
   {
      this.game.drawBossBody(this._x - 91,this._y - 148);
      if(this.hits == 5)
      {
         _root.cutscene.gotoAndPlay("out");
         _root.boss_health_panel.displayHealth(100);
         _root.boss_health_panel.setActive(true);
         this.player.finishQuickPause();
      }
      else
      {
         _root.game.grow_holder.boss2.gotoAndStop("off");
      }
      this.wait_count = 0;
      this.state = this.WAIT;
   }
   function updateAnim()
   {
      if(this.state != this.prev_state)
      {
         this.gotoAndStop(this.state_array[this.state]);
      }
      this.prev_state = this.state;
   }
   function getPlayerDeg()
   {
      var _loc5_ = this._x - this.player._x;
      var _loc3_ = this._y - 141;
      var _loc6_ = _loc3_ - (this.player._y - 20);
      var _loc4_ = Math.atan2(_loc6_,_loc5_);
      var _loc2_ = Math.round(_loc4_ / 3.141592653589793 * 180);
      if(_loc2_ < 0)
      {
         _loc2_ = 180 + (180 + _loc2_);
      }
      _loc2_ -= 90;
      if(_loc2_ < 0)
      {
         _loc2_ += 360;
      }
      if(_loc2_ >= 360)
      {
         _loc2_ -= 360;
      }
      return _loc2_;
   }
}
