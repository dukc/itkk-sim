import airdrag, camerazoomer, distancesensor, gps, hud, report,
	mainmenu, mainscene, missionresult, missionsettings, mousecapturer,
	pistol, sceneswitcher, settingsmenu, transformer;
import godot;

mixin GodotNativeLibrary!
(	"fps",
	Airdrag, CameraZoomer, DistanceSensor, GPS, HUD,
	MainScene, MainMenu, MissionResult, MissionSettingsNode,
	MouseCapturer, Pistol, Report, SceneSwitcher, SettingsMenu, Transformer
);
