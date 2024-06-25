import godot, godot.control, godot.engine, godot.label, godot.progressbar, godot.tween;

class HUD : GodotScript!Control
{  alias owner this;
   @OnReady!"VBoxContainer/AmmoLabel" Label ammoLabel;
   @OnReady!"VBoxContainer/DistanceLabel" Label distanceLabel;
   @OnReady!"VBoxContainer/ProgressBar" ProgressBar ammoBar;

   @Method _ready()
   {  if (Engine.isEditorHint()) return;

         // getParent.getNode(gs!"Arm/Hand/Pistol").get(gs!"max_bullet")));
      ammoBar.value = 100;
   }

   @Method _on_pistol_s_ammo(int b_count)
   {  import std.conv;
      ammoLabel.text = String(text("Laukauksia: ", b_count));
   }

   @Method _updateDistance(float distance)
   {  import std.conv;
      distanceLabel.text = String(text("Etäisyys: ", cast(long) distance, "m"));
   }

   @Method _on_pistol_s_reload(float rDelay)
   {  createTween().tweenProperty
         (ammoBar, "value", 100, rDelay)
         .from(0)
         .setTrans(Tween.TransitionType.transLinear)
         .setEase(Tween.EaseType.easeInOut);
   }
}
