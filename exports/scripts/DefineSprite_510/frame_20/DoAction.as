if(!_root.aMode)
{
	if(this._parent.fire_angle == 2)
	{
		this._parent.startFire();
		stop();
	}
	else
	{
		play();
	}
}
