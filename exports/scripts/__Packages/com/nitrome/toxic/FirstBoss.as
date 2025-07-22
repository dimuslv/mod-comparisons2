class com.nitrome.toxic.FirstBoss extends MovieClip
{
   var stage_clip;
   var game;
   var state;
   var dir;
   var no_transform;
   var red_transform;
   var min_x;
   var max_x;
   var player;
   var step_count;
   var prev_state = 100;
   var prev_dir = 100;
   var state_array = new Array("start_","wait_","fall","crouch","jump","land","walk_","minicrouch","minijump","minifall","miniland","jumpabout","fire","dead");
   var dir_array = new Array("left","right");
   var next_point = 0;
   var can_walk = false;
   var vx = 0;
   var vy = 0;
   var max_vy = 12;
   var START = 0;
   var WAIT = 1;
   var FALL = 2;
   var CROUCH = 3;
   var JUMP = 4;
   var LAND = 5;
   var WALK = 6;
   var MINICROUCH = 7;
   var MINIJUMP = 8;
   var MINIFALL = 9;
   var MINILAND = 10;
   var JUMPABOUT = 11;
   var FIRE = 12;
   var DEAD = 13;
   var stage = 0;
   var next_stage = 0;
   var hits = 9;
   var hit = false;
   var hit_count = 0;
   var max_hit_count = 120;
   var debris = new Array({id:36,x:47,y:-143},{id:37,x:-47,y:-143},{id:38,x:0,y:-114},{id:39,x:67,y:-13},{id:40,x:67,y:-45},{id:41,x:67,y:-62},{id:42,x:67,y:-78},{id:43,x:67,y:-95},{id:44,x:67,y:-133},{id:45,x:0,y:-147},{id:46,x:-67,y:-13},{id:47,x:-67,y:-45},{id:48,x:-67,y:-62},{id:49,x:-67,y:-78},{id:50,x:-67,y:-95},{id:51,x:-67,y:-133});
   var debris_x_offset = 0;
   var wait_count = 0;
   var door_wait_count = 50;
   var max_wait_count = 100;
   var adj_scroll = false;
   var end_seq = false;
   var chid = 638;
   function FirstBoss()
   {
      super();
   }
   function doPause()
   {
      if(this.stage != 0)
      {
         if(this.stage == 1)
         {
            _root._stop(this.stage_clip);
         }
         else if(this.stage == 2)
         {
            _root._stop(this.stage_clip.anim);
         }
         else if(this.stage == 3)
         {
            _root._stop(this.stage_clip.anim);
         }
      }
   }
   function doUnpause()
   {
      if(this.stage != 0)
      {
         if(this.stage == 1)
         {
            _root._play(this.stage_clip);
         }
         else if(this.stage == 2)
         {
            _root._play(this.stage_clip.anim);
         }
         else if(this.stage == 3)
         {
            _root._play(this.stage_clip.anim);
         }
      }
   }
   function init(game)
   {
      this.game = game;
      this.state = this.START;
      this.dir = _root._random(2);
      this.vx = 0;
      this.vy = 0;
      this.no_transform = this.transform.colorTransform;
      this.red_transform = new flash.geom.ColorTransform(0,1,1,1,150,0,0,0);
      this.min_x = 641;
      this.max_x = 1119;
      this.updateAnim();
   }
   function setPlayer(player)
   {
      this.player = player;
   }
   function triggerScreenShake()
   {
      _root.sfx.playSound("stomp");
      this.game.startScreenShake();
   }
   function main()
   {
      if(this.hit == true)
      {
         this.hit_count = this.hit_count + 1;
         if(this.hit_count % 10 == 0)
         {
            this.transform.colorTransform = this.red_transform;
         }
         else if(this.hit_count % 5 == 0)
         {
            this.transform.colorTransform = this.no_transform;
         }
         if(this.hit_count >= this.max_hit_count)
         {
            this.transform.colorTransform = this.no_transform;
            this.hit = false;
         }
      }
      if(this.stage == 0)
      {
         if(this.state == this.START)
         {
            if(this.player._x > this._x - 57 - 100 && this.player._x < this._x + 57 - 100)
            {
               _root.cutscene.gotoAndPlay("in");
               this.player.quickPause();
               this.wait_count = 0;
               this.state = this.WAIT;
            }
         }
         else if(this.state == this.WAIT)
         {
            this.wait_count = this.wait_count + 1;
            if(this.wait_count == this.door_wait_count)
            {
               this.game.nextDoor(0);
               this.game.nextDoor(1);
            }
            if(this.wait_count >= this.max_wait_count)
            {
               this.state = this.FALL;
            }
         }
         else if(this.state == this.FALL)
         {
            this.doFall();
         }
      }
      else if(this.stage == 1)
      {
         if(this.adj_scroll == false)
         {
            if(this.player._x > this._x - 57 - 48 && this.player._x < this._x + 57 - 48)
            {
               this.game.adjustScroll(1);
               this.adj_scroll = true;
            }
         }
      }
      else if(this.stage == 2 || this.stage == 3)
      {
         this.updateAnim();
         if(this.state != this.CROUCH)
         {
            if(this.state == this.JUMP)
            {
               this._y += this.vy;
               if(this.getOnScreen() == false)
               {
                  this.targetPlayer();
                  this.vy = 5;
                  this.state = this.FALL;
               }
            }
            else if(this.state == this.FALL)
            {
               this.moveToPlayer();
               this.vy = this.vy + 1;
               if(this.vy > this.max_vy)
               {
                  this.vy = this.max_vy;
               }
               this._y += this.checkFloor(this.vy);
               if(this.getOnGround(this._x,this._y) == true)
               {
                  this.state = this.LAND;
               }
            }
            else if(this.state != this.LAND)
            {
               if(this.state != this.WALK)
               {
                  if(this.state != this.MINICROUCH)
                  {
                     if(this.state == this.MINIJUMP)
                     {
                        this._y += this.vy;
                        if(this.getOnScreen() == false)
                        {
                           this._x = 880;
                           this.state = this.MINIFALL;
                        }
                     }
                     else if(this.state == this.MINIFALL)
                     {
                        this.vy = this.vy + 1;
                        if(this.vy > this.max_vy)
                        {
                           this.vy = this.max_vy;
                        }
                        this._y += this.checkFloor(this.vy);
                        if(this.getOnGround(this._x,this._y) == true)
                        {
                           this.state = this.MINILAND;
                        }
                     }
                     else if(this.state != this.MINILAND)
                     {
                        if(this.state != this.JUMPABOUT)
                        {
                           if(this.state == this.DEAD)
                           {
                              if(this.player._x > 992)
                              {
                                 this.wait_count = this.wait_count + 1;
                                 if(this.end_seq == false)
                                 {
                                    _root.cutscene.gotoAndPlay("in");
                                    this.player.quickPause();
                                    this.end_seq = true;
                                 }
                                 if(this.wait_count == this.door_wait_count)
                                 {
                                    this.game.openDoor(1);
                                 }
                                 if(this.wait_count >= this.max_wait_count)
                                 {
                                    _root.cutscene.gotoAndPlay("out");
                                    this.player.finishQuickPause();
                                    this.finishDead();
                                 }
                              }
                           }
                        }
                     }
                  }
               }
            }
         }
      }
   }
   function finishDead()
   {
      this.game.smoothScroll();
      this.removeMovieClip();
   }
   function doShoot()
   {
      this.game.fireBossBullet(this._x + this.stage_clip._x + this.stage_clip.bullet_1._x,this._y + this.stage_clip._y + this.stage_clip.bullet_1._y,1);
      this.game.fireBossBullet(this._x + this.stage_clip._x + this.stage_clip.bullet_2._x,this._y + this.stage_clip._y + this.stage_clip.bullet_2._y,2);
      this.game.fireBossBullet(this._x + this.stage_clip._x + this.stage_clip.bullet_3._x,this._y + this.stage_clip._y + this.stage_clip.bullet_3._y,3);
   }
   function finishFire()
   {
      this.state = this.CROUCH;
   }
   function targetPlayer()
   {
      var _loc2_ = this.player._x;
      if(_loc2_ < this.min_x)
      {
         _loc2_ = this.min_x;
      }
      if(_loc2_ > this.max_x)
      {
         _loc2_ = this.max_x;
      }
      this._x = _loc2_;
   }
   function moveToPlayer()
   {
      var _loc2_ = this.player._x;
      if(_loc2_ < this._x)
      {
         _loc2_ += 5;
      }
      else if(_loc2_ > this._x)
      {
         _loc2_ -= 5;
      }
      if(_loc2_ < this.min_x)
      {
         _loc2_ = this.min_x;
      }
      if(_loc2_ > this.max_x)
      {
         _loc2_ = this.max_x;
      }
      this._x = _loc2_;
   }
   function finishJumpAbout()
   {
      if(this.stage == 2)
      {
         this.state = this.CROUCH;
      }
      else if(this.stage == 3)
      {
         this.state = this.FIRE;
      }
      this.checkNextStage();
   }
   function startJumpAbout()
   {
      this.state = this.JUMPABOUT;
      if(this.stage == 3)
      {
         this.checkNextStage();
      }
   }
   function startWalk()
   {
      this.can_walk = false;
      this.step_count = 0;
      var _loc3_ = this.max_x - this.min_x;
      var _loc4_ = this._x - this.min_x;
      var _loc2_ = _loc4_ / _loc3_ * 100;
      if(_loc2_ <= 50)
      {
         this.dir = 1;
      }
      else
      {
         this.dir = 0;
      }
      this.state = this.WALK;
   }
   function startJump()
   {
      this.vy = -12;
      this.state = this.JUMP;
   }
   function startMiniJump()
   {
      this.vy = -12;
      this.state = this.MINIJUMP;
   }
   function getOnScreen()
   {
      if(this.hitTest(_root.screen_test) == true)
      {
         return true;
      }
      return false;
   }
   function doExplode()
   {
      var _loc4_;
      var _loc3_;
      if(this.hit == false)
      {
         this.hits = this.hits - 1;
         this.hit_count = 0;
         _root.boss_health_panel.displayHealth(this.hits * 11.1);
         if(this.stage == 1 && this.hits == 6)
         {
            this.nextStage();
         }
         else if(this.stage == 2 && this.hits == 3)
         {
            this.nextStage();
         }
         else if(this.stage == 3 && this.hits == 0)
         {
            if(this.state == this.JUMPABOUT)
            {
               this.game.createExplosion(this._x + this.debris_x_offset,this._y,this._name,100);
               _loc4_ = this.debris;
               _loc3_ = 0;
               while(_loc3_ < _loc4_.length)
               {
                  _loc4_[_loc3_].x += this.debris_x_offset;
                  _loc3_ = _loc3_ + 1;
               }
               this.game.createDebris(this._x + this.debris_x_offset,this._y,_loc4_);
            }
            else
            {
               this.game.createExplosion(this._x,this._y,this._name,100);
               this.game.createDebris(this._x,this._y,this.debris);
            }
            this.wait_count = 0;
            this.state = this.DEAD;
            this.gotoAndStop("dead");
         }
         this.hit = true;
      }
   }
   function nextStage()
   {
      this.next_stage = this.stage + 1;
   }
   function checkNextStage()
   {
      if(this.next_stage != 0)
      {
         this.stage = this.next_stage;
         if(this.stage == 2)
         {
            this.state = this.CROUCH;
         }
         else if(this.stage == 3)
         {
            this.state = this.FIRE;
         }
         this.gotoAndStop("stage_" + this.stage);
         this.next_stage = 0;
      }
   }
   function doFall()
   {
      this.vy = this.vy + 1;
      if(this.vy >= this.max_vy)
      {
         this.vy = this.max_vy;
      }
      this._y += this.checkFloor(this.vy);
      if(this.getOnGround(this._x,this._y) == true)
      {
         this.triggerScreenShake();
         this.gotoAndStop("stage_1");
         _root.boss_health_panel.displayHealth(100);
         _root.boss_health_panel.setActive(true);
         _root.cutscene.gotoAndPlay("out");
         this.player.finishQuickPause();
         this.stage = 1;
      }
   }
   function getOnGround(x, y)
   {
      if(this.game.getSceneryCollision(x,y) == true)
      {
         if(this.game.getSceneryCollision(x,y - 1) == false)
         {
            return true;
         }
         return false;
      }
      return false;
   }
   function checkFloor(v)
   {
      v = Math.round(v);
      var _loc2_ = 1;
      while(_loc2_ <= v)
      {
         if(this.getInWall(this._x,this._y + _loc2_) == true)
         {
            return _loc2_;
         }
         _loc2_ = _loc2_ + 1;
      }
      return v;
   }
   function getInWall(x, y)
   {
      if(this.game.getSceneryCollision(x,y) == true)
      {
         return true;
      }
      return false;
   }
   function allowWalk()
   {
      this.can_walk = true;
   }
   function doWalk()
   {
      if(this.can_walk == true)
      {
         if(this.dir == com.nitrome.toxic.Global.LEFT)
         {
            this._x -= 20;
            if(this._x < this.min_x)
            {
               this._x = this.min_x;
            }
         }
         else if(this.dir == com.nitrome.toxic.Global.RIGHT)
         {
            this._x += 20;
            if(this._x > this.max_x)
            {
               this._x = this.max_x;
            }
         }
         this.can_walk = false;
      }
      this.step_count = this.step_count + 1;
      if(this.step_count == 8)
      {
         this.state = this.MINICROUCH;
      }
   }
   function updateAnim()
   {
      if(this.dir != this.prev_dir || this.state != this.prev_state)
      {
         if(this.state == this.WALK)
         {
            _root._gotoAndStop(this.stage_clip,this.state_array[this.state] + this.dir_array[this.dir],this.stage >= 2 ? 637 : 0);
         }
         else
         {
            _root._gotoAndStop(this.stage_clip,this.state_array[this.state],this.stage >= 2 ? 637 : 0);
         }
      }
      this.prev_dir = this.dir;
      this.prev_state = this.state;
   }
}
