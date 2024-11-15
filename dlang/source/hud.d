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

   @Method _on_pistol_s_ammo(long arg)
   {  import std.conv;

      auto count = arg >> 32;
      auto capacity = arg & 0xFFFF_FFFF;

      ammoLabel.text = String(capacity > 0? text("Laukauksia: ",  count): "Laukauksia: ∞");
      ammoBar.value = capacity > 0? cast(float) count / capacity * 100: 100;
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
