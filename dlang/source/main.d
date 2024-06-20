import airdrag, camerazoomer, distancesensor, gps, hud, report,
	mainscene, missionresult, mousecapturer, pistol, sceneswitcher, transformer;
import godot;

mixin GodotNativeLibrary!
(	"fps",
	Airdrag, CameraZoomer, DistanceSensor, GPS, HUD,
	MainScene, MissionResult, MouseCapturer, Pistol,
	Report, SceneSwitcher, Transformer
);
