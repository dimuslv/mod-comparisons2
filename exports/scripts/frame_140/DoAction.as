trace("reload");
removeMovieClip(_root.game);
delete _root.game;
_root.loading_clip.gotoAndStop(1);
gotoAndStop("reload2");
