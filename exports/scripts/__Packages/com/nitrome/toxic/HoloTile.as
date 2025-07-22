class com.nitrome.toxic.HoloTile extends MovieClip
{
   var game;
   var row;
   var col;
   function HoloTile()
   {
      super();
   }
   function init(game, row, col)
   {
      this.game = game;
      this.row = row;
      this.col = col;
      this._visible = false;
   }
   function getRow()
   {
      return this.row;
   }
   function getCol()
   {
      return this.col;
   }
   function doDisplay()
   {
      this._visible = true;
   }
   function doHide()
   {
      this._visible = false;
   }
}
