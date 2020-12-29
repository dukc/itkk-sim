import godot, godot.control, godot.label, godot.progressbar, godot.tween;

class HUD : GodotScript!Control
{  alias owner this;
   @OnReady!"VBoxContainer/AmmoLabel" Label ammoLabel;
   @OnReady!"VBoxContainer/ProgressBar" ProgressBar ammoBar;
   @OnReady!"VBoxContainer/Tween" Tween hudTween;
   
   @Method _ready()
   {  import std.conv;
      ammoLabel.text = String(text("Ammunition: ", 15
         /*getParent.getNode(gs!"Arm/Hand/Pistol").get(gs!"max_bullet")*/));
      ammoBar.value = 100;
   }
   
   @Method _on_pistol_s_ammo(int b_count)
   {  import std.conv;
      ammoLabel.text = String(text("Ammunition: ", b_count));
   }
   
   @Method _on_pistol_s_reload(float rDelay)
   {  hudTween.interpolateProperty
         (ammoBar, "value", 0, 100, rDelay, Tween.TransitionType.transLinear,
         Tween.EaseType.easeInOut);
      hudTween.start();
   }
}
