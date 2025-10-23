import godot, godot.control, godot.engine, godot.label, godot.progressbar, godot.tween;

class HUD : GodotScript!Control
{  alias owner this;
   bool isReady;
   Label ammoLabel;
   Label distanceLabel;
   ProgressBar ammoBar;

   @Method _ready()
   {  if (Engine.isEditorHint()) return;
      if (isReady) return;
      scope(success) isReady = true;

      ammoLabel = getNode("VBoxContainer/AmmoLabel").as!Label;
      distanceLabel = getNode("VBoxContainer/DistanceLabel").as!Label;
      ammoBar = getNode("VBoxContainer/ProgressBar").as!ProgressBar;
      ammoBar.value = 100;
   }

   @Method _on_pistol_s_ammo(long arg)
   {  import std.conv;

      _ready();

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
