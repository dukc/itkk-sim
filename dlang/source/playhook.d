import godot, godot.audiostreamplayer;

class PlayHook : GodotScript!AudioStreamPlayer
{  @Method void _play(){owner.playing = true;}
}
