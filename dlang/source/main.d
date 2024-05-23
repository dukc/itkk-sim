import airdrag, hud, pistol, transformer;
import godot;

mixin GodotNativeLibrary!
(
	// your GDNativeLibrary resource's symbol_prefix
	"fps",

	// a list of all of your script classes
	Airdrag, HUD, Pistol, Transformer
);
