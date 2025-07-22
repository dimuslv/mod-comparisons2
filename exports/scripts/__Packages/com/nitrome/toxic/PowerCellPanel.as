class com.nitrome.toxic.PowerCellPanel extends MovieClip
{
   var count_text;
   var count = 0;
   function PowerCellPanel()
   {
      super();
   }
   function setCount(n)
   {
      this.count = n;
      this.count_text.text = String(this.count);
   }
   function increment()
   {
      this.count = this.count + 1;
      this.count_text.text = String(this.count);
   }
   function getPowerCellCount()
   {
      return this.count;
   }
}
