trace("reload");
removeMovieClip(_root.game);
delete _root.game;
if(false)
{
   _root.loading_clip.gotoAndStop(1);
}
gotoAndStop("reload2");
