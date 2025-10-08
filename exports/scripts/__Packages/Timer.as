class Timer
{
	static var time = 0;
	static var fps = 30;
	static var stopped = true;
	function Timer()
	{
	}
	static function init()
	{
		Timer.time = 0;
	}
	static function timeStep()
	{
		if(!Timer.stopped)
		{
			Timer.time++;
		}
	}
	static function setPause(value)
	{
		Timer.stopped = value;
	}
	static function getTimeText()
	{
		var minutes = Math.floor(Timer.time / 60 / Timer.fps);
		var minuteString = minutes >= 100 ? String(minutes) : String(minutes + 100).slice(1);
		var seconds = Math.round(Timer.time % (60 * Timer.fps) / Timer.fps * 1000) / 1000;
		var secondString = String(seconds + 100.0001).slice(1,-1);
		return minuteString + ":" + secondString;
	}
	static function updateTimerWindow(w)
	{
		if(!w.minimized)
		{
			if(w.obj.time !== Timer.time)
			{
				w.obj.time = Timer.time;
				w.obj.title = Timer.getTimeText(Timer.time);
				w.updateMainField(w.obj);
			}
		}
		else if(w.obj.time !== -1)
		{
			w.obj.title = "";
			w.obj.time = -1;
			w.updateMainField(w.obj);
		}
	}
}
