onClipEvent(enterFrame){
	var byt = _root.getBytesLoaded();
	var tot = _root.getBytesTotal();
	var p = Math.round(byt / tot * 100);
	this.percent_text.text = String(p + "%");
	this.masker._xscale = p;
	if(byt == tot)
	{
		if(this.done == false)
		{
			_root.tt.doTween("nitrome");
			this.done = true;
		}
	}
	else
	{
		_visible = true;
	}
}
