class com.nitrome.game.MusicController extends MovieClip
{
	var fade_interval;
	var game_sound;
	var start;
	var music_on = true;
	var sfx_on = true;
	var music_type = 0;
	var music_ids = new Array("menu_music","game_music");
	var RATE = 60;
	var vol = 0;
	var just_started = true;
	function MusicController()
	{
		super();
		this.game_sound = new Sound(_root.game_music_mc);
		this.game_sound.attachSound(this.music_ids[this.music_type]);
		this.game_sound.setVolume(this.vol);
		this.music_on = _root.ng.getMusicOn();
		this.sfx_on = _root.ng.getSfxOn();
		this.just_started = true;
	}
	function fadeOut(next_track)
	{
		this.vol -= 10;
		this.game_sound.setVolume(this.vol);
		if(this.vol <= 0)
		{
			clearInterval(this.fade_interval);
			this.music_type = next_track;
			this.game_sound.stop();
			this.game_sound.attachSound(this.music_ids[this.music_type]);
			this.game_sound.setVolume(this.vol);
			this.game_sound.onSoundComplete = function()
			{
				this.start();
			};
			this.game_sound.start();
			this.fade_interval = setInterval(this,"fadeIn",this.RATE);
		}
	}
	function fadeIn()
	{
		this.vol += 10;
		this.game_sound.setVolume(this.vol);
		if(this.vol >= 100)
		{
			clearInterval(this.fade_interval);
		}
	}
	function startMenuMusic(from_toggle)
	{
		clearInterval(this.fade_interval);
		trace("startMenuMusic");
		if(this.music_type != 0)
		{
			if(this.music_on == true)
			{
				this.music_type = 0;
				this.fade_interval = setInterval(this,"fadeOut",this.RATE,0);
			}
			else
			{
				this.music_type = 0;
			}
		}
		else if(from_toggle == true)
		{
			if(this.music_on == true)
			{
				this.music_type = 0;
				this.vol = 100;
				this.game_sound.stop();
				this.game_sound.attachSound(this.music_ids[this.music_type]);
				this.game_sound.setVolume(this.vol);
				this.game_sound.onSoundComplete = function()
				{
					this.start();
				};
				this.game_sound.start();
			}
		}
		else if(this.just_started == true && this.music_on == true)
		{
			this.vol = 100;
			this.game_sound.stop();
			this.game_sound.setVolume(this.vol);
			this.game_sound.onSoundComplete = function()
			{
				this.start();
			};
			this.game_sound.start();
			this.just_started = false;
		}
	}
	function startGameMusic(from_toggle)
	{
		clearInterval(this.fade_interval);
		trace("startGameMusic");
		if(this.music_type != 1 || from_toggle == true)
		{
			if(this.music_on == true)
			{
				if(from_toggle == true)
				{
					this.music_type = 1;
					this.vol = 100;
					this.game_sound.stop();
					this.game_sound.attachSound(this.music_ids[this.music_type]);
					this.game_sound.setVolume(this.vol);
					this.game_sound.onSoundComplete = function()
					{
						this.start();
					};
					this.game_sound.start();
				}
				else
				{
					this.music_type = 1;
					this.fade_interval = setInterval(this,"fadeOut",30,1);
				}
			}
			else
			{
				this.music_type = 1;
			}
		}
	}
	function getMusicOn()
	{
		return this.music_on;
	}
	function toggleMusic()
	{
		if(this.music_on == true)
		{
			this.turnOffMusic();
		}
		else if(this.music_on == false)
		{
			this.turnOnMusic();
		}
	}
	function turnOnMusic()
	{
		this.music_on = true;
		if(this.music_type == 0)
		{
			this.startMenuMusic(true);
		}
		else if(this.music_type == 1)
		{
			this.startGameMusic(true);
		}
		_root.ng.setMusicOn(true);
	}
	function turnOffMusic()
	{
		this.music_on = false;
		this.game_sound.stop();
		_root.ng.setMusicOn(false);
	}
	function getSfxOn()
	{
		return this.sfx_on;
	}
	function toggleSfx()
	{
		if(this.sfx_on == true)
		{
			this.turnOffSfx();
		}
		else if(this.sfx_on == false)
		{
			this.turnOnSfx();
		}
	}
	function turnOnSfx()
	{
		this.sfx_on = true;
		_root.ng.setSfxOn(true);
	}
	function turnOffSfx()
	{
		this.sfx_on = false;
		_root.ng.setSfxOn(false);
	}
}
