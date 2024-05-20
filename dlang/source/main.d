import hud, pistol, playhook, transformer;
import godot;

mixin GodotNativeLibrary!
(
	// your GDNativeLibrary resource's symbol_prefix
	"fps",

	// a list of all of your script classes
	HUD, Pistol, Transformer
);
