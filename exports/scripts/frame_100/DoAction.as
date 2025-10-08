var pcm = new com.nitrome.toxic.PowerCellMemory();
var total_power_cells = pcm.getTotalCollected();
powercell_text.text = String(total_power_cells + "/" + com.nitrome.toxic.Global.TOTAL_POWER_CELLS);
var level_powercells = new Array();
var i = 1;
while(i <= 40)
{
	level_powercells[i] = pcm.getLevelCollected(i);
	i++;
}
stop();
