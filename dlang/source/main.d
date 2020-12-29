import hud, pistol, playhook;
import godot.d.register;
import std.stdio;

mixin GodotNativeLibrary!
(
	// your GDNativeLibrary resource's symbol_prefix
	"fps",
	
	// a list of all of your script classes
	HUD, Pistol, PlayHook
);
