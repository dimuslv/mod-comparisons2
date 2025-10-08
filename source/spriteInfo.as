//skipped: BombPanel, BossDebris, BossHealthPanel

_root.spriteInfo = 

{
m168:
	[
		true
	],
m400:
	[
		{
			f101: function(that) {
				that._parent.doExplode();
				_root._stop(that);
			}
		}
	],
m403/*basic_bomb, BasicBomb*/:
	[
		false,
		["anim", 400],
		["vx", "vy", "dir", "on_conveyor"]
	],
m427:
	[
		true
	],
m428/*basic_robot, BasicRobot*/:
	[
		false,
		["anim", 427],
		["dir", "state", "fall_anim_count", "prev_dir", "prev_state", "vx", "vy", "done_splash"]
	],
m470:
	[
		{
			f34: function(that) {
				_root._gotoAndStop(that._parent, "normal");
			}
		}
	],
m471/*bomb_spawner*/:
	[
		false,
		["_anim", 470]
	],
m495/*507*/:
	[
		true
	],
m508/*509*/:
	[
		{
			f10: function(that) {
				that._parent.finishTurn();
				_root._stop(that);
			}
		}
	],
m510/*511*/:
	[
		{
			f10: function(that) {
				if(that._parent.fire_angle == 1)
				{
				   that._parent.startFire();
				   _root._stop(that);
				}
				else
				{
				   _root._play(that);
				}
			},
			f20: function(that) {
				if(that._parent.fire_angle == 2)
				{
				   that._parent.startFire();
				   _root._stop(that);
				}
				else
				{
				   _root._play(that);
				}
			},
			f30: function(that) {
				that._parent.startFire();
				_root._stop(that);
			}
		}
	],
m536:
	[
		{
			f35: function(that) {
				that._parent._parent.doFire();
			},
			f75: function(that) {
				that._parent._parent.resetAim();
				_root._stop(that);
			}
		}
	],
m537/*539*/:
	[
		{
			f1: function(that) {
				_root._gotoAndStop(that, that._parent.fire_angle + 1, 537);
			},
			f2: function(that) {
				_root._stop(that);
			},
			f3: function(that) {
				_root._stop(that);
			},
			f4: function(that) {
				_root._stop(that);
			}
		},
		["head", 536]
	],
m540/*541*/:
	[
		{
			f1: function(that) {
				_root._gotoAndPlay(that, "reset_" + that._parent.fire_angle);
			},
			f31: function(that) {
				that._parent.finishReset();
				_root._stop(that);
			}
		}
	],
m542/*bomber_robot, BomberRobot*/:
	[
		false,
		[
			"anim", [
				100, 540,
				80, 537,
				60, 510,
				40, 508,
				1, 495
			]
		],
		["dir", "state", "fall_anim_count", "#player", "fire_angle", "prev_dir", "prev_state", "aim_next", "vx", "vy", "fire_count", "done_splash"]
	],
m547:
	[
		{
			f16: function(that) {
				that._parent.finishFire();
				_root._stop(that);
			}
		}
	],
m548/*boss_bullet, BossBullet*/:
	[
		false,
		["_anim", 547],
		["dir", "x_speed", "y_speed", "finished"]
	],
m581:
	[
		true
	],
m582/*boss_laser, BossLaser*/:
	[
		false,
		["spark_clip", 581],
		["deg", "rot", "active", "_visible", "laser_count"]
	],
m587/*boss_missile, BossMissile*/:
	[
		true,
		[],
		["deg", "start_x", "start_y", "distance", "_rotation"]
	],
m616:
	[
		{
			f14: function(that) {
				_root._stop(that);
			}
		}
	],
m617:
	[
		{
			f6: function(that) {
				that._parent._parent.triggerScreenShake();
			},
			f16: function(that) {
				_root._stop(that);
			}
		}
	],
m618:
	[
		{
			f356: function(that) {
				that._parent.checkNextStage();
			}
		},
		[
			"_anim", [
				341, 617,
				293, 616,
				268, 617,
				220, 616,
				195, 617,
				147, 616,
				122, 617,
				74, 616,
				49, 617,
				1, 616
			]
		]
	],
m619:
	[
		{
			f22: function(that) {
				that._parent._parent.startJump();
				_root._stop(that);
			}
		}
	],
m620:
	[
		{
			f8: function(that) {
				_root._stop(that);
			}
		}
	],
m621/*610,627*/:
	[
		false
	],
m622:
	[
		{
			f6: function(that) {
				that._parent._parent.triggerScreenShake();
			},
			f16: function(that) {
				that._parent._parent.startWalk();
				_root._stop(that);
			}
		}
	],
m623/*624*/:
	[
		{
			f1: function(that) {
				that._parent._parent.doWalk();
			},
			f30: function(that) {
				that._parent._parent.allowWalk();
			}
		}
	],
m625:
	[
		{
			f8: function(that) {
				that._parent._parent.startMiniJump();
				_root._stop(that);
			}
		}
	],
m626:
	[
		{
			f7: function(that) {
				_root._stop(that);
			}
		}
	],
m628:
	[
		{
			f6: function(that) {
				that._parent._parent.triggerScreenShake();
			},
			f16: function(that) {
				that._parent._parent.startJumpAbout();
				_root._stop(that);
			}
		}
	],
m629:
	[
		{
			f6: function(that) {
				that._parent._parent._parent.triggerScreenShake();
			},
			f16: function(that) {
				_root._stop(that);
			}
		}
	],
m630:
	[
		{
			f1: function(that) {
				that._parent._parent.debris_x_offset = 0;
			},
			f48: function(that) {
				that._parent._parent.debris_x_offset = -224;
			},
			f121: function(that) {
				that._parent._parent.debris_x_offset = 128;
			},
			f194: function(that) {
				that._parent._parent.debris_x_offset = -128;
			},
			f267: function(that) {
				that._parent._parent.debris_x_offset = 224;
			},
			f340: function(that) {
				that._parent._parent.debris_x_offset = 0;
			},
			f356: function(that) {
				that._parent._parent.finishJumpAbout();
			}
		},
		[
			"_anim", [
				341, 629,
				293, 616,
				268, 629,
				220, 616,
				195, 629,
				147, 616,
				122, 629,
				74, 616,
				49, 629,
				1, 616
			]
		]
	],
m635:
	[
		{
			f9: function(that) {
				that._parent._parent.doShoot();
			},
			f45: function(that) {
				that._parent._parent.doShoot();
			},
			f81: function(that) {
				that._parent._parent.doShoot();
			},
			f101: function(that) {
				that._parent._parent.finishFire();
			}
		}
	],
m637:
	[
		false,
		[
			"anim", [
				100, 630,
				90, 628,
				80, 621,
				70, 626,
				60, 625,
				40, 623,
				30, 622,
				20, 621,
				10, 620,
				1, 619
			],
			"_anim", 635
		]
	],
m638/*boss1, FirstBoss*/:
	[
		false,
		[
			"stage_clip", [
				19, 637,
				10, 618,
				1, 621
			]
		]
	],
m649:
	[
		true
	],
m650:
	[
		false,
		["heart", 649]
	],
m654:
	[
		false,
		["_base", 650]
	],
m691:
	[
		true
	],
m692:
	[
		{
			f60: function(that) {
				that._parent.finishStart();
				_root._stop(that);
			}
		},
		["_base", 650, "_electric", 691]
	],
m821:
	[
		{
			f44: function(that) {
				_root.game.safe_holder.boss2.drawBody();
			},
			f45: function(that) {
				_root._stop(that);
			}
		}
	],
m824:
	[
		false,
		["base", 650, "grow", 821, "electric", 691]
	],
m825:
	[
		false,
		["base", 650, "electric", 691]
	],
m831:
	[
		{
			f11: function(that) {
				that._parent.startPulse();
			},
			f60: function(that) {
				that._parent.startPulse();
			},
			f110: function(that) {
				that._parent.startPulse();
			},
			f149: function(that) {
				that._parent.finishPulse();
				_root._stop(that);
			}
		},
		["base", 650, "electric", 691]
	],
m835:
	[
		{
			f30: function(that) {
				that._parent.startLaser();
				_root._stop(that);
			},
			f40: function(that) {
				that._parent.finishLaser();
				_root._stop(that);
			}
		},
		["base", 650, "electric", 691]
	],
m836:
	[
		{
			f9: function(that) {
				_root._gotoAndPlay(that, 1);
			}
		}
	],
m837:
	[
		{
			f25: function(that) {
				that._parent.fireMissile();
			},
			f65: function(that) {
				that._parent.fireMissile();
			},
			f105: function(that) {
				that._parent.fireMissile();
			},
			f145: function(that) {
				that._parent.fireMissile();
			},
			f185: function(that) {
				that._parent.fireMissile();
			},
			f186: function(that) {
				that._parent.finishFire();
			}
		},
		["base", 650, "electric", 691, "eye", 836]
	],
m839:
	[
		{
			f48: function(that) {
				that._parent.finishDie();
				_root._stop(that);
			}
		}
	],
m840/*boss2, FinalBoss*/:
	[
		false,
		[
			"anim", [
				89, 839,
				79, 825,
				69, 837,
				59, 835,
				49, 831,
				39, 825,
				29, 824,
				20, 692,
				1, 654
			]
		]
	],
m841:
	[
		false,
		["anim", 821]
	],
m842/*boss2_grow_layer*/:
	[
		false,
		["anim", 841]
	],
m855:
	[	
		true
	],
m856/*bot, Bot*/:
	[
		false,
		["anim", 855]
	],
m857/*bullet, Bullet*/:
	[
		false,
		["_anim", 547]
	],
m878:
	[
		{
			f22: function(that) {
				that._parent.doFire();
			},
			f35: function(that) {
				that._parent.finishFire();
			}
		}
	],
m880/*cannon, Cannon*/:
	[
		false,
		["anim", 878]
	],
m925:
	[
		{
			f13: function(that) {
				that._parent.setCollapseSize(1);
			},
			f19: function(that) {
				that._parent.setCollapseSize(2);
			},
			f21: function(that) {
				that._parent.setCollapseSize(3);
			},
			f23: function(that) {
				that._parent.setCollapseSize(4);
			},
			f25: function(that) {
				that._parent.setCollapseSize(5);
			},
			f27: function(that) {
				that._parent.setCollapseSize(6);
			},
			f29: function(that) {
				that._parent.finishCollapse();
			}
		}
	],
m926/*collapsing_platform, CollapsingPlatform*/:
	[
		false,
		["anim", 925]
	],
m927/*930,933,936*/:
	[
		true
	],
m928/*931,934,937*/:
	[
		{
			f6: function(that) {
				_root.sfx.playSound("collect");
			},
			f35: function(that) {
				that._parent.finishCollect();
				//_root._stop(that);
			}
		}
	],
m929/*932,935,938*//*collect_basic, collect_digger, collect_platform, collect_walker, BombCollect*/:
	[
		false,
		[
			"anim", [
				10, 928,
				1, 927
			]
		],
		["bomb_type", "spawner", "collected"]
	],
m957/*976,994,996,998,1000*/:
	[
		true
	],
m959/*977,995,997,999,1001*//*conveyor_231, conveyor_232, conveyor_233, conveyor_234, conveyor_235, conveyor_236, ConveyorBelt*/:
	[
		false,
		["anim", 957]
	],
m1250/*1253,1256,1259*/:
	[
		true
	],
m1260:
	[
		false,
		[
			"clip", [
				40, 1259,
				30, 1256,
				20, 1253,
				10, 1250
			]
		]
	],
m1261:
	[
		{
			f102: function(that) {
				that._parent.doExplode();
				_root._stop(that);
			},
			f103: function(that) {
				_root._stop(that);
			}
		},
		["clip", 1260]
	],
m1262/*digger_bomb, DiggerBomb*/:
	[
		false,
		["anim", 1261]
	],
m1273:
	[
		true
	],
m1274/*digger_robot, DiggerRobot*/:
	[
		false,
		["anim", 1273]
	],
m1295:
	[
		{
			f12: function(that) {
				that._parent.finishClose();
			},
			f15: function(that) {
				_root._stop(that);
			}
		}
	],
m1296:
	[
		{
			f11: function(that) {
				that._parent.finishOpen();
			},
			f15: function(that) {
				_root._stop(that);
			}
		}
	],
m1297/*door, Door*/:
	[
		false,
		[
			"_anim", [
				20, 1296,
				10, 1295
			]
		]
	],
m1322:
	[
		{
			f24: function(that) {
				that._parent.startFall();
				_root._stop(that);
			}
		}
	],
m1326:
	[
		false
	],
m1345:
	[
		{
			f20: function(that) {
				that._parent.finishSplash();
				_root._stop(that);
			}
		}
	],
m1346/*drip, Drip*/:
	[
		false,
		[
			"anim", 1322,
			"clip", [
				20, 1345,
				10, 1326
			]
		]
	],
m1373/*explosion1*/:
	[
		{
			f3: function(that) {
				_root.sfx.playSound("explode");
			},
			f5: function(that) {
				that.cutHole();
			},
			f6: function(that) {
				that.checkRobots();
			},
			f13: function(that) {
				_root.game.startCreateGround(that._x,that._y);
			},
			f27: function(that) {
				that.finishExplode();
				_root._stop(that);
			}
		}
	],
m1398/*explosion2*/:
	[
		{
			f3: function(that) {
				_root.sfx.playSound("explode");
			},
			f5: function(that) {
				that.cutHole();
			},
			f6: function(that) {
				that.checkRobots();
			},
			f15: function(that) {
				_root.game.startCreateGround(that._x,that._y);
			},
			f27: function(that) {
				that.finishExplode();
				_root._stop(that);
			}
		}
	],
m1421/*explosion3, 1444 explosion4, 1468 explosion100*/:
	[
		{
			f3: function(that) {
				_root.sfx.playSound("explode");
			},
			f5: function(that) {
				that.cutHole();
			},
			f6: function(that) {
				that.checkRobots();
			},
			f15: function(that) {
				_root.game.startCreateGround(that._x,that._y);
			},
			f25: function(that) {
				that.finishExplode();
				_root._stop(that);
			}
		}
	],
m1467/*explosion5*/:
	[
		{
			f3: function(that) {
				_root.sfx.playSound("explode");
			},
			f5: function(that) {
				that.cutBossHole();
			},
			f6: function(that) {
				that.checkRobots();
			},
			f15: function(that) {
				_root.game.startCreateGround(that._x,that._y);
			},
			f25: function(that) {
				that.finishExplode();
				_root._stop(that);
			}
		}
	],
m1471/*first_door, FirstDoor*/:
	[
		false,
		["_anim", 1296]
	],
m1476/*1481*/:
	[
		true
	],
m1482/*first_info_point, FirstInfoPoint*/:
	[
		false,
		["anim", 1476]
	],
m1489:
	[
		true
	],
m1490:
	[
		{
			f11: function(that) {
				that._parent.doSplash();
			},
			f68: function(that) {
				that._parent.doSplash();
			}
		},
		["anim", 1489]
	],
m1491/*fish, FishRobot*/:
	[
		false,
		["anim", 1490]
	],
m1508:
	[
		true
	],
m1509/*flyer_robot, FlyerRobot*/:
	[
		false,
		["anim", 1508]
	],
m1590:
	[
		true
	],
m1591/*holo_button, HoloButton*/:
	[
		false,
		["_anim", 1590]
	],
m1624/*info_point, InfoPoint*/:
	[
		false,
		["anim", 1476]
	],
m1628/*laser, Laser*/:
	[
		false,
		["spark_clip", 581]
	],
m1879:
	[
		{
			f20: function(that) {
				that._parent.finishCollect();
				_root._stop(that);
			}
		}
	],
m1880/*1881*//*levelbonus, levelend, LevelBonus, LevelEnd*/:
	[
		false,
		["_clip", 1879]
	],
m1884:
	[
		{
			f3: function(that) {
				_root.sfx.playSound("collect");
			},
			f16: function(that) {
				that._parent.finishCollect();
				_root._stop(that);
			}
		}
	],
m1885/*medipak, Medipak*/:
	[
		false,
		["anim", 1884]
	],
m1894:
	[
		true
	],
m1899:
	[
		{
			f8: function(that) {
				_root.sfx.playSound("trigger");
			}
		}
	],
m1900/*mine, Mine*/:
	[
		false,
		[
			"anim", [
				10, 1899,
				1, 1894
			]
		]
	],
m1913:
	[
		true
	],
m1914/*moving_cannon, MovingCannon*/:
	[
		false,
		[
			"anim", [
				20, 878,
				1, 1913
			]
		]
	],
m1927:
	[
		{
			f153: function(that) {
				that._parent.doExplode();
				_root._stop(that);
			}
		}
	],
m1928/*platform_bomb, PlatformBomb*/:
	[
		false,
		["anim", 1927]
	],
m2004:
	[
		{
			f50: function(that) {
				_root.sfx.playSound("levelstart");
			},
			f54: function(that) {
				_root.sfx.playSound("warpin");
			},
			f55: function(that) {
				Timer.setPause(false);
			},
			f111: function(that) {
				that._parent.finishStart();
				//_root._stop(that);
			}
		}
	],
m2013/*2038,2052*/:
	[
		true
	],
m2018:
	[
		false
	],
m2025:
	[
		{
			f3: function(that) {
				_root._stop(that);
			}
		}
	],
m2047:
	[
		{
			f12: function(that) {
				_root._stop(that);
			}
		}
	],
m2057:
	[
		{
			f24: function(that) {
				that._parent.finishHit();
			}
		}
	],
m2086:
	[
		{
			f50: function(that) {
				that._parent.finishDie();
				_root._stop(that);
			}
		}
	],
m2120:
	[
		{
			f1: function(that) {
				if (!that._parent.hit) {
					Timer.setPause(true);
					_root.sfx.playSound("levelend");
				}
			},
			f4: function(that) {
				_root.sfx.playSound("warpout");
			},
			f35: function(that) {
				that._parent.finishEnd();
				_root._stop(that);
			}
		}
	],
m2121/*player, Player*/:
	[
		false,
		[
			"anim", [
				200, 2120,
				180, 2086,
				160, 2057,
				140, 2013,
				100, 2047,
				80, 2013,
				60, 2025,
				39, 2018,
				20, 2013,
				1, 2004
			]
		]
	],
m2156:
	[
		true
	],
m2157:
	[
		{
			f3: function(that) {
				_root.sfx.playSound("collect");
			},
			f16: function(that) {
				that._parent.finishCollect();
				_root._stop(that);
			}
		},
		["anim", 2156]
	],
m2158/*powercell, PowerCell*/:
	[
		false,
		[
			"anim", [
				10, 2157,
				1, 2156
			]
		]
	],
m2170/*shooter_bullet, ShooterBullet*/:
	[
		false,
		["_anim", 547]
	],
m2181:
	[
		{
			f7: function(that){
				that._parent.doFire();
			}
		}
	],
m2183/*shooter_robot, ShooterRobot*/:
	[
		false,
		["anim", 2181]
	],
m2202/*2203*/:
	[
		true
	],
m2204:
	[
		false,
		["leg1", 2202, "leg2", 2202, "leg3", 2202, "leg4", 2202]
	],
m2205/*spider, Spider*/:
	[
		false,
		["anim", 2204]
	],
m2226/*splash*/:
	[
		{
			f21: function(that) {
				that._parent._parent.finishSplash(that._name);
				_root._stop(that);
			}
		}
	],
m2227:
	[
		true
	],
m2243/*2259*/:
	[
		true
	],
m2252:
	[
		true
	],
m2260:
	[
		true,
		["fan2", 2243, "clip", 2252, "fan", 2243]
	],
m2263:
	[
		true,
		["fan2", 2243, "fan", 2243]
	],
m2264/*stinger_robot, StingerRobot*/:
	[
		false,
		[
			"anim", [
				30, 2263,
				1, 2260
			]
		]
	],
m2286:
	[
		{
			f25: function(that) {
				that._parent.doFire();
			}
		}
	],
m2287/*tall_cannon, Cannon*/:
	[
		false,
		["_anim", 2286]
	],
m2323:
	[
		true
	],
m2324/*walker_bomb, WalkerBomb*/:
	[
		false,
		["anim", 2323]
	],
m2333:
	[
		true
	],
m2334/*wheel_robot, WheelRobot*/:
	[
		false,
		["anim", 2333]
	],
m2350:
	[
		{
			f6: function(that) {
				that._parent.checkForPlayer(false);
			},
			f18: function(that) {
				that._parent.checkForPlayer(false);
			}
		}
	],
m2361:
	[
		{
			f15: function(that) {
				that._parent.finishAlert();
			}
		}
	],
m2375:
	[
		true
	],
m2376/*wheelie_robot, WheelieRobot*/:
	[
		false,
		[
			"anim", [
				40, 2375,
				20, 2361,
				1, 2350
			]
		]
	],
m2610/*2625*/:
	[
		true
	],
m2611/*2612,2626,2627*//*tile_268, tile_269, tile_270, tile_271*/:
	[
		true,
		["anim", 2610, "splash", 2227, "bubbles", 168]
	],
m2628/*2629*//*tile_258, tile_257*/:
	[
		false,
		["anim", 2610, "splash", 2227]
	],
m2630/*2631*//*tile_256, tile_255*/:
	[
		false,
		["anim", 2610]
	],
m2632/*2633*//*tile_201, tile_202*/:
	[
		true,
		["anim", 168]
	]
}
;